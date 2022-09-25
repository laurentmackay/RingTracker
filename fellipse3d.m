function [merit]= fellipse3d(x,pos,intensity) % x is the initial parameters, data stores the datapoints

a = abs(x(1));
b = abs(x(2));
alpha = x(3);
beta = x(4);
gamma = x(5);
z = x(6:8)';

[dim1, ~]=size(pos);

R1 = [cos(alpha), sin(alpha), 0; -sin(alpha), cos(alpha), 0; 0, 0, 1];
R2 = [1, 0, 0; 0, cos(beta), sin(beta); 0, -sin(beta), cos(beta)];
R3 = [cos(gamma), sin(gamma), 0; -sin(gamma), cos(gamma), 0; 0, 0, 1];
R = R3*R2*R1;

pos = (pos - z)*R; 
% pos(:,3) = exp(-abs(pos(:,3)));

merit = 0;
for i=1:dim1
    dist=@(phi)sum( ([a*cos(phi);b*sin(phi);0]  - pos(i,:)').^2 ); 
    phi=fminbnd(dist,0,2*pi);
    merit = merit+dist(phi)*intensity(i);
end
merit=merit*(1+sqrt(abs(a*b)));
end