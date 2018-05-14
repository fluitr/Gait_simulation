clc; clear; warning off
%% CHANGES
saveOn = 1;

%% AddPaths
addpath('param');
addpath('Library');

%% Settings
modelName = 'nms_3Dmodel_inv_wAnkle';
paramName = 'param_V35_inv_wAnkle';
copyfile('DataSets/SFM_AS_Set13CombAllnIns','HumanData')    % Parameter set

%% Loading parameters
load(paramName)

%% Commenting in data logging
load_system(modelName)
set_param([modelName,'/Data Logging'],'commented','off')

%% Trial
% Simulate
sim(modelName,...
    'SimulationMode', 'accelerator');

if saveOn == 1
    % Copy result
    copyfile('Records',['RecordsFolder/',paramName])
end

%Commenting out
set_param([modelName,'/Data Logging'],'commented','on')