% this script is called by nms_3Dmodel.mdl
warning('off','all') % Needed for speed (Simulink gives warnings)

%% Loading settings
IID_nms_MechInit;
IID_setInitPar;
IID_setCtrlPar;
IID_setDistPar
IID_setGroundPar;

%% Time
t_end = 25; %Also Adjust in OptFun_For/OptFun_forCPG
wCPG = 1 ;