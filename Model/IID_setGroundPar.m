%   setGroundPar.m
%   set ground parameters
%
%
% by Tycho Brug
% May 2016

GroundFunction = 2;     %1 = Use Ground function, 2 = Use zero

%% Sinusoidal
% a1 = 5;
% a2 = 1/10;
% b1 = 10;
% b2 = 25; 
% theta = -0.0219;
% RotFunction = 'cos(theta)*u(1) - sin(theta)*u(3)';
% HeightFunction = '(a2 * sin(a1*u(1))) * (u(1) >= b2) + (a2 * sin(a1*u(1))) * ((u(1)-b1)/(b2-b1)) *(u(1) >= b1) * (u(1)< b2)';
% NormalFunction = '(a2 * a1* -cos(a1*u(1))) * (u(1) >= b2) + (a2 *a1* -cos(a1*u(1))) * ((u(1)-b1)/(b2-b1)) *(u(1)>= b1) * (u(1)< b2) ';

%% Hill
a1 = 1/15;
b1 = 5;
b2 = 15; 
theta = 0;

c1 = 0.5 * (a1*b1^2)/(b2-b1); 
c2 = (1/(b2-b1)) * (0.5*a1*b2^2 - a1*b1*b2 + 0.5*a1*b1^2) - a1*b2;
HeightFunction = '(a1*u(1)+c2) * (u(1)>=b2) + ((a1/(2*(b2-b1)))*(u(1)*u(1))-((a1*b1)/(b2-b1))*u(1)+c1) *(u(1)>=b1) * (u(1)<b2)';
NormalFunction = '0 * u(1)';
RotFunction = 'cos(theta)*u(1) - sin(theta)*u(3)';

%% Setting functions
if ~strcmp(get_param('cpg_lib/GroundFunction/HeightFunction','Expression'),HeightFunction)
    set_param('cpg_lib','Lock','off')
    set_param('cpg_lib/GroundFunction/HeightFunction','Expression',HeightFunction);
    save_system('cpg_lib')
end

if ~strcmp(get_param('cpg_lib/GroundFunction/NormalFunction','Expression'),NormalFunction)
    set_param('cpg_lib','Lock','off')
    set_param('cpg_lib/GroundFunction/NormalFunction','Expression',NormalFunction);
    save_system('cpg_lib')
end

if ~strcmp(get_param('cpg_lib/GroundFunction/RotFunction','Expression'),RotFunction)
    set_param('cpg_lib','Lock','off')
    set_param('cpg_lib/GroundFunction/RotFunction','Expression',RotFunction);
    save_system('cpg_lib')
end
