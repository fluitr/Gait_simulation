warning off; 

%% Settings
if exist('FullResultRun.mat','file')~=0
    load('FullResultRun');
else
    directionList = {'sag','front'};      %sag/front
    modelName = 'nms_3Dmodel_for_wAnkleCPG';   
    paramName = 'param_02cm';   % Loading params/1 = cur. param/2 = cur. bestever
    saveOn = 1;
    distList = [-100 0 100];
end

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% AddPaths
addpath('param');
addpath('Library');

%% Loading data and setting TrialRun settings
if sum(paramName == 1) ~= 0
    saveLocation = 'RecordsFolder/Current';
elseif sum(paramName == 2) ~= 0
    param = out.solutions.bestever.x;
    saveLocation = 'RecordsFolder/Current';
else
    load(paramName);
    saveLocation = ['RecordsFolder/',paramName];
end

%% Commenting in data logging
load_system(modelName)
set_param([modelName,'/Data Logging'],'commented','off')

for i_dir = 1:size(directionList,2)   
    %ParamToTest
    direction = directionList{i_dir};
    
    for i_dist = 1:length(distList)
        % Set Dist for this run
        DistRun = distList(i_dist);
        if strcmp(direction,'sag')
            opt_dist(1) = DistRun; opt_dist(2) = 0;
        elseif strcmp(direction,'front')
            opt_dist(1) = 0; opt_dist(2) = DistRun;
        else
            error('No correct direction for disturbance')
        end
        
        % Remove Previous results
        if saveOn == 1
        delete Records/*.mat
        end
        
        % Simulate 
        simOut = sim(modelName,...
            'SimulationMode', 'accelerator',...
            'SrcWorkspace','current',...
            'ExternalInput','param',...
            'ExternalInput','opt_dist',...
            'ExternalInput','direction',...
            'SaveOutput','on','OutputSaveName','yout',...
            'SaveFormat', 'Dataset');
        t = simOut.get('tout')';

        if saveOn == 1
            % Copy result
            copyfile('Records',[saveLocation,'/Records_',direction,'_',num2str(DistRun)])
        end
        
        %% Display information
        if t(end) == t_end
            disp(['At Dist = ',num2str(DistRun),'N (Direction = ',direction,...
                '), model could walk for ',num2str(t(end)),'/',num2str(t_end),' s. No Fall!'])
        else
            disp(['At Dist = ',num2str(DistRun),'N (Direction = ',direction,...
                '), model could walk for ',num2str(t(end)),'/',num2str(t_end),' s. FALL!'])
        end
    end
end

set_param([modelName,'/Data Logging'],'commented','on')