function endtime = JustRun(x_zero,modelName)
%% AddPath
addpath('param');
addpath('Library');

param = x_zero; 
direction = 'sag'; 
DistRun = 0;

%% Run
    TrialRunON = 1; save('TrialRunON.mat','TrialRunON');
    
    % Measurements
    load_system(modelName)
    set_param([modelName,'/Data Logging'],'commented','off')
    
    simOut = sim(modelName,...
            'SimulationMode', 'accelerator',...
            'SrcWorkspace','current');
    t = simOut.get('tout')';
    endtime = t(end);  
    
    delete('TrialRunON.mat')
    set_param([modelName,'/Data Logging'],'commented','on')
end
