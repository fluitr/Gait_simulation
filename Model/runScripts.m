% this script is called by nms_3Dmodel.mdl
setenv('VSCMD_START_DIR','%CD%')
addpath('./param/')
<<<<<<< HEAD
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
=======

warning('off','all') % Needed for speed (Simulink gives warnings)

 load('paramIC_02cm');	% paramIC
%  load('param_02cm');	% param
 %load('param_V103_for_wAnkleCPG');	% param
 
if size(param,1) == 85
    param = [param(1:35);[10;0;0;0;-10;0;0;0];param(36:end)];
end
>>>>>>> Git init
% Ankle settings can be found at param(36:40)

%% Loading settings
nms_MechInit;
setInitPar;
setCtrlPar;
<<<<<<< HEAD
setDistPar;     % adding disturbance forces improves the stability of the solution when optimizing parameters
setCPGPar;      % not used
setGroundPar;   % ramp ascent/ descent, level ground, random heights
=======
setDistPar;
setCPGPar;
setGroundPar;
>>>>>>> Git init

%% Time & Other Settings
t_end = 15; %Also Adjust in OptFun_For/OptFun_forCPG
wCPG = 0;

Fs_prosthesis = 1000; %Hz
Buffer_size = 5; %samples
Knee_State = 0;

<<<<<<< HEAD
<<<<<<< HEAD
% knee controller
Control_type = 1; %1 = NMC, 2 = FSM

      
=======
% Ankle settings
K_ankle = 82*4;
D_ankle = 10;
Theta0_ankle = 0.00; %rad

% knee controller
Control_type = 2; %1 = NMC, 2 = FSM
>>>>>>> Git init
=======
% knee controller
Control_type = 1; %1 = NMC, 2 = FSM

% % Ankle settings
% K_ankle = 4;
% D_ankle = 1.5;
% Theta0_ankle = 0.05; %rad
>>>>>>> updated model for 1.3 m/s, optimized ankle impedance
