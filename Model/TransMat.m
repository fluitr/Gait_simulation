function loc_frame = TransMat(RotMatrix,Pg,Pa,theta) 
%% Preallocating
loc_frame = zeros(3,length(RotMatrix));

%% Transforming
for i = 1:length(RotMatrix)
   %Calculating tranformation matrix T_BA
   R_AB = [cos(theta(i)) -sin(theta(i)) 0;sin(theta(i)) cos(theta(i)) 0;0 0 1];
   T_BA = [[R_AB';0 0 0] [0;0;0;1]];
   
   %
   R_GA = [RotMatrix(1:3,i) RotMatrix(4:6,i) RotMatrix(7:9,i)];
   T_AG = [[R_GA';0 0 0] [-R_GA'*Pg(:,i);1]];
   temp = T_BA*T_AG*[Pa(:,i);1];
   loc_frame(:,i) = [-temp(2);temp(1);temp(3)];  
end
end