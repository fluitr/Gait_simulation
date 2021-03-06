% this script is called by nms_3Dmodel.mdl
setenv('VSCMD_START_DIR','%CD%')
addpath('./param/')
warning('off','all') % Needed for speed (Simulink gives warnings)

% uncomment section when running optimizations!!

paramIC = param(91:101);
ankleIMP = param(102:104);
param = param(1:90);

% keyboard
% load('paramIC_02cm');	% paramIC
% load('param_02cm_ext');	% param
% param = param(1:90)
% % ankleIMP = param(91:93);
% load('param_ankleIMP'); % ankle IMP
% param = param(1:90);
% Ankle settings can be found at param(36:40)

%% Loading settings
nms_MechInit;
setInitPar;
setCtrlPar;
setDistPar;     % adding disturbance forces improves the stability of the solution when optimizing parameters
setCPGPar;      % not used
setGroundPar;   % ramp ascent/ descent, level ground, random heights

%% Time & Other Settings
t_end = 15; %Also Adjust in OptFun_For/OptFun_forCPG
wCPG = 0;

Fs_prosthesis = 1000; %Hz
Buffer_size = 5; %samples
Knee_State = 0;

% knee controller
Control_type = 1; %1 = NMC, 2 = FSM

      