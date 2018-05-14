%% Opt Script
addpath('param');
addpath('Library');
addpath('HumanData');

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% This script gets all NoOpt files for the DataSets
listing = dir('DataSets');

for i = 3:length(listing)
    curDir = listing(i).name;
    
    if ~exist(['DataSets/',curDir,'/TorqueNoOpt.mat'],'file')
    
    copyfile(['DataSets/',curDir],'HumanData');
    
    load('param/param_02cm.mat');
    
    simOut = sim('nms_3Dmodel_inv_wAnkle',...
        'SimulationMode', 'accelerator',...
        'SrcWorkspace','current',...
        'SaveOutput','on','OutputSaveName','yout',...
        'SaveFormat', 'Dataset');
    outputs = simOut.get('yout');
    t = simOut.get('tout')';
    Torque_nmc_opt = outputs.get('data').Values.torques.Data';
    Muscle_act = outputs.get('data').Values.muscle_act.Data';
    
    ans = Torque_nmc_opt;
    save('HumanData/TorqueNoOpt.mat','ans')
    copyfile('HumanData',['DataSets/',curDir]);  
    end
end
