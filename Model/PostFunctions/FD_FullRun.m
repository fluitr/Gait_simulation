clear all, close all, clc

%% DONE:
% 'param_V46_hyb_wAnkleCPG', Flat floor, [-256:64:256]

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% FD SUPERSCRIPT
paramNameList = {'param_V46_hyb_wAnkleCPG'};
modelNameList = {'nms_3Dmodel_for_wAnkleCPG'};

i_param = 1;
while i_param <= length(paramNameList)
    % Global settings    
    modelName = modelNameList{i_param};
    paramName = paramNameList{i_param};
    directionList = {'sag','front'};
    distList = [-256:64:256];
    saveOn = 1;     % Do not change, otherwise FullRun is useless
    IID_Model = 0;  % Set directionList to 'sag' only
    
    % Graph settings
    saveFigs = 1;
    
    % Movie settings
    framerate = 30;
    viewSet = [39.04,21.52]; %3D viewer
    allViewsOn = 1;

    % Saving
    i_param = i_param + 1;    
    save('FullResultRun.mat','modelName','paramName','directionList','distList',...
        'saveOn','saveFigs',...
        'framerate','viewSet','allViewsOn','IID_Model',...
        'i_param','modelNameList','paramNameList');
    
    %% Procedures
%     FD_TrialList;
    FD_Movie;
%     FD_initPlottingEffects;

    % Resuming
    clear all; close all;       
    load('FullResultRun');
end
delete('FullResultRun.mat')