function [merit]= fellipse(x,pos,intensity) % x is the initial parameters, data stores the datapoints

a = x(1);
b = x(2);
alpha = x(3);    
z = x(4:5);

R = [cos(alpha), sin(alpha), 0; -sin(alpha), cos(alpha), 0; 0, 0, 1];
pos = pos*R; 

merit = 0;

[dim1, dim2]=size(pos);
for i=1:dim1
    dist=@(phi)sum( ( [a*cos(phi);b*sin(phi)] + z - pos(i,1:2)').^2 ); 
    phi=fminbnd(dist,0,2*pi);
    merit = merit+dist(phi)*intensity(i);
end

end