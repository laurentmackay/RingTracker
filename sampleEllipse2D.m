function x = sampleEllipse2D(p,n)
if nargin<2
    n=100;
end
a=p(1);
b=p(2);
phi=p(3);
theta=linspace(0,2*pi,n)';
x0=p(4);
y0=p(5);
% if a>b
x=[a*cos(theta), b*sin(theta)];
% else
%     x=[b*cos(theta), a*sin(theta)];
% end
R=[cos(phi), -sin(phi);sin(phi), cos(phi)];
x=(R*x')'+[x0,y0];
end

