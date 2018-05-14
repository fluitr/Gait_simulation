% this script is called by nms_3Dmodel.mdl
warning('off','all') % Needed for speed (Simulink gives warnings)
load('paramIC_02cm');	% paramIC

if size(param,1) == 82
    param = [param(1:35);[10;0;0;0;-10;0;0;0];param(36:end)];
end
% Ankle settings can be found at param(36:40)

nms_MechInit;
setInitPar;
setCtrlPar;
setCPGPar_inv;

%% Settings
wCPG = 1; 

%% Loading settings
load('HumanData/Settings.mat')