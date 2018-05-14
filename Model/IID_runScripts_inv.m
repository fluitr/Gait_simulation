% this script is called by nms_3Dmodel.mdl
warning('off','all') % Needed for speed (Simulink gives warnings)

%% Loading settings
IID_nms_MechInit;
IID_setInitPar;
IID_setCtrlPar;

%% Time
wCPG = 1 ;

%% Loading settings
load('HumanData/Settings.mat')