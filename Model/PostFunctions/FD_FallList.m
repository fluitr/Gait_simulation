clear; close all

%% Options
directionList = {'sag','front'};      %sag/front
paramName = 'param_V84_hyb_wAnkleCPG';
distList = [-256:64:256];

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

for i_dir = 1:size(directionList,2)     
    %ParamToTest
    direction = directionList{i_dir};
    
    for counter1 = 1:length(distList)
        DistRun = distList(counter1);

        load(['RecordsFolder/',paramName,'/Records_',direction,'_',num2str(DistRun),'/Disturbance.mat'])
        Dist = ans; 
        FallList(counter1,i_dir) = Dist(1,end);
        dist_ind = find(diff(Dist(i_dir+1,:))~=0);
        
        if length(dist_ind)~=2 && DistRun ~= 0
            disp('error')
            counter1
            i_dir
        end
        
        if DistRun ~= 0
        StartList(counter1,i_dir) = Dist(1,dist_ind(1));
        StopList(counter1,i_dir) = Dist(1,dist_ind(2));
        end
    end
end

T2 = table(distList', [StartList(:,1),StopList(:,1)],[StartList(:,2),StopList(:,2)] );
T2.Properties.VariableNames = {'Dist' 'SagStartStop' 'FrontStartStop' }

T1 = table(distList', FallList(:,1),FallList(:,2));
T1.Properties.VariableNames = {'Dist' 'SagEndTime' 'FrontEndTime' }
