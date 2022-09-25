
pos_take2 = pos_take.*[0.183,0.183,1]

phi=0.0372;
theta=2.7652;


r_hat = @(phi,theta)  [[cos(phi), sin(phi)]*sin(theta), cos(theta)];
theta_hat = @(phi,theta)  [[cos(phi), sin(phi)]*cos(theta), -sin(theta)];
phi_hat = @(phi,theta)  [[-sin(phi), cos(phi)], 0];


XY=[sum(pos_take2.*r_hat(phi,theta),2), sum(pos_take2.*phi_hat(phi,theta),2)];
Z=std(sum(pos_take2.*r_hat(theta,pi/2),2));
options=optimset('Display','iter');
tic
f=@(phi,theta) var(sum(pos_take2.*theta_hat(phi,theta),2).*intensity);
xopt=fminsearch(@(x) f(x(1),x(2)),[0,pi/2],options)
toc


figure(5);clf();
scatter(XY(:,1),XY(:,2));

p=EllipseDirectFit(XY);
xysamp=sampleEllipse2D(p);
figure(5); hold on;
plot(xysamp(:,1),xysamp(:,2),'-r')




R= @(x) [r_hat(x(1),x(2))' , phi_hat(x(1),x(2))', theta_hat(x(1),x(2))'];
Ropt=R(xopt);
Rinv = inv(Ropt);
% xyzsamp=(Ropt * [xysamp-p(end-1:end), zeros(size(xysamp,1),1)]')'+[p(end-1:end),0];
xyzsamp=([xysamp, zeros(size(xysamp,1),1)]')';
XYZ=(Ropt * [pos_take2(:,1),pos_take2(:,2),pos_take2(:,3)]')';
xyzsamp = xyzsamp +[0,0,mean(XYZ(:,3))];
figure(6); clf;
scatter3(XYZ(:,1),XYZ(:,2),XYZ(:,3),24*(intensity-intensity(1)+1)/(intensity(end)-intensity(1)))
hold on
plot3(xyzsamp(:,1),xyzsamp(:,2),xyzsamp(:,3),'-r')
hold off