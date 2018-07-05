%   setGroundPar.m
%   set ground parameters
%
%
% by Tycho Brug
% May 2016
<<<<<<< HEAD
<<<<<<< HEAD
% Edited by Rene, June 2018

GroundFunction = 1;     %1 = Use Ground function, 2 = Use zero

% set type of ground
GroundType = 2; 

switch GroundType
    case 1 % Ramp ascent or descent
        a1 = -1/30; % incline of ramp
        b1 = 3; % in meter, slow start of ramp
        b2 = 6; % in meter, full ramp
        c1 = 0.5 * (a1*b1^2)/(b2-b1); 
        c2 = (1/(b2-b1)) * (0.5*a1*b2^2 - a1*b1*b2 + 0.5*a1*b1^2) - a1*b2;
%         u = 0:0.01:25;
%         for i = 1:length(u)
%             height(i) = (a1*u(i)+c2) * (u(i)>=b2) + ((a1/(2*(b2-b1)))*(u(i)*u(i))-((a1*b1)/(b2-b1))*u(i)+c1) *(u(i)>=b1) * (u(i)<b2);
%             norm(i) = (a1) * (u(i)>=b2) + (a1) * ((u(i)-b1)/(b2-b1)) *(u(i)> b1) * (u(i)< b2);
%         end
%         plot(u, height);
        HeightFunction = '(a1*u(1)+c2) * (u(1)>=b2) + ((a1/(2*(b2-b1)))*(u(1)*u(1))-((a1*b1)/(b2-b1))*u(1)+c1) *(u(1)>=b1) * (u(1)<b2)';
        NormalFunction = '(a1) * (u(1)>=b2) + (a1) * ((u(1)-b1)/(b2-b1)) *(u(1)> b1) * (u(1)< b2) ';
    case 2 % Random height
        a1 = 0.05; % max. meters of difference
        b1 = 2; % start of random height
        b2 = 1; % length of section
        ran_h = a1*(rand(1,10)-0.5);
        ran_d = b1+(1:10)*b2;
        HeightFunction = '(u(1)>ran_d(1))*ran_h(1)+(u(1)>ran_d(2))*ran_h(2)+(u(1)>ran_d(3))*ran_h(3)+(u(1)>ran_d(4))*ran_h(4)+(u(1)>ran_d(5))*ran_h(5)+(u(1)>ran_d(6))*ran_h(6)+(u(1)>ran_d(7))*ran_h(7)+(u(1)>ran_d(8))*ran_h(8)+(u(1)>ran_d(9))*ran_h(9)+(u(1)>ran_d(10))*ran_h(10)';
        NormalFunction = '0';
end
    RotFunction = 'cos(theta)*u(1)-sin(theta)*u(3)';
    theta = -0.0219;
=======
=======
% Edited by Rene, June 2018
>>>>>>> Update of model

GroundFunction = 1;     %1 = Use Ground function, 2 = Use zero

<<<<<<< HEAD
c1 = 0.5 * (a1*b1^2)/(b2-b1); 
c2 = (1/(b2-b1)) * (0.5*a1*b2^2 - a1*b1*b2 + 0.5*a1*b1^2) - a1*b2;
HeightFunction = '(a1*u(1)+c2) * (u(1)>=b2) + ((a1/(2*(b2-b1)))*(u(1)*u(1))-((a1*b1)/(b2-b1))*u(1)+c1) *(u(1)>=b1) * (u(1)<b2)';
NormalFunction = '(a1) * (u(1)>=b2) + (a1) * ((u(1)-b1)/(b2-b1)) *(u(1)> b1) * (u(1)< b2) ';
% NormalFunction = '0 * u(1)';
RotFunction = 'cos(theta)*u(1) - sin(theta)*u(3)';
>>>>>>> Git init
=======
% set type of ground
GroundType = 2; 

switch GroundType
    case 1 % Ramp ascent or descent
        a1 = -1/30; % incline of ramp
        b1 = 3; % in meter, slow start of ramp
        b2 = 6; % in meter, full ramp
        c1 = 0.5 * (a1*b1^2)/(b2-b1); 
        c2 = (1/(b2-b1)) * (0.5*a1*b2^2 - a1*b1*b2 + 0.5*a1*b1^2) - a1*b2;
%         u = 0:0.01:25;
%         for i = 1:length(u)
%             height(i) = (a1*u(i)+c2) * (u(i)>=b2) + ((a1/(2*(b2-b1)))*(u(i)*u(i))-((a1*b1)/(b2-b1))*u(i)+c1) *(u(i)>=b1) * (u(i)<b2);
%             norm(i) = (a1) * (u(i)>=b2) + (a1) * ((u(i)-b1)/(b2-b1)) *(u(i)> b1) * (u(i)< b2);
%         end
%         plot(u, height);
        HeightFunction = '(a1*u(1)+c2) * (u(1)>=b2) + ((a1/(2*(b2-b1)))*(u(1)*u(1))-((a1*b1)/(b2-b1))*u(1)+c1) *(u(1)>=b1) * (u(1)<b2)';
        NormalFunction = '(a1) * (u(1)>=b2) + (a1) * ((u(1)-b1)/(b2-b1)) *(u(1)> b1) * (u(1)< b2) ';
    case 2 % Random height
        a1 = 0.05; % max. meters of difference
        b1 = 2; % start of random height
        b2 = 1; % length of section
        ran_h = a1*(rand(1,10)-0.5);
        ran_d = b1+(1:10)*b2;
        HeightFunction = '(u(1)>ran_d(1))*ran_h(1)+(u(1)>ran_d(2))*ran_h(2)+(u(1)>ran_d(3))*ran_h(3)+(u(1)>ran_d(4))*ran_h(4)+(u(1)>ran_d(5))*ran_h(5)+(u(1)>ran_d(6))*ran_h(6)+(u(1)>ran_d(7))*ran_h(7)+(u(1)>ran_d(8))*ran_h(8)+(u(1)>ran_d(9))*ran_h(9)+(u(1)>ran_d(10))*ran_h(10)';
        NormalFunction = '0';
end
    RotFunction = 'cos(theta)*u(1)-sin(theta)*u(3)';
    theta = -0.0219;
>>>>>>> Update of model

%% Setting functions
if ~strcmp(get_param('nmc/GroundFunction/VariableGroundFunction/HeightFunction','Expression'),HeightFunction)
    set_param('nmc','Lock','off')
    set_param('nmc/GroundFunction/VariableGroundFunction/HeightFunction','Expression',HeightFunction);
    save_system('nmc')
end

if ~strcmp(get_param('nmc/GroundFunction/VariableGroundFunction/NormalFunction','Expression'),NormalFunction)
    set_param('nmc','Lock','off')
    set_param('nmc/GroundFunction/VariableGroundFunction/NormalFunction','Expression',NormalFunction);
    save_system('nmc')
end

if ~strcmp(get_param('nmc/GroundFunction/VariableGroundFunction/RotFunction','Expression'),RotFunction)
    set_param('nmc','Lock','off')
    set_param('nmc/GroundFunction/VariableGroundFunction/RotFunction','Expression',RotFunction);
    save_system('nmc')
end
