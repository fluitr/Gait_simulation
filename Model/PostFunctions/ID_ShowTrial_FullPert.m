clc, close all

%% Librarys
addpath('param');
addpath('Library');

%% Options
paramName = 'param_V84_hyb_wAnkleCPG';          % Loading params/1 = cur. param/2 = cur. bestever
modelName = 'nms_3Dmodel_inv_wAnkleCPG';        % Model name
dataLocation = 'SFM_AS_Set13CombAllnIns_hLoad';       % Data Set for param
saveFigs = 1;                                   % 0 = No figures saved, 1 = Figures are saved as fig, 2 = figs are saved as fig + eps

%% Set map to global
map = cd; 
if strcmp(map(end-12:end),'PostFunctions')
     cd .. % Go up to main folder
elseif ~strcmp(map(end-4:end),'Model')
    disp('Wrong main folder')
    return
end

%% Copying right files to HumanData (active) folder
copyfile(['DataSets/',dataLocation],'HumanData');    % Parameter set

%% Loading data and setting TrialRun settings
if sum(paramName == 1) ~= 0
    saveLocation = 'Figures\Current'; % Save location
elseif sum(paramName == 2) ~= 0
    param = out.solutions.bestever.x;
    saveLocation = 'Figures\Current'; % Save location
else
    load(paramName); 
    saveLocation = ['Figures\',paramName,'\inv']; % Save location
end

%% Making save folder if needed
if saveFigs > 0 && exist(saveLocation,'dir') == 0
    mkdir(saveLocation);
end

%% Start Simulation Once
simOut = sim(modelName,...
    'SimulationMode', 'accelerator',...
    'SrcWorkspace','current',...
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

load('HumanData/TorqueNoOpt.mat')
Torque_nmc_old = ans;
mgl = 80*9.71*1.8;

%% Getting pieces
if strcmp(dataLocation,'SFM_AS_Set24CombAll') || strcmp(dataLocation,'SFM_AS_Set24CombAllnIns')
    durations = [0.150 0.344 0.138 0.494 0.138]*1000;
elseif strcmp(dataLocation,'SFM_AS_Set13CombAllnIns') || strcmp(dataLocation,'SFM_AS_Set13CombAllnIns_hLoad')
    load('InterpDataSlow')
end

pieces = [1:sum(durations):length(Torque_nmc_opt) length(Torque_nmc_opt)+1];

%% Extracting parameters
% Healthy torques
Torque_mark = Torque_mat(2:end,:);
Torque_std_mark = Torque_std_mat(2:end,:);

%Phase
Phase = Phase_mat(2,:);

%% Filtered data
fs = 1000;
fc = 10;
[b,a] = butter(1,fc/(fs/2));

Torque_nmc_opt = filter(b,a,Torque_nmc_opt')';
Torque_nmc_old = filter(b,a,Torque_nmc_old')';

Torque_nmc_opt([3 7],:) = -Torque_nmc_opt([3 7],:);
Torque_nmc_old([3 7],:) = -Torque_nmc_old([3 7],:);
Torque_mark([3 7],:) = -Torque_mark([3 7],:);

for i_joint = 1:4
    joint = i_joint;
    
    if joint == 1
        jointname = 'Hip Flexion';
        jointname2 = 'HipFlx';
    elseif joint == 2
        jointname = 'Hip Adduction';
        jointname2 = 'HipAdd';
    elseif joint == 3
        jointname = 'Knee Extension';
        jointname2 = 'Knee';
    else
        jointname = 'Ankle Dorsiflexion';
        jointname2 = 'Ankle';
    end
    
    %% Full figure
    figure;
    plot(t,-Torque_nmc_opt(joint,:)/mgl); hold on;
    plot(t,-Torque_mark(joint,:)/mgl,'k');
    xlabel('t (s)');ylabel('Torque (Nm/mgl)')
    grid on; axis tight;
    title([jointname,' Torque (Left Leg)'])
    if saveFigs > 0
        saveas(gcf, [saveLocation,'/ID_Full_Torque_',jointname2,'.fig'])
    end
    if saveFigs > 1
        saveas(gcf,[saveLocation,'/ID_Full_Torque_',jointname2,'.eps'], 'epsc2')
    end
    
    %% Per Dist
    if strcmp(dataLocation,'SFM_AS_Set24CombAll')
        i_sag = [13:-1:10 2 15:18];
        i_front = [2 5:8];
    elseif strcmp(dataLocation,'SFM_AS_Set24CombAllnIns')
        i_sag = [11:-1:8 2 13:16];
        i_front = [2 3:6];
    elseif strcmp(dataLocation,'SFM_AS_Set13CombAllnIns') || strcmp(dataLocation,'SFM_AS_Set13CombAllnIns_hLoad')
        i_sag = [11:-1:8 2 13:16];
        i_front = [2 3:6];
    end
    
    for i_dir = 1:2
        %Setting parts for direction
        if i_dir == 1
            i_curdir = i_sag;
        elseif i_dir == 2
            i_curdir = i_front;
        end
        
        figure;
        for i_dist = 1:size(i_curdir,2)
            i_part = i_curdir(i_dist);
            
            %Getting a color code for the script
            if i_dir == 1
                CC = ((i_dist - 5)/4)*1;
            elseif i_dir == 2
                CC = ((i_dist - 1)/4)*1;
            end
            CCode = [(CC>0)*(1-abs(CC)),(CC==0),(CC<0)*(1-abs(CC))];
            
            % Plotting model outcome
            ax1 = subplot(1,2,1);
            plot(t(pieces(i_part):pieces(i_part+1)-1)-t(pieces(i_part)),-Torque_nmc_opt(joint,pieces(i_part):pieces(i_part+1)-1)/mgl,'Color',CCode); hold on
            xlabel('t (s)');ylabel('Torque (Nm/mgl)')
            grid on; axis tight;
            title('Model')
            
            % Plotting healthy human outcome
            ax2 = subplot(1,2,2);
            plot(t(pieces(i_part):pieces(i_part+1)-1)-t(pieces(i_part)),-Torque_mark(joint,pieces(i_part):pieces(i_part+1)-1)/mgl,'Color',CCode); hold on
            xlabel('t (s)');ylabel('Torque (Nm/mgl)')
            grid on; axis tight;
            title('Human')
        end
        linkaxes([ax1 ax2])
        subplot(ax2);DrawLines;subplot(ax1);DrawLines;
        
        if isunix ~= 1
        suptitle([jointname,' Torque (Left Leg)'])
        end
        
        % Saving
        if i_dir == 1
            if saveFigs > 0
                saveas(gcf, [saveLocation,'/ID_Sag_Torque_',jointname2,'.fig'])
            end
            if saveFigs > 1
                saveas(gcf,[saveLocation,'/ID_Sag_Torque_',jointname2,'.eps'], 'epsc2')
            end
        elseif i_dir == 2
            if saveFigs > 0
                saveas(gcf, [saveLocation,'/ID_Front_Torque_',jointname2,'.fig'])
            end
            if saveFigs > 1
                saveas(gcf,[saveLocation,'/ID_Front_Torque_',jointname2,'.eps'], 'epsc2')
            end
        end
    end
end