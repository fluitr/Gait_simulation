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
    if opt_dist(2) ~= 0
        disp('Frontal Disturbances not possible in 2D'); return;
    end   
else
    % In case of "free-run"
    Dist_xyzHAT_sag_PH = 0;
    disp('No "opt_dist" param set, using standard settings')
end

%% Settings
Dist_PDur = 0.15;   % Duration of Disturbances (s)