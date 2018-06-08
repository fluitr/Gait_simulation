%
% setInitPar.m
%   set initial parameters
%   given: paramIC
%
% by Seungmoon Song
% Jan 2014
%
standing_still = 0; 
switch standing_still
    case 0
        XonX_On = 1; 
<<<<<<< HEAD
<<<<<<< HEAD
        vx0              	= paramIC(1)  	*1; %[m/s]
=======
        vx0              	= paramIC(1)  	*1.3; %[m/s]
>>>>>>> Git init
=======
        vx0              	= paramIC(1)  	*1.0; %[m/s]
>>>>>>> Updata for speed
        Lphi120             = paramIC(2)   	*100*pi/180; %[rad]
        Lphi230             = paramIC(3)   	*180*pi/180; %[rad]
        Lphi340             = paramIC(4) 	*165*pi/180; %[rad]
        Rphi120             = paramIC(5)  	*90*pi/180; %[rad]
        Rphi230             = paramIC(6)  	*165*pi/180; %[rad]
        Rphi340             = paramIC(7)   	*200*pi/180; %[rad]
        Lphi340R            = paramIC(8)*(-1)*pi/180;
        Rphi340R            = paramIC(9)*(-1)*pi/180;
        
        vy0 = paramIC(10)*.2;
        
        x0      = .2;
        y0      = D12z_T;
        z0      = paramIC(11)      *.01;
        yaw0    = 0*pi/180;
        roll0   = (-1)*pi/180;
        
        init_a_tgt  = 70*pi/180;
        init_a_tgtR = 90*pi/180;
        
    case 1
        XonX_On = 0; 
        paramIC(1:end) = 1;
        splitDegrees = 10;
        vx0              	= paramIC(1)  	* 0; %[m/s]
        Lphi120             = paramIC(2)   	* (90-splitDegrees) * pi/180; %[rad]
        Lphi230             = paramIC(3)   	* 180*pi/180; %[rad]
        Lphi340             = paramIC(4) 	* (180+splitDegrees) * pi/180; %[rad]
        Rphi120             = paramIC(5)  	* (90 + splitDegrees) * pi/180; %[rad]
        Rphi230             = paramIC(6)  	* 180*pi/180; %[rad]
        Rphi340             = paramIC(7)   	* (180-splitDegrees) * pi/180; %[rad]
        Lphi340R            = paramIC(8)    * 0*pi/180;
        Rphi340R            = paramIC(9)    * 0*pi/180;
        
        vy0 = paramIC(10)*0;
        
        x0      = .2;
        y0      = D12z_T;
        z0      = 0      *.01;
        yaw0    = pi/180;
        roll0   = (-1)*pi/180;
        
        init_a_tgt  = 70*pi/180;
        init_a_tgtR = 90*pi/180;
end
