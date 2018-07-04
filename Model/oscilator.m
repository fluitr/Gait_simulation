dir = 'Optparamdata\Ankle_impedance_opt1\';
BodyInfo = load([dir 'BodyInfo.mat']);
Trunkrot = load([dir 'rotTrunk.mat']);

t = BodyInfo.ans(1,:);

for i = 2:length(BodyInfo.ans)
    clf
    plot(BodyInfo.ans(1,:), BodyInfo.ans(i,:))
    pause
end