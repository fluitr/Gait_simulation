%   setCPGPar.m
%   set CPG parameters
%
%   given: paramCPG
%
%   set:
%       CPG_On
%       N_start
%       N_Record
%       CPGSize
%       CPGPhaseCheckTs
%       Pc
%       MinLenght of Muscles (for Variable noise)
%       Noise LeveL of NMC
%       Settings for Kalman filter
%
% by Tycho Brug
% May 2016

%% CPG
CPG_On = 1;         % CPG_On = 0 turns off CPG assistance
N_start = 7;        % Number of steps before CPG starts
N_record = 3;       % Number of steps averaged for CPG
CPGSize = 100;      % Size of the learned shape

%% Loading presaved data (if available)
ShapePL_Ph1 = zeros(1,CPGSize);FreqPL_Ph1 = 0;
ShapePL_Ph2 = zeros(1,CPGSize);FreqPL_Ph2 = 0;
ShapePL_Ph3 = zeros(1,CPGSize);FreqPL_Ph3 = 0;
ShapePL_Ph4 = zeros(1,CPGSize);FreqPL_Ph4 = 0;
CPGSaved = 0;
