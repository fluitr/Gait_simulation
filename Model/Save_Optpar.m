dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\PAM_LGW_1\';
dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1\';
 dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData\'
 savedir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\PAM_LGW_1_test\'
%  dir = savedir;
file = 'cmaes_outxrecentbest.dat';
parfile = 'Base_Par2';
Optdata = importdata([dir file], ' ', 1); %read in data, space delimited and 1 line of header

[val idx] = min(Optdata.data(:,3)); %find minimum
idx_opt = find(Optdata.data(:,3) < 45);
plot(Optdata.data(:,3))

sigma = std(Optdata.data(idx_opt, 6:end))';
param = Optdata.data(idx, 6:end)';
save([savedir parfile], 'param', 'sigma')

 load('param_NMS_IC_IMP.mat');
            AnkleIMP = param(end-2:end);
            load('C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF_LGW_1_test\Opt_par.mat')
            param = [param; AnkleIMP];