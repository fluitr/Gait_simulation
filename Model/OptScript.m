clear, clc

%% Opt Script
addpath('param');
addpath('Library');

setenv('VSCMD_START_DIR','%CD%')

%% Overal options 
resume = 0;
mat_restart = 1;
tot_run = 10;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Update of model
functionName = 'OptFun_forward';

% check settings of runScripts.m for model settings
global SetOptIC SetOptIMP v_d

SetOptIC = 1; % Co-optimize initial conditions too (+11 param)
SetOptIMP = 1; % Co-optimize foot impedance settings (+3 param)
v_d = 1;
<<<<<<< HEAD
=======
functionName = 'OptFun_forCPG';
>>>>>>> Git init
=======
>>>>>>> Update of model

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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Update of model
        if ~SetOptIMP && ~SetOptIC
            load('param_02cm.mat');
        end
        if SetOptIMP && ~SetOptIC
            load('param_02cm_IMP.mat');
        end
        if SetOptIC && SetOptIMP
            load('param_NMS_IC_IMP.mat');
        end
<<<<<<< HEAD
=======
%         load('param_V103_for_wAnkleCPG.mat');
<<<<<<< HEAD
        load('param_02cm.mat');
>>>>>>> Git init
=======
        load('param_02cm_IMP.mat');
<<<<<<< HEAD
>>>>>>> updated model for 1.3 m/s, optimized ankle impedance
        x_zero = param;
=======
        x_zero = param(1:end-3);
>>>>>>> Updata for speed
=======
        x_zero = param;
>>>>>>> Update of model
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
%     opts.ParforRun = 1;
%     opts.ParforWorkers = 20;
%     
%     if opts.ParforRun == 1
%         p = gcp;
%     end
        
    % Other options
    opts.Noise.on = 0;
    opts.PopSize = 20;
    opts.SaveFilename = 'OptData/cmaes_var.mat';
    opts.LogFilenamePrefix ='OptData/cmaes_out';
    opts.LogPlot = 0;
    opts.MaxFunEvals = 12000; 
%     opts.LBounds = [0 -10 0 0.9 1.2]';
%     opts.UBounds = [10 0 10 1.3 1.5]';
    
    %% Sigma list
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    sigma_list = ones(90+SetOptIC*11+SetOptIMP*3,1);
=======
    sigma_list = ones(90,1);
>>>>>>> Git init
=======
    sigma_list = ones(93,1);
>>>>>>> updated model for 1.3 m/s, optimized ankle impedance
=======
    sigma_list = ones(90+SetOptIC*11+SetOptIMP*3,1);
>>>>>>> Update of model
    sigma_list(1) = 0.56;
    sigma_list([2:4 73:75]) = 0.025;
    sigma_list(5) = 0.03;
    sigma_list([6:14 76 77]) = 0.15;
    sigma_list([15:35 78:84]) = 0.025;
    sigma_list([44:52 85 86]) = 0.47;
    sigma_list([53:70 87 88]) = 0.025;
    sigma_list([71 72 89 90]) = 0.22;
    sigma_list = sigma_list .* 2; 
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Update of model
    if SetOptIC
        sigma_list([91 100 101]) = [0.1 0.05 0.02];
        sigma_list(92:98) = 0.2;
    end
    if SetOptIMP
        sigma_list([91 92 93]+SetOptIC*11) = [0.5 0.05 0.5];
    end
<<<<<<< HEAD
=======
>>>>>>> Git init
=======
    sigma_list([91 92 93]) = [0.5 0.05 0.5];
>>>>>>> updated model for 1.3 m/s, optimized ankle impedance
=======
>>>>>>> Update of model
    
    % Ankle Module
    sigma_list(36) = 0.05;
    sigma_list(37:39) = 0.5;
    sigma_list(40) = 0.05;
    sigma_list(41:43) = 0.5;
    
    if size(x_zero,1) == 82
        sigma_list(36:43) = [];
    end
    
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
