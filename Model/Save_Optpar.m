dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\PAM_LGW_1\';
dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1\';
%  dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData\'
 savedir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1\'
file = 'cmaes_outxrecentbest.dat';
parfile = 'Base_Par2';
Optdata = importdata([dir file], ' ', 1); %read in data, space delimited and 1 line of header

[val idx] = min(Optdata.data(:,3)); %find minimum
idx_opt = find(Optdata.data(:,3) < 2);
sigma = std(Optdata.data(idx_opt, 6:end))';
param = Optdata.data(idx, 6:end)';
save([savedir parfile], 'param', 'sigma')

