clear, clc

%% Opt Script
addpath('param');
addpath('Library');
slblocks
setenv('VSCMD_START_DIR','%CD%')

%% Overal options 
resume = 0;
mat_restart = 1;
tot_run = 10;
functionName = 'OptFun_forward';

% check settings of runScripts.m for model settings
% global v_d
% v_d = 1;

% Copy to optfun!
SetOptIC = 1; % Co-optimize initial conditions too (+1-11 param)
paramIC_opt = 1;
SetOptIMP = 0; % Co-optimize foot impedance settings (+3 param)


%% Setting resume options
% Second time (after Matlab restart) or in case of a manual restart
if exist('restart.mat','file') == 2
    resume = 0;
    load('OptData/OptSaver.mat')
    delete('restart.mat')
elseif resume == 1
    load('OptData/cmaes_var.mat','out');x = out.solutions.bestever.x;
    
    % Trial to build model in case of restart
    val = feval(functionName,x);
    disp(['Bestever until now: ',num2str(val)]); clear out val;
    load('OptData/OptSaver.mat')
else 
    % In case of real start
    i_opts = 1;
    %% Restart check
    choice = questdlg('Do you really want to start a new Simulation run?', ...
        'Restart?', ...
        'Yes, make backup','Yes, no backup','No','No');
    switch choice
        case('Yes, make backup')
            copyfile('Simulations','Simulations_old')
            rmdir('Simulations','s'); mkdir('Simulations');
            fopen('Simulations/keep_folder.txt','w');fclose('all');
            copyfile('OptData','OptData_old')
            rmdir('OptData','s'); mkdir('Optdata');
            fopen('OptData/keep_folder.txt','w');fclose('all');
        case('Yes, no backup')
            rmdir('Simulations','s'); mkdir('Simulations')
            fopen('Simulations/keep_folder.txt','w');fclose('all');
        otherwise
            return
    end
end

while i_opts <= tot_run
    %% Set x_zero to param or to previously found best 
    if i_opts == 1
        if ~SetOptIMP && ~SetOptIC
            load('param_02cm.mat');
            load('C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1\Base_par2.mat')
        end
        if SetOptIMP && ~SetOptIC
            load('param_02cm_IMP.mat');
        end
        if ~SetOptIMP && SetOptIC
            load('param_NMS_IC_IMP.mat');
            load('C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1\Base_par2.mat')
            param = [param(1:90); 1];
%             sigma = [sigma; 0.1];
        end
        if SetOptIMP && SetOptIC
            load('param_NMS_IC_IMP.mat');
            param = param([1:90 90+paramIC_opt 102:104]);
        end
        x_zero = param;
    else
        load(['Simulations/Sim',num2str(i_opts-1),'/cmaes_var.mat'],'out')
        x_zero = out.solutions.bestever.x; clear out;      
    end

    %% Build Model
    if strcmp(functionName,'OptFun_hyb')
        init_val = feval('OptFun_forCPG',x_zero);
        disp(['Initial value forward: ',num2str(init_val)]); clear val;
    end
    
    %Resume
    if exist('resume','var')
        % Only set to one on first run
        opts.resume = resume;
        clear resume;
    else
        opts.resume = 0;    
    end
    
    % Overal save of options
    if opts.resume == 0
        % Outcome list
        val_list = [];
    end
    
    %% Manual Options
    % Parpool settings
    opts.ParforRun = 1;
    opts.ParforWorkers = 4;
    
    if opts.ParforRun == 1
        p = gcp;
    end
        
    % Other options
    opts.Noise.on = 1;
    opts.PopSize = 20;
    opts.SaveFilename = 'OptData/cmaes_var.mat';
    opts.LogFilenamePrefix ='OptData/cmaes_out';
    opts.LogPlot = 0;
    opts.MaxFunEvals = 12000; 
%     opts.LBounds = [0 -10 0 0.9 1.2]';
%     opts.UBounds = [10 0 10 1.3 1.5]';
    
    %% Sigma list

    sigma_list = ones(90+SetOptIC*length(paramIC_opt)+SetOptIMP*3,1);
    sigma_list(1) = 0.56;
    sigma_list([2:4 73:75]) = 0.1; %0.025;
    sigma_list(5) = 0.1; %0.03;
    sigma_list([6:14 76 77]) = 0.15;
    sigma_list([15:35 78:84]) = 0.1; %0.025;0.025;
    sigma_list([44:52 85 86]) = 0.47;
    sigma_list([53:70 87 88]) = 0.1; %0.025;
    sigma_list([71 72 89 90]) = 0.22;
    sigma_list = sigma_list .* 2; 
    if SetOptIC
        sigma_list([91:90+length(paramIC_opt)]) = 0.05;
    end
    sigma_list([1 16 36 45 46 50 51 71 72 86 89]) = 2;
    if SetOptIMP
        sigma_list([91 92 93]+SetOptIC*length(paramIC_opt)) = [0.5 0.5 0.05];
    end
    
    % Ankle Module
    sigma_list(36) = 0.05;
    sigma_list(37:39) = 0.5;
    sigma_list(40) = 0.05;
    sigma_list(41:43) = 0.5;
    
    if size(x_zero,1) == 82
        sigma_list(36:43) = [];
    end
%     sigma_list = sigma;
    
    %% Optimalization
    save('OptData/OptSaver.mat','val_list','i_opts')
    [xmin,fmin,counteval,stopflag,out,bestever] = cmaes_parfor(functionName,x_zero,sigma_list,opts)
    
    %% Saving Optimization 
    copyfile('OptData',['Simulations/Sim',num2str(i_opts)])
    
    %% Breaking or continuing    
    if strcmp(stopflag{:},'manual')
        break;
    else
        i_opts = i_opts+1;
    end
    
    if i_opts < tot_run && mat_restart == 1
        restart_now = 1;
        save('restart.mat','restart_now')
        save('OptData/OptSaver.mat','val_list','i_opts')
        quit
    end    
end

if strcmp(stopflag{:},'manual')
    fid = fopen('signals.par','w');
    fprintf(fid,'%% stop OptData/cmaes_out');
    fclose(fid);
end
