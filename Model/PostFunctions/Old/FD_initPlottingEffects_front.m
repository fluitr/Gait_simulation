close all
dist = -[75 50 25 0 -25 -50 -75];
direction = 'Frontal'; 

%% Loading
for i = 1:length(dist)
% push
load(['Simulations/Records_front_',num2str(-dist(i)),'/TargetAngle.mat'])
t = ans(1,:);
TA = ans(2:end,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/Disturbance.mat'])
Dist = ans(2:end,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/BodyInfo.mat'])
Angles = ans(2:17,:);
Pos = ans(18:50,:);
Loads = ans(51:52,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/L_Tor.mat'])
LTor = ans(2:end,:); 
load(['Simulations/Records_front_',num2str(-dist(i)),'/L_Tor_Passive.mat'])
LTor = -(LTor - ans(2:end,:));
LTor(2,:) = -LTor(2,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/R_Tor.mat'])
RTor = ans(2:end,:); 
load(['Simulations/Records_front_',num2str(-dist(i)),'/R_Tor_Passvie.mat'])
RTor = -(RTor - ans(2:end,:));
RTor(2,:) = -RTor(2,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/StanceSig.mat'])
Stance = ans(2:end,:);
Switch = [zeros(2,1) diff(Stance')'];
load(['Simulations/Records_front_',num2str(-dist(i)),'/rotTrunk.mat']);
rotTrunk = ans(2:end-1,:);
thetaTrunk = ans(end,:);
load(['Simulations/Records_front_',num2str(-dist(i)),'/COM.mat']);
xyzCOM = ans(2:4,:);
dxyzCOM = ans(end-2:end,:);

PlottingEffectsInterp_v3;
pause(0.01)
end
% figure(6)
% xlim([-0.4 0.4]);ylim([-0.4 0.4]);