
% 
% nms_model_ControlInit.m  -  Set neural control parameters of the model
%                             as well as initial conditions and simulink 
%                             control parameters.
%
% H.Geyer
% 5 October 2006
%

% ************************************ %
% 1. General Neural Control Parameters %
% ************************************ %

% feedback delays
LongDelay  = 0.020; % ankle joint muscles [s]
MidDelay   = 0.010; % knee joint muscles [s]
ShortDelay = 0.005; % hip joint muscles [s]

% ****************************** %
% 2. Specific Control Parameters %
% ****************************** %

% -------------------------------
% 2.1 Stance-Leg Feedback Control 
% -------------------------------

% PreStim 
PreStimSOL   =    	param(1) * 0.01; %[]
PreStimTA    =  	param(2) * 0.01; %[]
PreStimGAS   =  	param(3) * 0.01; %[]
PreStimVAS   =      param(4) * 0.08; %[]

% soleus (self, F+)
GainSOL      =     	param(5) * 1.2/FmaxSOL; %[1/N]

% soleus on tibialis anterior (F-)
GainSOLTA    =     	param(6) * 0.4/FmaxSOL; %[1/N]

% tibialis (self, L+, stance & swing)
GainTA       =    	param(7) * 1.1;   %[]
LceOffsetTA  =   	param(8) * (1-0.5*w); %[loptTA]

% gastrocnemius (self, F+)
GainGAS      =      param(9) * 1.1/FmaxGAS; %[1/N] 

% vasti group (self, F+)
GainVAS      =      param(10) * 1.2/FmaxVAS; %[1/N]

% knee overextension on vasti (Phi-, directional)
GainKneOverExt =    param(11) * 2;%
KneePh23Offset =    param(12) * (170*pi/180);

% swing initiation
K_swing =           param(13) * 0.25;%0.25


% ------------------------------
% 2.1 Swing-leg Feedback Control 
% ------------------------------

% Fly
% ---

%Prestim
PreStimHFL   =      param(14) * 0.01; %[] 
PreStimHAM   =      param(15) * 0.01; %[]
PreStimGLU   =      param(16) * 0.01; %[]

% hip flexors (self, L+, swing)
LceOffsetHFL =     	param(17) * 0.65; %[loptHFL]
GainHFL      =    	param(18) * 0.5; %[] 

% balance offset shift (Delta Theta at take-off)
GainDeltaTheta =    param(19) * (2 /100*180/pi); %[percent/deg]

% Catch
% -----

% hip flexor from hamstring stretch reflex (L-, swing)
LceOffsetHAM =      param(20) * 0.85; %[loptHAM]
GainHAMHFL   =      param(21) * 4; %[]

% hamstring group (self, F+, swing)
GainHAM      =      param(22) * (0.65/FmaxHAM); %[1/N]

% gluteus group (self, F+, swing)
GainGLU      =      param(23) * (0.5/FmaxGLU); %[1/N]

% -----------------------------------------------
% 2.2 Stance-Leg HAT Reference Posture PD-Control
% -----------------------------------------------

% stance hip joint position gain
PosGainGG   =   param(24) * (1/(30*pi/180)); %[1/rad]

% stance hip joint speed gain
SpeedGainGG =   param(25) * 0.2; %[s/rad] 

% stance posture control muscles pre-stimulation
PreStimGG   =   param(26) * 0.05; %[]

% stance reference posture
Theta0      =   param(27) * (6*pi/180); %[rad]