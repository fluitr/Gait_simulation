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

i_tol = find(TOL>20,1); i_hsl = find(HSL>TOL(i_tol),1);
i_tor = find(TOR>TOL(i_tol),1); i_hsr = find(HSR>TOL(i_tol),1);
events = [TOL(i_tol) TOL(i_tol)+0.151 HSL(i_hsl) TOR(i_tor) HSR(i_hsr) TOL(i_tol+1)];
SwDur = round((HSL(i_hsl-1) - TOL(i_tol-1))*1000);
DsDur = round((TOL(i_tol)-HSR(i_hsr-1))*1000);
durations = [150 (SwDur-150) DsDur SwDur DsDur];
cumsumDur = [0 cumsum(durations)]/1000;
cumsumDurNames = round(cumsumDur*100)/100;

SSPhase = HSL(i_hsl)- TOL(i_tol);
DSPhase = TOR(i_tor) - HSL(i_tol);

%% Interpolating
% t_mark = [0:249]/100;
% events = [8.055 8.205 HSL(7) TOR(8) HSR(9) TOL(8)];
events_mark = [1 50 99 148 197 245];
% durations = [150 344 138 494 138];

%Torques
LTorI = InterpToEvents(LTor,t,events,durations);
RTorI = InterpToEvents(RTor,t,events,durations);
RTorI2_mark = InterpToEventsNew(LTorI_mark',events_mark,durations);
LTorI2_mark = InterpToEventsNew(RTorI_mark',events_mark,durations);

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
    ylim([-0.12 0.05])
    DrawLines
    set(gca,'XTick',cumsumDur)
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
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    ylim([-0.12 0.05])
    DrawLines
    xlim([0 t(end)])
%         saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_Ankle.eps', 'epsc2')
%         saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_Ankle.fig')
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
    ylim([-0.1 0.05])
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    
end

subplot(2,1,2)
plot(t,LTorI(3,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(3,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    ylim([-0.1 0.05])
    DrawLines
    xlim([0 t(end)])
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_Knee.eps', 'epsc2')
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_Knee.fig')
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
    ylim([-0.15 0.03])
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    
end

subplot(2,1,2)
plot(t,LTorI(2,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(2,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    ylim([-0.15 0.03])
    DrawLines
    xlim([0 t(end)])
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_HipAdd.eps', 'epsc2')
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_HipAdd.fig')
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
    ylim([-0.13 0.05])
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    
end

subplot(2,1,2)
plot(t,LTorI(1,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(1,:),'Color',ColorC)

if i == length(dist)
    pause(0.1)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    ylim([-0.15 0.05])
    DrawLines
    xlim([0 t(end)])
    legend('NoPert (model)','NoPert (human)','Forward (model)','Forward (human)','Backward (model)','Backward (human)',...
        'Location','southeast')
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_HipFlx.eps', 'epsc2')
%     saveas(gcf, '../Figures/Opt_wAnkle/FD_Opt_wAnkle_HipFlx.fig')
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
%         legend('NoPert (model)','NoPert (human)','Forward (model)','Forward (human)','Backward (model)','Backward (human)')
%         DrawLines
%         xlim([0 t(end)])
%     end
% end
