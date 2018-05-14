%% All plotting general plotting xyzCOMmands are here
%% FigureCounter
i_F = 1;

%% ColorCode
ColorC = [0.8*(cur_dist>0),0,0.8*(cur_dist<0)];

%% MGL
mgl = 80*9.71*1.8;
mg = 80*9.71;

%% Phase duration
HSL = t(Switch(1,:)==1);
HSR = t(Switch(2,:)==1);
TOL = t(Switch(1,:)==-1);
TOR = t(Switch(2,:)==-1);

i_tol = find(TOL>t_dist,1); i_hsl = find(HSL>TOL(i_tol),1);
i_tor = find(TOR>TOL(i_tol),1); i_hsr = find(HSR>TOL(i_tol),1);
events = [TOL(i_tol) TOL(i_tol)+0.151 HSL(i_hsl) TOR(i_tor) HSR(i_hsr) TOL(i_tol+1)];
SwDur = round((HSL(i_hsl-1) - TOL(i_tol-1))*1000);
DsDur = round((TOL(i_tol)-HSR(i_hsr-1))*1000);
durations = [150 (SwDur-150) DsDur SwDur DsDur];
cumsumDur = [0 cumsum(durations)]/1000;
cumsumDurNames = round(cumsumDur*100)/100;

SSPhase = HSL(i_hsl)- TOL(i_tol);
DSPhase = TOR(i_tor) - HSL(i_tol);

%% Loading
xyzLAnkle = Pos(7:9,:);
xyzRAnkle = Pos(19:21,:);
xyzLHip = Pos(13:15,:);
xyzRHip = Pos(25:27,:);

%% Current Angle Hip
dHip2AnkleL = TransMat(rotTrunk,xyzLHip,xyzLAnkle,thetaTrunk);
dHip2AnkleR = TransMat(rotTrunk,xyzRHip,xyzRAnkle,thetaTrunk);

RA = [atan(-dHip2AnkleL(2,:)./dHip2AnkleL(1,:));atan(-dHip2AnkleR(2,:)./dHip2AnkleR(1,:));...
    0.5*pi - atan(-dHip2AnkleL(2,:)./-dHip2AnkleL(3,:));0.5*pi - atan(-dHip2AnkleR(2,:)./dHip2AnkleR(3,:))];

RA(1,RA(1,:) < 0) = RA(1,RA(1,:) < 0) + pi;
RA(2,RA(2,:) < 0) = RA(2,RA(2,:) < 0) + pi;
RA(3,RA(3,:) > 0.5*pi) = RA(3,RA(3,:) > 0.5*pi) - pi;
RA(4,RA(4,:) > 0.5*pi) = RA(4,RA(4,:) > 0.5*pi) - pi;

%% Interpolating
% %Angle of attack
TAI = InterpToEvents(TA,t,events,durations);
RAI = InterpToEvents(RA,t,events,durations);

%Torques
LTorI = InterpToEvents(LTor,t,events,durations);
RTorI = InterpToEvents(RTor,t,events,durations);

%Torques mark
events_mark = [1 50 99 148 197 245];
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
t = linspace(0,length(RAI)/1000,length(RAI));

%% Foot placement
dCOM2AnkleL = TransMat(rotTrunk,xyzCOM,xyzLAnkle,thetaTrunk);
dCOM2AnkleR = TransMat(rotTrunk,xyzCOM,xyzRAnkle,thetaTrunk);

figure(i_F); i_F = i_F+1;
hold on; grid on
plot(-dCOM2AnkleL(3,t_old == HSL(i_hsl)),dCOM2AnkleL(1,t_old == HSL(i_hsl)),'*','Color',ColorC);
% plot(-xyzLTarget(3,t_old == HSL(7)),xyzLTarget(1,t_old == HSL(7)),'o','Color',ColorC);
% plot(-xyzLXTarget(3,t_old == HSL(7)),xyzLXTarget(1,t_old == HSL(7)),'x','Color',ColorC);
plot(-dCOM2AnkleR(3,t_old == HSL(i_hsl)),dCOM2AnkleR(1,t_old == HSL(i_hsl)),'+','Color',ColorC);
plot(0,0,'ko')
axis equal

if i == length(distList)
    pause(0.1)
    xlabel('z (m)');ylabel('x (m)')
    title('Ankle position on HSL'); legend('Real Pos','Trailing foot','XCOM')
    if saveFigs > 0
        savefig([saveLocation,'/1a - Foot Placement (1st HS)'])
    end
end

figure(i_F); i_F = i_F+1;
hold on; grid on
plot(-dCOM2AnkleR(3,t_old == HSR(i_hsr)),dCOM2AnkleR(1,t_old == HSR(i_hsr)),'*','Color',ColorC);
% plot(-xyzRTarget(3,t_old == HSR(9)),xyzRTarget(1,t_old == HSR(9)),'o','Color',ColorC);
% plot(-xyzRXTarget(3,t_old == HSR(9)),xyzRXTarget(1,t_old == HSR(9)),'x','Color',ColorC);
plot(-dCOM2AnkleL(3,t_old == HSR(i_hsr)),dCOM2AnkleL(1,t_old == HSR(i_hsr)),'+','Color',ColorC);
plot(0,0,'ko')
axis equal

if i == length(distList)
    pause(0.1)
    xlabel('z (m)');ylabel('x (m)')
    title('Ankle position on HSR'); legend('Real Pos','Trailing foot','XCOM')
    if saveFigs > 0
        savefig([saveLocation,'/1b - Foot Placement (2nd HS)'])
    end
end

%% Foot placement (angles)
figure(i_F); i_F = i_F+1;

hold on; grid on
plot(RA(3,t_old == HSL(i_hsl)),RA(1,t_old == HSL(i_hsl)),'*','Color',ColorC);
%plot(0,0,'k*')
plot(TA(3,t_old == HSL(i_hsl)),TA(1,t_old == HSL(i_hsl)),'o','Color',ColorC);

if i == length(distList)
    pause(0.1)
    xlabel('frontal (rad)');ylabel('sagittal (Rad)')
    title('Angles on HSL'); legend('Real angle','Target angle')
    if saveFigs > 0
        savefig([saveLocation,'/1c - Foot Placement angles'])
    end
end

%% Plotting StepLength
figure(i_F); i_F = i_F+1;

%% If foot coordinates are available
if size(Pos,1) == 57
    xyzRFoot = (Pos([34:36]+12,:) + Pos([34:36]+15,:))./2;
    xyzLFoot = (Pos([34:36],:) + Pos([34:36]+3,:))./2;
elseif size(Pos,1) == 33
    xyzRFoot = Pos(19:21,:);
    xyzLFoot = Pos(7:9,:);
end
    
subplot(1,2,1)
SL(i) = pdist([xyzLFoot([1 3],t_old == HSL(i_hsl))'; xyzRFoot([1 3],t_old ==HSL(i_hsl))'],'euclidean');
plot(cur_dist/mg,SL(i),'*','Color',ColorC);hold on; grid on; 
plot(cur_dist/mg,SL_human,'.','Color',ColorC,'MarkerSize',20);hold on; grid on; 

subplot(1,2,2)
SL_sub(i) = pdist([xyzLFoot([1 3],t_old == HSR(i_hsr))'; xyzRFoot([1 3],t_old ==HSR(i_hsr))'],'euclidean');
plot(cur_dist/mg,SL_sub(i),'*','Color',ColorC);hold on; grid on; 
plot(cur_dist/mg,SL_sub_human,'.','Color',ColorC,'MarkerSize',20);hold on; grid on; 

if i == length(distList)
    drawnow
    subplot(1,2,1)
    xlabel('Disturbance force (N/mg)');ylabel('x (m)')
    title('StepLength Initial Step');
     
    subplot(1,2,2)
    xlabel('Disturbance force (N/mg)');
    title('StepLength Subsequent Step');
           
    legend('Model',...
        'Human');
    
    if saveFigs > 0
        savefig([saveLocation,'/1d - StepLength'])
    end
end

%% Plotting duration
figure(i_F); i_F = i_F+1;
plot(cur_dist/mg,SSPhase,'*','Color',ColorC); hold on
plot(cur_dist/mg,DSPhase,'o','Color',ColorC);

plot(cur_dist/mg,ST_human(1),'.','Color',ColorC,'MarkerSize',20); hold on
plot(cur_dist/mg,ST_human(2),'x','Color',ColorC);

if i == length(distList)
    pause(0.1)
    grid on; title('Phase durations')
    ylabel('Duration (s)');xlabel('Disturbance force (N/mg)'); 
    legend('Single Stance (model)','Double Stance (model)',...
        'Single Stance (human)','Double Stance (human)');
    if saveFigs > 0
        savefig([saveLocation,'/2 - Phase Duration'])
    end
end

%% Torques ankle
figure(i_F); i_F = i_F+1;

ax1 = subplot(2,1,1);
plot(t,RTorI(end,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(end,:),'Color',ColorC)

ax2 = subplot(2,1,2); linkaxes([ax1 ax2])
plot(t,LTorI(end,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(end,:),'Color',ColorC)

if i == length(distList)
    pause(0.1)
    subplot(ax1)
    title('Ankle Torques DF. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines; 
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)]) 
    
    subplot(ax2)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    DrawLines
    xlim([0 t(end)])
    
    if saveFigs > 0
        saveas(gcf, [saveLocation,'/3a - Torques - Ankle.fig'])
        if saveFigs > 1
            saveas(gcf, [saveLocation,'/3a - Torques - Ankle.eps'], 'epsc2')
        end
    end
end

%% Torques Knee
figure(i_F); i_F = i_F+1;
% Plotting Left
ax1 = subplot(2,1,1);
plot(t,RTorI(3,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(3,:),'Color',ColorC);

% Plotting Right
ax2 = subplot(2,1,2); linkaxes([ax1 ax2])
plot(t,LTorI(3,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(3,:),'Color',ColorC);

if i == length(distList)
    pause(0.1)
    subplot(ax1)
    title('Knee Torques Ext. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])  
    
    subplot(ax2)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    DrawLines
    xlim([0 t(end)])
    if saveFigs > 0
        saveas(gcf, [saveLocation,'/3b - Torques - Knee.fig'])
        if saveFigs > 1
            saveas(gcf, [saveLocation,'/3b - Torques - Knee.eps'], 'epsc2')
        end
    end
end

%% Torques Hip
% Abd/Add
figure(i_F); i_F = i_F+1;

ax1 = subplot(2,1,1);
plot(t,RTorI(2,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(2,:),'Color',ColorC)

ax2 = subplot(2,1,2); linkaxes([ax1 ax2])
plot(t,LTorI(2,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(2,:),'Color',ColorC)

if i == length(distList)
    pause(0.1)
    subplot(ax1)
    title('Hip Torques Add. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    
    subplot(ax2)
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    DrawLines
    xlim([0 t(end)])
    if saveFigs > 0
        saveas(gcf, [saveLocation,'/3c - Torques - HipAdd.fig'])
        if saveFigs > 1
            saveas(gcf, [saveLocation,'/3c - Torques - HipAdd.eps'], 'epsc2')
        end
    end
end

%% Hip Torques
% Flx/Ext
figure(i_F); i_F = i_F+1;

ax1 = subplot(2,1,1);
plot(t,RTorI(1,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,RTorI2_mark(1,:),'Color',ColorC)

ax2 = subplot(2,1,2); linkaxes([ax1 ax2]);
plot(t,LTorI(1,:)/mgl,'--','Color',ColorC); hold on;grid on;
plot(t,LTorI2_mark(1,:),'Color',ColorC)

if i == length(distList)
    pause(0.1)
    subplot(ax1);
    title('Hip Torques Flx. - Left Leg')
    ylabel('Torque (Nm/mgl)')
    DrawLines
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{'TOR-P_s','P_e','HSR','TOL','HSL','TOR'})
    xlim([0 t(end)])
    
    subplot(ax2);
    title('Right Leg')
    xlabel('Time (s)');
    ylabel('Torque (Nm/mgl)')
    set(gca,'XTick',cumsumDur)
    set(gca,'XTickLabels',{num2str(cumsumDurNames(1)),num2str(cumsumDurNames(2)),...
        num2str(cumsumDurNames(3)),num2str(cumsumDurNames(4)),num2str(cumsumDurNames(5)),num2str(cumsumDurNames(6))})
    DrawLines
    xlim([0 t(end)])
    legend('NoPert (model)','NoPert (human)','Forward (model)','Forward (human)','Backward (model)','Backward (human)',...
        'Location','southeast')
    if saveFigs > 0
        saveas(gcf, [saveLocation,'/3d - Torques - HipFlx.fig'])
        if saveFigs > 1
            saveas(gcf, [saveLocation,'/3d - Torques - HipFlx.eps', 'epsc2'])
        end
    end
end