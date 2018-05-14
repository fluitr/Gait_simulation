% this script is called by nms_3Dmodel.mdl
setenv('VSCMD_START_DIR','%CD%')
addpath('./param/')

warning('off','all') % Needed for speed (Simulink gives warnings)

 load('paramIC_02cm');	% paramIC
 load('param_02cm');	% param
%  load('param_V103_for_wAnkleCPG');	% param
 
if size(param,1) == 82
    param = [param(1:35);[10;0;0;0;-10;0;0;0];param(36:end)];
end
% Ankle settings can be found at param(36:40)

%% Loading settings
nms_MechInit;
setInitPar;
setCtrlPar;
setDistPar;
setCPGPar;
setGroundPar;

%% Time & Other Settings
t_end = 15; %Also Adjust in OptFun_For/OptFun_forCPG
wCPG = 0;

Fs_prosthesis = 1000; %Hz
Buffer_size = 5; %samples
Knee_State = 0;

% Ankle settings
K_ankle = 82*4;
D_ankle = 10;
Theta0_ankle = 0.00; %rad

% knee controller
Control_type = 2; %1 = NMC, 2 = FSM