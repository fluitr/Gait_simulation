%% Librarys
addpath('param');
addpath('Library');

for i_trials = 1
    clc
    
    %% Options
%     LoadLocation = ['..\SimAnalysis\CMAESfiles\cmaes_var_',num2str(i_trials),'.mat'];
    copyfile('DataSets/SFM_AS_Set24CombAll','HumanData')    
    LoadLocation = ['param_V26_inv_wAnkle'];
    SaveOpt = 0;
    SaveLocation = ['..\SimAnalysis\Set3Comb_V79nAnkle'];
    
    if SaveOpt == 1 && exist(SaveLocation,'dir') == 0
        mkdir(SaveLocation);
    end
    
    %% Setting trail as best ever:
    load(LoadLocation);
    
    %Sim 4 is the best
    %Sim 1 is overal nice
    %Sim 2 Hip ext best
    %Sim 3 Ankle + hip Abd good
       
    %% Start Simulation Once
    TrialRunON = 1; save('TrialRunON.mat','TrialRunON');
    simOut = sim('nms_3Dmodel_inv_wAnkle',...
        'SimulationMode', 'accelerator',...
        'SrcWorkspace','current',...
        'SaveOutput','on','OutputSaveName','yout',...
        'SaveFormat', 'Dataset');
    delete('TrialRunON.mat')
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
    
    %% Extracting parameters
    % Healthy torques
    Torque_mark = Torque_mat(2:end,:);
    Torque_std_mark = Torque_std_mat(2:end,:);
    
    %Phase
    Phase = Phase_mat(2,:);
    
    %% Analysis
    % Start at second step
    i_start = find(Phase == 1 & t>0.5,1);
    t = t(i_start:end);
    
    % Calculating diff
    % Absolute difference
    tor_diff = abs(Torque_mark(:,i_start:end)-Torque_nmc_opt(:,i_start:end));
    
    % Normalizing with STD
    norm_tor_diff = tor_diff./Torque_std_mark(:,i_start:end);
    
    % Mean Difference
    mdiff = mean(mean(norm_tor_diff));
    mean(mean(norm_tor_diff(4,:)))
    
    %% Muscle activation
    % Energy calculation
    Muscle_act_left = Muscle_act(1:end/2,i_start:end);
    energy = sum(trapz(t,Muscle_act_left,2));
    energy_t = energy/(t(end)-t(1)); 
    
    %% Cost function
    if mdiff > 2
        val = 1000 + mdiff;
    else
        val = (energy_t) + 5 * mdiff;
    end
    
    if SaveOpt == 1
        save([SaveLocation,'\energy.mat'],'energy_t')
    end
    
    %% Plotting
    figure;
    plot(t,Phase_mat(2,i_start:end))
    
    for i_fig = 1:4
        figure;
        subplot(1,2,1)
        plot(t,Torque_nmc_opt(i_fig,i_start:end))
        hold on; plot(t,Torque_nmc_old(i_fig,i_start:end))
        plot(t,Torque_mark(i_fig,i_start:end));
        plot(t,Torque_std_mark(i_fig,i_start:end))
        title('Left');xlabel('t (s)');ylabel('Torque (Nm)')
        grid on; axis tight;
        
        subplot(1,2,2)
        plot(t,Torque_nmc_opt(i_fig+4,i_start:end))
        hold on; plot(t,Torque_nmc_old(i_fig+4,i_start:end))
        plot(t,Torque_mark(i_fig+4,i_start:end));
        plot(t,Torque_std_mark(i_fig+4,i_start:end))
        title('Right');xlabel('t (s)');ylabel('Torque (Nm)')
        grid on; axis tight;

        legend('Optimized data','Old data','Human data','STD')
        
        switch i_fig
            case 1
                FigName = 'HipExtension';
            case 2
                FigName = 'HipAbduction';
            case 3
                FigName = 'KneeExtension';
            case 4
                FigName = 'AnkleDorsiFlex';
        end
        
        suptitle(FigName)
        
        if SaveOpt == 1
            saveas(gcf,[SaveLocation,'\',num2str(i_fig),'_',FigName,'.fig'])
        end
    end
    
    %% Filtered data
    fs = 1000;
    fc = 7;
    [b,a] = butter(1,fc/(fs/2));
    
    Torque_nmc_opt = filtfilt(b,a,Torque_nmc_opt')';
    Torque_nmc_old = filtfilt(b,a,Torque_nmc_old')';
    
    for i_fig = 1:4
        figure;
        subplot(1,2,1)
        plot(t,Torque_nmc_opt(i_fig,i_start:end)); hold on;
%         plot(t,Torque_nmc_old(i_fig,i_start:end))
        plot(t,Torque_mark(i_fig,i_start:end));
%         plot(t,Torque_std_mark(i_fig,i_start:end))
        xlabel('t (s)');ylabel('Torque (Nm)')
        grid on; axis tight;
        title('Left');
        
        subplot(1,2,2)
        plot(t,Torque_nmc_opt(i_fig+4,i_start:end)); hold on;
%         plot(t,Torque_nmc_old(i_fig+4,i_start:end))
        plot(t,Torque_mark(i_fig+4,i_start:end));
%         plot(t,Torque_std_mark(i_fig+4,i_start:end))
        title('Right');xlabel('t (s)');ylabel('Torque (Nm)')
        grid on; axis tight;

        legend('Optimized data','Old data','Human data','STD')
        
        switch i_fig
            case 1
                FigName = 'HipExtension';
            case 2
                FigName = 'HipAbduction';
            case 3
                FigName = 'KneeExtension';
            case 4
                FigName = 'AnkleDorsiFlex';
        end
        
        suptitle(FigName)
        
        if SaveOpt == 1
            saveas(gcf,[SaveLocation,'\',num2str(i_fig),'_',FigName,'_filt.fig'])
        end
        
    end
end