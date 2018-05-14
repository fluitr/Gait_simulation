%% Librarys
addpath('param');
addpath('Library');

for i_trials = 1
    clc, close all
    
    %% Options
    %     LoadLocation = ['..\SimAnalysis\CMAESfiles\cmaes_var_',num2str(i_trials),'.mat'];
    LoadLocation = ['param/param_old_V5_wAnkle'];
    copyfile('DataSets/SimulinkFilesMean_Set4Combined','HumanData')
    SaveOpt = 0;
    SaveLocation = ['..\SimAnalysis\wAnkle'];
    
    if SaveOpt == 1 && exist(SaveLocation,'dir') == 0
        mkdir(SaveLocation);
    end
    
    %% Setting trail as best ever:
    load(LoadLocation);
        
    %     param = out.solutions.bestever.x;
    %     save('OptData/param_opt.mat','param');
    
    %% Start Simulation Once
    simOut = sim('nms_3Dmodel_inv_wAnkle',...
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
    
    %% Extracting parameters
    % Healthy torques
    Torque_mark = Torque_mat(2:end,:);
    Torque_std_mark = Torque_std_mat(2:end,:);
    
    %Phase
    Phase = Phase_mat(2,:);
    
    %% Analysis
    % Start at second step
    i_start = find(Phase == 1 & t>0.5,1);
    
    % Calculating diff
    % Absolute difference
    tor_diff = abs(Torque_mark(1:4,i_start:end)-Torque_nmc_opt(1:4,i_start:end));
    
    % Normalizing with STD
    norm_tor_diff = tor_diff./Torque_std_mark(1:4,i_start:end);
    
    % Mean Difference
    mdiff = mean(mean(norm_tor_diff));
    
    %% Muscle activation
    % Energy calculation
    energy = sum(sum(Muscle_act(1:end/2,:)));
    energy_t = energy/t(end);
    
    %% Cost function
    if mdiff > 2
        val = 1000 + mdiff;
    else
        val = (1E-3 * energy_t) + 5 * mdiff;
    end
    
    if SaveOpt == 1
        save([SaveLocation,'\energy.mat'],'energy_t')
    end
    
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
            ylimvalues = [-0.04 0.03];
        elseif joint == 2
            jointname = 'Hip Adduction';
            jointname2 = 'HipAdd';
            ylimvalues = [-0.037 0.01];
        elseif joint == 3;
            jointname = 'Knee Extension';
            jointname2 = 'Knee';
            ylimvalues = [-0.03 0.03];
        else
            jointname = 'Ankle Dorsiflexion';
            jointname2 = 'Ankle';
            ylimvalues = [-0.1 0.02];
        end
        
        figure
        subplot(1,3,1)
        plot(t(t>1.03 & t<2.07)-1.03,-Torque_nmc_old(joint,(t>1.03 & t<2.07))/mgl)
        hold on;  plot(t(t>1.03 & t<2.07)-1.03,-Torque_nmc_opt(joint,t>1.03 & t<2.07)/mgl,'Color',[0.9290 0.6940 0.1250])
        plot(t(t>1.03 & t<2.07)-1.03,-Torque_mark(joint,(t>1.03 & t<2.07))/mgl,'k');
        xlabel('t (s)');ylabel('Torque (Nm/mgl)')
        grid on; axis tight; ylim(ylimvalues)
        title('Unperturbed')
        
        jointname
        new = sqrt(mean((Torque_mark(joint,(t>1.03 & t<2.07)) - Torque_nmc_opt(joint,t>1.03 & t<2.07)).^2))
        old = sqrt(mean((Torque_mark(joint,(t>1.03 & t<2.07)) - Torque_nmc_old(joint,t>1.03 & t<2.07)).^2))
        [r,lags] = xcov(Torque_mark(joint,t>1.03 & t<2.07),Torque_nmc_opt(joint,t>1.03 & t<2.07), 'coeff');       
        new_xcov_val = r(lags==0)
        [r,lags] = xcov(Torque_mark(joint,t>1.03 & t<2.07),Torque_nmc_old(joint,t>1.03 & t<2.07), 'coeff');       
        old_xcov_val = r(lags==0)
        
        factor = old/new
        
        subplot(1,3,2)
        plot(t(t>2.07 & t<3.20)-2.07,-Torque_nmc_old(joint,(t>2.07 & t<3.20))/mgl);
        hold on;     plot(t(t>2.07 & t<3.20)-2.07,-Torque_nmc_opt(joint,(t>2.07 & t<3.20))/mgl,'Color',[0.9290 0.6940 0.1250]);
        plot(t(t>2.07 & t<3.20)-2.07,-Torque_mark(joint,(t>2.07 & t<3.20))/mgl,'k');
        xlabel('t (s)');
        grid on; axis tight;ylim(ylimvalues)
        title('Perturbed (backward)')
        
        jointname
        new = sqrt(mean((Torque_mark(joint,(t>2.07 & t<3.20)) - Torque_nmc_opt(joint,t>2.07 & t<3.20)).^2))
        old = sqrt(mean((Torque_mark(joint,(t>2.07 & t<3.20)) - Torque_nmc_old(joint,t>2.07 & t<3.20)).^2))
        [r,lags] = xcov(Torque_mark(joint,t>2.07 & t<3.20),Torque_nmc_opt(joint,t>2.07 & t<3.20), 'coeff');       
        new_xcov_val = r(lags==0)
        [r,lags] = xcov(Torque_mark(joint,t>2.07 & t<3.20),Torque_nmc_old(joint,t>2.07 & t<3.20), 'coeff');       
        old_xcov_val = r(lags==0)
        factor = old/new
        
        subplot(1,3,3)
        plot(t(t>4.210 & t<5.20)-4.210,-Torque_nmc_old(joint,(t>4.210 & t<5.20))/mgl);
        hold on;  plot(t(t>4.210 & t<5.20)-4.210,-Torque_nmc_opt(joint,(t>4.210 & t<5.20))/mgl,'Color',[0.9290 0.6940 0.1250])
        plot(t(t>4.210 & t<5.20)-4.210,-Torque_mark(joint,(t>4.210 & t<5.20))/mgl,'k');
        xlabel('t (s)');
        grid on; axis tight;ylim(ylimvalues)
        title('Perturbed (forward)')
        
        jointname
        new = sqrt(mean((Torque_mark(joint,(t>4.210 & t<5.20)) - Torque_nmc_opt(joint,t>4.210 & t<5.20)).^2))
        old = sqrt(mean((Torque_mark(joint,(t>4.210 & t<5.20)) - Torque_nmc_old(joint,t>4.210 & t<5.20)).^2))
        [r,lags] = xcov(Torque_mark(joint,t>4.210 & t<5.20),Torque_nmc_opt(joint,t>4.210 & t<5.20), 'coeff');       
        new_xcov_val = r(lags==0)
        [r,lags] = xcov(Torque_mark(joint,t>4.210 & t<5.20),Torque_nmc_old(joint,t>4.210 & t<5.20), 'coeff');       
        old_xcov_val = r(lags==0)
        
        factor = old/new
        
        if joint == 4
            legend('Opt. without M11','Opt. with M11','Human data','Location','SouthEast')
        end
        
        suptitle([jointname,' Torque (Left Leg)'])
%         saveas(gcf, ['../Opt_wAnkle/ID_Opt_wAnkle_',jointname2,'.eps'], 'epsc2')
%         saveas(gcf, ['../Opt_wAnkle/ID_Opt_wAnkle_',jointname2,'.fig'])
    end
end
