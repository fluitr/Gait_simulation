%% All plotting general plotting xyzCOMmands are here
%% FigureCounter
i_F = 1;

%% ColorCode
ColorC = [0.9*(dist(i)>0),0,0.9*(dist(i)<0)];
window = [8.0533 9.3091];
mgl = 80*9.71*1.8;

%% Phase duration
HSL = t(Switch(1,:)==1);
HSR = t(Switch(2,:)==1);
TOL = t(Switch(1,:)==-1);
TOR = t(Switch(2,:)==-1);
SSPhase = HSL(7)- TOL(7);
DSPhase = TOR(8) - HSL(7);

%% Interpolating
t_mark = [0:249]/100;
events = [8.055 8.205 HSL(7) TOR(8) HSR(9) TOL(8)];
events_mark = [1 50 99 148 197 245];
durations = [150 344 138 494 138];

%Torques
LTorI = InterpToEvents(LTor,t,events,durations);
RTorI = InterpToEvents(RTor,t,events,durations);
RTorI2_mark = InterpToEventsNew(LTorI_mark',events_mark,durations);
LTorI2_mark = InterpToEventsNew(RTorI_mark',events_mark,durations);

%
dur_imp_l = [0 632 1126];
dur_imp_r = [0 632 1126];
for i_imp = 1:length(dur_imp_l)-1
left_imp(:,i_imp) = trapz(t(dur_imp_l(i_imp)+1:dur_imp_l(i_imp+1)),LTorI(:,dur_imp_l(i_imp)+1:dur_imp_l(i_imp+1))*mgl,2)
end


if i == 1
    LTorI_zero = LTorI;
    RTorI_zero = RTorI;
    RTorI2_mark_zero = RTorI2_mark;
    LTorI2_mark_zero = LTorI2_mark;
end

% Timestamp
t_old = t;
t = linspace(0,length(LTorI)/1000,length(LTorI));

%% Torques ankle
figure(i_F); i_F = i_F+1;

subplot(2,1,1)
plot(t,RTorI(end,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(end,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Ankle Torques DF. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
end

subplot(2,1,2)
plot(t,LTorI(end,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(end,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'0','0.15','0.49','0.63','1.13','1.26'})
    DrawLines
    xlim([0 t(end)])
    ylim([-0.1 0.05])
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_Ankle.eps', 'epsc2')
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_Ankle.fig')
end

%% Torques Knee
figure(i_F); i_F = i_F+1;

subplot(2,1,1)
plot(t,RTorI(3,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(3,:),'Color',ColorC)

if i == length(dist)   
    pause(0.1)
    title('Knee Torques Ext. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    ylim([-0.05 0.05])
end

subplot(2,1,2)
plot(t,LTorI(3,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(3,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'0','0.15','0.49','0.63','1.13','1.26'})
    DrawLines
    xlim([0 t(end)])
	ylim([-0.05 0.05])
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_Knee.eps', 'epsc2')
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_Knee.fig')
end

%% Torques Hip
% Abd/Add
figure(i_F); i_F = i_F+1;

subplot(2,1,1)
plot(t,RTorI(2,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(2,:),'Color',ColorC)

if i == length(dist)    
    pause(0.1)
    title('Hip Torques Add. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    ylim([-0.12 0.01])
end

subplot(2,1,2)
plot(t,LTorI(2,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(2,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'0','0.15','0.49','0.63','1.13','1.26'})
    DrawLines
    xlim([0 t(end)])
   ylim([-0.12 0.01])
%    saveas(gcf, '../Figures/nOpt/FD_nOpt_HipAdd.eps', 'epsc2')
%    saveas(gcf, '../Figures/nOpt/FD_nOpt_HipAdd.fig') 
end


%% Hip Torques
% Flx/Ext
figure(i_F); i_F = i_F+1;

subplot(2,1,1)
plot(t,RTorI(1,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(1,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Hip Torques Flx. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    ylim([-0.13 0.05])
end

subplot(2,1,2)
plot(t,LTorI(1,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(1,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',[0 0.15 0.494 0.632 1.126 1.264])
    set(gca,'XTickLabels',{'0','0.15','0.49','0.63','1.13','1.26'})
    DrawLines
    xlim([0 t(end)])
    ylim([-0.13 0.05])
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_HipFlx.eps', 'epsc2')
%     saveas(gcf, '../Figures/nOpt/FD_nOpt_HipFlx.fig')
    legend('NoPert (model)','NoPert (human)','Forward (model)','Forward (human)','Backward (model)','Backward (human)')
end



% if i > 1
%     %% DIFF
%     figure(i_F); i_F = i_F+1;
%     subplot(2,1,1)
%     plot(t,(RTorI(end,:)-RTorI_zero(end,:))/mgl,'--','Color',ColorC); hold on;grid on;
%     plot(t,RTorI2_mark(end,:)-RTorI2_mark_zero(end,:),'Color',ColorC)
%     
%     trapz(t(1:494),(RTorI(end,1:494)-RTorI_zero(end,1:494))/mgl)
%     trapz(t(1:494), RTorI2_mark(end,1:494)-RTorI2_mark_zero(end,1:494))
%        
%     
%     if i == length(dist)
%         pause(0.1)
%         title('Ankle Torques DF. (Left)')
%         xlabel('Time (s)');ylabel('(Nm/mgl)')
%         DrawLines
%         xlim([0 t(end)])
%     end
%     
%     subplot(2,1,2)
%     plot(t,(LTorI(end,:)-LTorI_zero(end,:))/mgl,'--','Color',ColorC); hold on;grid on;
%     plot(t,(LTorI2_mark(end,:)-LTorI2_mark_zero(end,:)),'Color',ColorC)
%     
%     if i == length(dist)
%         pause(0.1)
%         title('Ankle Torques DF. (Right)')
%         xlabel('Time (s)');ylabel('(Nm/mgl)')
%         legend('Forward (model)','Forward (human)','NoPert (model)','NoPert (human)','Backward (model)','Backward (human)')
%         DrawLines
%         xlim([0 t(end)])
%     end
% end
