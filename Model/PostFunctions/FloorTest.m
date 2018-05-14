a1 = 1/2;
b1 = 5;
b2 = 15; 
c1 = 0.5 * (a1*b1^2)/(b2-b1); 
c2 = (1/(b2-b1)) * (0.5*a1*b2^2 - a1*b1*b2 + 0.5*a1*b1^2) - a1*b2;

% HeightFunction = '(groundcoeff_b * sin(a1*u(1))) * (u(1) >= 10) + (groundcoeff_b * sin(a1*u(1))) * ((u(1)-5)/5) *(u(1)> 5) * (u(1)< 10)';
% NormalFunction = '(groundcoeff_b * a1* -cos(a1*u(1))) * (u(1) >= 10) + (groundcoeff_b *a1* -cos(a1*u(1))) * ((u(1)-5)/5) *(u(1)> 5) * (u(1)< 10) ';

HeightFunction = '(a1*u(1)+c2) * (u(1)>=b2) + ((a1/(2*(b2-b1)))*(u(1)*u(1))-((a1*b1)/(b2-b1))*u(1)+c1) *(u(1)>=b1) * (u(1)<b2)';
NormalFunction = '(a1) * (u(1) >= b2) + (a1) * ((u(1)-b1)/(b2-b1)) *(u(1)> b1) * (u(1)< b2)';

% groundcoeff_a = 5;
% groundcoeff_b = 1/100;
% HeightFunction = '(groundcoeff_b * sin(groundcoeff_a*u(1))) * (u(1) >= 10) + (groundcoeff_b * sin(groundcoeff_a*u(1))) * ((u(1)-5)/5) *(u(1)> 5) * (u(1)< 10)';
% NormalFunction = '(groundcoeff_b * groundcoeff_a* -cos(groundcoeff_a*u(1))) * (u(1) >= 10) + (groundcoeff_b *groundcoeff_a* -cos(groundcoeff_a*u(1))) * ((u(1)-5)/5) *(u(1)> 5) * (u(1)< 10) ';

HeightFunctionMovie = ['Z =',HeightFunction,' ;'];
NormalFunctionMovie = ['Z =',NormalFunction,' ;'];

x_grid = 0:0.5:30;y_grid  = 0:0.5:30;
z_grid = zeros(length(x_grid),length(y_grid));
theta = -0.0219;
for i_x = 1:length(x_grid)
    for i_y = 1: length(y_grid)
        u(1) = cos(theta)*x_grid(i_x) - sin(theta)*y_grid(i_y) ; u(2) = sin(theta)*x_grid(i_x) + cos(theta) *  y_grid(i_y);
        eval(HeightFunctionMovie);
        z_grid(i_x,i_y) = Z;
    end
end

[X,Y] = meshgrid(x_grid,y_grid);
surf(X,Y,z_grid')
xlabel('x'); ylabel('y')