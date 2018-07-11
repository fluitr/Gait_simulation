dir = 'C:\Users\FluitR\Documents\Postdoc\Gaitsimulation\Gait_sim\Model\OptData_old\REF - LGW - 1\';
file = 'cmaes_outxrecentbest.dat';
parfile = 'OptPar';
Optdata = importdata([dir file], ' ', 1); %read in data, space delimited and 1 line of header

[val idx] = min(Optdata.data(:,3)); %find minimum
param = Optdata.data(idx, 6:end)';
save([dir parfile], 'param')
