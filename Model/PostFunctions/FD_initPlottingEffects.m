clc; clear all; warning off; close all;

%% Plotting trialList results
%% Settings
if exist('FullResultRun.mat','file')~=0
    load('FullResultRun');
else
    distList = [-128:64:128];
    directionList = {'sag','front'};
    paramName = 'param_V84_hyb_wAnkleCPG';  % Name of param or 'Records' (in case of Records, make sure one direction and dist are used)
    saveFigs = 1;                % 0 = Figs are not saved, 1 = Figs are saved, 2 = Figs are saved as fig and eps
    IID_Model = 0; 
end

% Extra Settings
t_dist = 15; % Disturbance timing

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% Loading
for i_dir = 1:length(directionList)
    close all
    
    direction = directionList{i_dir};
    
    for i = 1:length(distList)
        %% Setting saveLocation and loadLocation
        if strcmp(paramName,'Records')
            if length(distList) > 1 || length(directionList)>1
                disp('Only select one disturbance and one direction for Records folder')
                return
            end
            loadLocation = 'Records';
            saveLocation = 'Figures/Current';
            disp('Loading from Records folder')      
        else
            saveLocation = ['Figures/',paramName,'/',direction];
            loadLocation = ['RecordsFolder/',paramName,'/Records_',direction,'_',num2str(distList(i))];
        end
        
        % Creating save folder
        if saveFigs > 0 && exist(saveLocation,'dir') == 0
            mkdir(saveLocation);
        end
        
        % Loading data
        load([loadLocation,'/Disturbance.mat'])
        t = ans(1,:);
        Dist = ans(2:end,:);
        
        % In case of 2D model, to Target Angle is available
        if IID_Model == 0
            load([loadLocation,'/TargetAngle.mat'])
            TA = ans(2:end,:);
        elseif IID_Model == 1
            TA = zeros(4,length(t));
        end
        
        load([loadLocation,'/BodyInfo.mat'])
        
        if size(ans,1) == 76
            Angles = ans(2:17,:);
            Pos = ans(18:74,:);
            Loads = ans(75:76,:);
        elseif size(ans,1) == 52
            Angles = ans(2:17,:);
            Pos = ans(18:50,:);
            Loads = ans(51:52,:);
            disp('Old File format (no foot coordinates included!)')
        end
        
        load([loadLocation,'/L_Tor.mat'])
        LTor = ans(2:end,:);
        load([loadLocation,'/L_Tor_Passive.mat'])
        LTor = -(LTor - ans(2:end,:));
        LTor(3,:) = -LTor(3,:);
        
        if distList(i) == 0
            LTor_zero = LTor;
        end
        
        load([loadLocation,'/R_Tor.mat'])
        RTor = ans(2:end,:);
        load([loadLocation,'/R_Tor_Passvie.mat'])
        RTor = -(RTor - ans(2:end,:));
        RTor(3,:) = -RTor(3,:);
        
        if distList(i) == 0
            RTor_zero = RTor;
        end
        
        load([loadLocation,'/StanceSig.mat'])
        Stance = ans(2:end,:);
        Switch = [zeros(2,1) diff(Stance')'];
        load([loadLocation,'/rotTrunk.mat']);
        rotTrunk = ans(2:end-1,:);
        thetaTrunk = ans(end,:);
        load([loadLocation,'/COM.mat']);
        xyzCOM = ans(2:4,:);
        dxyzCOM = ans(end-2:end,:);
        
        if strcmp(direction,'front')
            cur_dist = - distList(i);
        elseif strcmp(direction,'sag')
            cur_dist = distList(i);
        end
        
        %% Loading correct human data files
        pert_num = round(cur_dist/32);
        
        if pert_num > 0
            pert_num = pert_num + 4;
            if pert_num > 8
                pert_num = 8;
                disp('Showing biggest human disturbance (pos.), although model dist. is bigger')
            end
        elseif pert_num < 0
            pert_num = -pert_num;
            if pert_num > 4
                pert_num = 4;
                disp('Showing biggest human disturbance (neg.), although model dist. is bigger')
            end
        end
        
        load(['DataMark/',direction,'/P',num2str(pert_num),'Mark_rep.mat'])
        load(['DataMark/',direction,'/SL_Human.mat'])
        SL_human = SL(pert_num+1); SL_sub_human = SL_sub(pert_num+1);
        load(['DataMark/',direction,'/ST_Human.mat'])
        ST_human = ST_human(:,pert_num+1);
        
        if strcmp(direction,'front') && cur_dist < 0
            LTorI_mark = zeros(size(LTorI_mark));
            RTorI_mark = zeros(size(RTorI_mark));
        end
        
        FD_PlottingAll;
        pause(0.01)
    end
end
% figure(6)
% xlim([-0.8 0.8]);ylim([-0.8 0.8]);