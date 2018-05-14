%   setDistPar.m
%   set disturbance parameters
%
%
%   set:
%       LM34_D
%       RM34_D
%       LM23_D
%       RM23_D
%       DistDT
%       DistDur
%
% by Tycho Brug
% May 2016

%% Disturbances
Dist_On = 1;
Dist_StartTime = 15;

%% Setting Dist
if exist('opt_dist','var')
    % In case opt_dist is set from optimization or TrialList
    Dist_xyzHAT_sag_PH = opt_dist(1);
    Dist_xyzHAT_front_PH = opt_dist(2);
else
    % In case of "free-run"
    Dist_xyzHAT_sag_PH = 0;
    Dist_xyzHAT_front_PH = 0;
    disp('No "opt_dist" param set, using standard settings')
end

Dist_xyzLAnkle_PH = 0;
Dist_xyzRAnkle_PH = 0;
Dist_LM34_PH = 0;     % Height left hip torque disturbance
Dist_RM34_PH = 0;     % Height right hip torque disturbance
Dist_LM23_PH = 0;     % Height left knee torque disturbance
Dist_RM23_PH = 0;     % Height right knee torque disturbance

%% Perturbation Length
Dist_PDur = 0.15;   % Duration of Disturbances (s)