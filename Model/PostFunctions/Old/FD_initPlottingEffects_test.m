%% Loading
close all
dist = [0];
direction = 'Test'; 

for i = 1:length(dist)
% push (nog bezig met passive torques)
load(['Records/TargetAngle.mat'])
t = ans(1,:);
TA = ans(2:end,:);
load(['Records/Disturbance.mat'])
Dist = ans(2:end,:);
load(['Records/BodyInfo.mat'])
Angles = ans(2:17,:);
Pos = ans(18:50,:);
Loads = ans(51:52,:);
load(['Records/L_Tor.mat'])
LTor = ans(2:end,:); 
load(['Records/L_Tor_Passive.mat'])
LTor = -(LTor - ans(2:end,:));
LTor(2,:) = -LTor(2,:);
load(['Records/R_Tor.mat'])
RTor = ans(2:end,:); 
load(['Records/R_Tor_Passvie.mat'])
RTor = -(RTor - ans(2:end,:));
RTor(2,:) = -RTor(2,:);
load(['Records/StanceSig.mat'])
Stance = ans(2:end,:);
Switch = [zeros(2,1) diff(Stance')'];
load(['Records/rotTrunk.mat']);
rotTrunk = ans(2:end-1,:);
thetaTrunk = ans(end,:);
load(['Records/COMCOP.mat']);
xyzCOM = ans(2:4,:);
dxyzCOM = ans(5:7,:);
xyzCOP = ans(8:10,:);

PlottingEffectsInterp_v2;
pause(0.01)

%% More effects






end