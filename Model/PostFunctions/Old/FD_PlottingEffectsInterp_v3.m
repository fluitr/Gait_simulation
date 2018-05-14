%% All plotting general plotting xyzCOMmands are here
%% FigureCounter
i_F = 1;

%% ColorCode
ColorC = [-(0.008*dist(i)-1)*(dist(i)>0),(dist(i)==0),(0.008*dist(i)+1)*(dist(i)<0)];
window = [8.0533 9.3091];

%% W0
w0_XCOM = sqrt(9.71/1.09); 
mgl = 80*9.71*1.8;

%% Phase duration
HSL = t(Switch(1,:)==1);
HSR = t(Switch(2,:)==1);
TOL = t(Switch(1,:)==-1);
TOR = t(Switch(2,:)==-1);
SSPhase = HSL(7)- TOL(7);
DSPhase = TOR(8) - HSL(7);

%% Loading
xyzLAnkle = Pos(7:9,:);
xyzRAnkle = Pos(19:21,:);
xyzLHip = Pos(13:15,:);
xyzRHip = Pos(25:27,:);

%% Target position
xyzLTarget = zeros(3,length(TA));
xyzRTarget = zeros(3,length(TA));

xyzLTarget(1,:) = (xyzLHip(2,:)-xyzLAnkle(2,:))./tan(TA(1,:));
xyzLTarget(3,:) = -(xyzLHip(2,:)-xyzLAnkle(2,:))./tan(0.5*pi-TA(3,:));
xyzRTarget(1,:) = (xyzRHip(2,:)-xyzRAnkle(2,:))./tan(TA(2,:));
xyzRTarget(3,:) = (xyzRHip(2,:)-xyzRAnkle(2,:))./tan(0.5*pi-TA(4,:));

% Hip correction
dCOM2HipL = TransMat(rotTrunk,xyzCOM,xyzLHip,thetaTrunk);
dCOM2HipR = TransMat(rotTrunk,xyzCOM,xyzRHip,thetaTrunk);

xyzLTarget = xyzLTarget + dCOM2HipL;
xyzRTarget = xyzRTarget + dCOM2HipR;

%% Current Angle Hip
dHip2AnkleL = TransMat(rotTrunk,xyzLHip,xyzLAnkle,thetaTrunk);
dHip2AnkleR = TransMat(rotTrunk,xyzRHip,xyzRAnkle,thetaTrunk);

RA = [atan(-dHip2AnkleL(2,:)./dHip2AnkleL(1,:));atan(-dHip2AnkleR(2,:)./dHip2AnkleR(1,:));...
    0.5*pi - atan(-dHip2AnkleL(2,:)./-dHip2AnkleL(3,:));0.5*pi - atan(-dHip2AnkleR(2,:)./dHip2AnkleR(3,:))];

RA(1,RA(1,:) < 0) = RA(1,RA(1,:) < 0) + pi;
RA(2,RA(2,:) < 0) = RA(2,RA(2,:) < 0) + pi;
RA(3,RA(3,:) > 0.5*pi) = RA(3,RA(3,:) > 0.5*pi) - pi;
RA(4,RA(4,:) > 0.5*pi) = RA(4,RA(4,:) > 0.5*pi) - pi;

%% XCOM pos
xyzLXCOMTarget  = zeros(3,length(TA));
xyzRXCOMTarget  = zeros(3,length(TA));
xyzLXTarget  = zeros(3,length(TA));
xyzRXTarget  = zeros(3,length(TA));
TA_XCOM = zeros(4,length(TA));

% Target location (COP)
dLocCOM = TransMat(rotTrunk,zeros(3,length(TA)),dxyzCOM,thetaTrunk);
xyzLXCOMTarget(1,:) =  dLocCOM(1,:)/w0_XCOM + 0.06;
xyzRXCOMTarget(1,:) =  dLocCOM(1,:)/w0_XCOM + 0.06;
xyzLXCOMTarget(3,:) =  dLocCOM(3,:)/w0_XCOM - 0.105;
xyzRXCOMTarget(3,:) =  dLocCOM(3,:)/w0_XCOM + 0.105;

% Target angle
% Hip correction
xyzLXCOMTarget = xyzLXCOMTarget - dCOM2HipL;
xyzRXCOMTarget = xyzRXCOMTarget - dCOM2HipR;

% Angle Calculation
TA_XCOM(1,:) = atan((xyzLHip(2,:))./xyzLXCOMTarget(1,:));
TA_XCOM(2,:) = atan((xyzRHip(2,:))./xyzRXCOMTarget(1,:));
TA_XCOM(3,:) = 0.5*pi - atan(-(xyzLHip(2,:))./xyzLXCOMTarget(3,:));
TA_XCOM(4,:) = 0.5*pi - atan((xyzLHip(2,:))./xyzLXCOMTarget(3,:));
TA_XCOM(3,TA_XCOM(3,:) > 0.5*pi) = TA_XCOM(3,TA_XCOM(3,:) > 0.5*pi) - pi;
TA_XCOM(4,TA_XCOM(4,:) > 0.5*pi) = TA_XCOM(4,TA_XCOM(4,:) > 0.5*pi) - pi;

% Target Location (ANKLE)
xyzLXTarget(1,:) = (xyzLHip(2,:)-xyzLAnkle(2,:))./tan(TA_XCOM(1,:));
xyzLXTarget(3,:) = -(xyzLHip(2,:)-xyzLAnkle(2,:))./tan(0.5*pi-TA_XCOM(3,:));
xyzRXTarget(1,:) = (xyzRHip(2,:)-xyzRAnkle(2,:))./tan(TA_XCOM(2,:));
xyzRXTarget(3,:) = (xyzRHip(2,:)-xyzRAnkle(2,:))./tan(0.5*pi-TA_XCOM(4,:));

%% Interpolating
events = [8.055 8.205 HSL(7) TOR(8) HSR(9) TOL(8)];
durations = [150 344 138 494 138];

%Angle of attack
TAI = InterpToEvents(TA,t,events,durations);
RAI = InterpToEvents(RA,t,events,durations);

%TargetLocation
xyzLTargetI = InterpToEvents(xyzLTarget,t,events,durations);
xyzRTargetI = InterpToEvents(xyzRTarget,t,events,durations);

%Torques
LTorI = InterpToEvents(LTor,t,events,durations);
RTorI = InterpToEvents(RTor,t,events,durations);

%TargetLocation XCOM
TA_XCOMI = InterpToEvents(TA_XCOM,t,events,durations);

% Timestamp
t_old = t;
t = linspace(0,length(TAI)/1000,length(TAI));

%% Angle of Attack
% Angle of attack (MODEL)
figure(i_F); i_F = i_F+1;

subplot(2,2,1)
plot(t,TAI(1,:),'Color',ColorC);
hold on; grid on;

if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Left)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,2)
plot(t,TAI(3,:),'Color',ColorC); hold on; grid on;

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (Frontal Left)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,3)
plot(t,TAI(2,:),'Color',ColorC);
hold on; grid on;


if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Right)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,4)
plot(t,TAI(4,:),'Color',ColorC); hold on; grid on;

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (frontal Right)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/1a - Angle of Attack'])
end

% Target Position ankle
figure(i_F); i_F = i_F+1;

subplot(2,2,1)
plot(t,xyzLTargetI(1,:),'Color',ColorC);
hold on; grid on;

if i == length(dist)
    pause(0.1)
    title('Target location (x Left)')
    xlabel('Time (s)'),ylabel('x (m)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,2)
plot(t,xyzLTargetI(3,:),'Color',ColorC); hold on; grid on;

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('y (m)')
    title('Target location (y Left)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,3)
plot(t,xyzRTargetI(1,:),'Color',ColorC);
hold on; grid on;

if i == length(dist)
    pause(0.1)
    title('Target location (x Right)')
    xlabel('Time (s)'),ylabel('x (m)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,4)
plot(t,xyzRTargetI(3,:),'Color',ColorC); hold on; grid on;

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('y (m)')
    title('Target location (y Right)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/1b - Pos of Attack'])
end

% Real angle of attack and TA
figure(i_F); i_F = i_F+1;

subplot(2,2,1)
plot(t,TAI(1,:),'Color',ColorC); hold on; grid on
plot(t,RAI(1,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Left)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,2)
plot(t,TAI(3,:),'Color',ColorC); hold on; grid on;
plot(t,RAI(3,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (Frontal Left)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,3)
plot(t,TAI(2,:),'Color',ColorC); hold on; grid on;
plot(t,RAI(2,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Right)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,4)
plot(t,TAI(4,:),'Color',ColorC); hold on; grid on;
plot(t,RAI(4,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    legend('Target angle','Real angle')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (frontal Right)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/1c - TA and RA'])
end

% TA and XCOM target
figure(i_F); i_F = i_F+1;

subplot(2,2,1)
plot(t,TAI(1,:),'Color',ColorC); hold on; grid on
plot(t,TA_XCOMI(1,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Left)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,2)
plot(t,TAI(3,:),'Color',ColorC); hold on; grid on;
plot(t,TA_XCOMI(3,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (Frontal Left)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,3)
plot(t,TAI(2,:),'Color',ColorC); hold on; grid on;
plot(t,TA_XCOMI(2,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    title('Angle of Attack (Sagittal Right)')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,2,4)
plot(t,TAI(4,:),'Color',ColorC); hold on; grid on;
plot(t,TA_XCOMI(4,:),'--','Color',ColorC);

if i == length(dist)
    pause(0.1)
    legend('Target angle','XCOM angle')
    xlabel('Time (s)'),ylabel('AoA (rad)')
    title('Angle of Attack (frontal Right)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/1d - TA and XCOMA'])
end

%% Torques ankle
figure(i_F); i_F = i_F+1;
subplot(2,1,1)
plot(t,RTorI(end,:)/mgl,'Color',ColorC); hold on;grid on;

if i == length(dist)
    pause(0.1)
    title('Ankle Torques DF. (Right)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,1,2)
plot(t,LTorI(end,:)/mgl,'Color',ColorC); hold on;grid on;

if i == length(dist)
    pause(0.1)
    title('Ankle Torques DF. (Left)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/2 - Ankle Torques'])
end

%% Torques knee
figure(i_F); i_F = i_F+1;
subplot(2,1,1)
plot(t,RTorI(3,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Knee Torques Flx. (Right)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,1,2)
plot(t,LTorI(3,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Knee Torques Flx. (Left)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/3 - Knee Torques'])
end

%% Torques hip
% Flex/Extension
figure(i_F); i_F = i_F+1;
subplot(2,1,1)
plot(t,RTorI(1,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Hip Torques Flx. (Right)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,1,2)
plot(t,LTorI(1,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Hip Torques Flx. (Left)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/4a - Hip Torques (Flx)'])
end

% Abd/Adduction
figure(i_F); i_F = i_F+1;

subplot(2,1,1)
plot(t,-RTorI(2,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Hip Torques Add. (Right)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
end

subplot(2,1,2)
plot(t,-LTorI(2,:)/mgl,'Color',ColorC); hold on;grid on;
if i == length(dist)
    pause(0.1)
    title('Hip Torques Add. (Left)')
    xlabel('Time (s)');ylabel('(Nm/mgl)')
    DrawLines
    xlim([0 t(end)])
    savefig(['Figures/',direction,'/4b - Hip Torques (Add)'])
end

%% Foot placement
dCOM2AnkleL = TransMat(rotTrunk,xyzCOM,xyzLAnkle,thetaTrunk);
dCOM2AnkleR = TransMat(rotTrunk,xyzCOM,xyzRAnkle,thetaTrunk);

figure(i_F); i_F = i_F+1;
hold on; grid on
plot(-dCOM2AnkleL(3,t_old == HSL(7)),dCOM2AnkleL(1,t_old == HSL(7)),'*','Color',ColorC);
plot(-xyzLTarget(3,t_old == HSL(7)),xyzLTarget(1,t_old == HSL(7)),'o','Color',ColorC);
plot(-xyzLXTarget(3,t_old == HSL(7)),xyzLXTarget(1,t_old == HSL(7)),'x','Color',ColorC);
plot(-dCOM2AnkleR(3,t_old == HSL(7)),dCOM2AnkleR(1,t_old == HSL(7)),'+','Color',ColorC);
plot(0,0,'k*')
axis equal

if i == length(dist)
    pause(0.1)
    xlabel('z (m)');ylabel('x (m)')
    title('Ankle position on HSL'); legend('Real Pos','Target Pos','XCOM','Trailing foot')
    savefig(['Figures/',direction,'/5a - Foot Placement (1st HS)'])
end

figure(i_F); i_F = i_F+1;
hold on; grid on
plot(-dCOM2AnkleR(3,t_old == HSR(9)),dCOM2AnkleR(1,t_old == HSR(9)),'*','Color',ColorC);
plot(-xyzRTarget(3,t_old == HSR(9)),xyzRTarget(1,t_old == HSR(9)),'o','Color',ColorC);
plot(-xyzRXTarget(3,t_old == HSR(9)),xyzRXTarget(1,t_old == HSR(9)),'x','Color',ColorC);
plot(-dCOM2AnkleL(3,t_old == HSR(9)),dCOM2AnkleL(1,t_old == HSR(9)),'+','Color',ColorC);
plot(0,0,'k*')
axis equal

if i == length(dist)
    pause(0.1)
    xlabel('z (m)');ylabel('x (m)')
    title('Ankle position on HSR'); legend('Real Pos','Target Pos','XCOM','Trailing foot')
    savefig(['Figures/',direction,'/5b - Foot Placement (2nd HS)'])
end

%% Foot placement (angles)
figure(i_F); i_F = i_F+1;

hold on; grid on
plot(RA(3,t_old == HSL(7)),RA(1,t_old == HSL(7)),'*','Color',ColorC);
%plot(0,0,'k*')
plot(TA(3,t_old == HSL(7)),TA(1,t_old == HSL(7)),'o','Color',ColorC);

if i == length(dist)
    pause(0.1)
	xlabel('frontal (rad)');ylabel('sagittal (Rad)')
    title('Angles on HSL'); legend('Real angle','Target angle')
    savefig(['Figures/',direction,'/5c - Foot Placement angles'])
end

%% Plotting duration
figure(i_F); i_F = i_F+1;
plot(dist(i)/mgl,SSPhase,'*','Color',ColorC); hold on
plot(dist(i)/mgl,DSPhase,'o','Color',ColorC); 

if i == length(dist)
    pause(0.1)
    ylim([0.1 0.6])
    grid on; title('Single Support Phase duration')
    ylabel('Duration (s)');xlabel('Disturbance force (N)')
    savefig(['Figures/',direction,'/6 - Phase Duration'])
end