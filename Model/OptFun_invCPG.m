function val = OptFun_parfor(x)
%% This function runs the simulation for optimalisation
%% param
assignin('base','param',x);

%% Try to prevent stop after error
try
    %% Simulating
    simOut = sim('nms_3Dmodel_inv_wAnkleCPG',...
        'SimulationMode', 'accelerator',...
             'SrcWorkspace','base',...
            'ExternalInput','param',...
        'SaveOutput','on','OutputSaveName','yout',...
        'SaveFormat', 'Dataset');    
    outputs = simOut.get('yout');
    t = simOut.get('tout')';
    Torque_nmc_opt = outputs.get('data').Values.torques.Data';
    Muscle_act = outputs.get('data').Values.muscle_act.Data';
    
    %% Loading Torques and Phase
    load('HumanData/Torque_mat.mat')
    load('HumanData/Torque_std_mat.mat')
    load('HumanData/Phase_mat.mat')
    
    %% Extracting parameters
    % Healthy torques
    Torque_mark = Torque_mat(2:end,:);
    Torque_std_mark = Torque_std_mat(2:end,:);
    
    %Phase
    Phase = Phase_mat(2,:);
    
    %% Analysis
    OnlyLeft = 1;
    if OnlyLeft == 1
        indcom = 1:4;
    else
        indcom = 1:8;
    end
    
    % Start at second step
    i_start = find(Phase == 1 & t>0.5,1);
    t = t(i_start:end);
     
    % Calculating diff
    % Absolute difference
    tor_diff = abs(Torque_mark(indcom,i_start:end)-Torque_nmc_opt(indcom,i_start:end));
    
    % Normalizing with STD
	norm_tor_diff = tor_diff./mean(mean((Torque_std_mark(indcom,i_start:end))));
    
    % Mean Difference
    mdiff = mean(mean(norm_tor_diff));
       
    %% Cost function
    val = mdiff;
catch ME
    val = NaN;
    disp(['Error in calculation: ',ME.identifier]);
end
end