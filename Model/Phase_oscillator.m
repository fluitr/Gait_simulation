%% load data
addpath('C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\NMC_3D_Tycho\Model\madgwick_algorithm_matlab\')
clear all; close all;
dir = 'Optparamdata\Ankle_impedance_opt1\record2\';
BodyInfo = load([dir 'BodyInfo.mat']);
Trunkrot = load([dir 'rotTrunk.mat']);
KneeInfo = load([dir 'Knee_controller_data.mat']);
t = KneeInfo.ans(1,:);
dt = (t(2:end)-t(1:end-1));


%% Plot data
% plot(t, (pi-BodyInfo.ans(2,:))*180/pi-Trunkrot.ans(11,:)*180/pi)


acc_shank = KneeInfo.ans(2:4,:)'; 
gyr_shank = KneeInfo.ans(5:7,:)';

acc_shank = KneeInfo.ans(25:27,:)'+repmat(t*50, 3, 1)'; %wgn(length(t),3, 10); 
gyr_shank = KneeInfo.ans(28:30,:)'+wgn(length(t),3, 5); 

plot(acc_shank)
% gyr_shank = gyrl_shank;
% pitch = atan2(acc_shank(1,:),(acc_shank(1,:).^2+acc_shank(3,:).^2));
% pitch = atan(accl_shank(1,:)./sqrt((accl_shank(2,:).^2+accl_shank(3,:).^2)));
% 
% gravity = [0 0 -9.81];
% pos(:,1) = zeros(1,3);
% vel(:,1) = zeros(1,3);
% for i = 1:length(acc_shank)-1
%     acc_shank_norm(i) = norm(acc_shank(:,i));
%     vel(:,i+1) = vel(:, i) + acc_shank(:,i)*dt(i);
%     pos(:,i+1) = pos(:, i) + vel(:,i)*dt(i);
% end
% 
% for i = 1:length(gyr_shank)-1
%     for j = 1:3
%         est_gyr(j, i) = sum(gyr_shank(j, 1:i).*dt(1:i));
%     end
% end
% 
% plot(est_gyr')

AHRS = MadgwickAHRS('SamplePeriod', 1/1000, 'Beta', 0.1);
for idx = 1:length(t)
    
    AHRS.UpdateIMU(gyr_shank(idx,:) * (pi/180), acc_shank(idx,:)); 
    quaternion_AG(idx, :) = AHRS.Quaternion;
end
euler_AG = quatern2euler(quaternConj(quaternion_AG)) * (180/pi);	% use conjugate for sensor frame relative to Earth and convert to degrees.


figure('Name', 'Euler Angles');
hold on;
plot(t, euler_AG(:,1), 'r');
plot(t, euler_AG(:,2), 'g');
plot(t, euler_AG(:,3), 'b');
% plot(time, euler_AGM(:,1), 'b');
% plot(time, euler_AGM(:,2), '.g');
% plot(time, euler_AGM(:,3), '.b');
title('Euler angles');
xlabel('Time (s)');
ylabel('Angle (deg)');
legend('\phi', '\theta', '\psi');
hold off;


