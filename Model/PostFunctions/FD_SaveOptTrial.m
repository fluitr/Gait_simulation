clc; clear all; close all;

%% Settings
if exist('FullResultRun.mat','file')~=0
    load('FullResultRun');
else
    folderName = 'Rev132For';
    paramName = 'param_V132_for_wAnkleCPG';
    messageRev = 'Forward Opt, Standing still, spread, no hip adduction, no special result or succes';
end

%% Set map to global
map = cd;
if strcmp(map(end-12:end),'PostFunctions')
    cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% Checks
%Rev check
saveLocation = ['../OptRuns/',folderName];
if exist(saveLocation,'dir')~= 0
    error('Rev. already exists!')
end
%param Check
if exist(['param/',paramName],'file')~= 0
    error('Param already exists!')
end

%% Saving Simulations
copyfile('Simulations',saveLocation)

%% Saving Param
load('OptData/cmaes_var.mat')
param = out.solutions.bestever.x;
save(['param/',paramName],'param')

%% Updating OptRun.txt
fid = fopen('../OptRuns/OptRuns.txt', 'a');
fprintf(fid, ['\n',folderName,' - ',messageRev]);
fclose(fid);