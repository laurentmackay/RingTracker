x0=[0.0372, 2.7652];
figure(6); clf;
ax3=subplot(2,1,2);

ax1=subplot(2,2,1);

ax2=subplot(2,2,2);

scale = [0.183, 0.183, 1];
all_pos = getPos(data(:,:,:,1,1)).* scale;

for i=start_frame:size(data,4)-1

    
full_vol = data(:,:,:,i,1);
ring_vol = getVol(full_vol, objectsPrev, objectSize);
% ring_vol = data(:,:,:,34,1);
pos = getPos(ring_vol)-1;
[~, i_sorted] =  sort(ring_vol(:));

%%
N_take = 4e3;
i_take = i_sorted(end-(N_take-1):end);
intensity = ring_vol(i_take);
pos_take = pos(i_take,:).*scale;



% pos_take = pos_take;




r_hat = @(phi,theta)  [[cos(phi), sin(phi)]*sin(theta), cos(theta)];
theta_hat = @(phi,theta)  [[cos(phi), sin(phi)]*cos(theta), -sin(theta)];
phi_hat = @(phi,theta)  [[-sin(phi), cos(phi)], 0];




options=optimset('Display','iter');
tic
f=@(phi,theta) var((theta_hat(phi,theta) *pos_take'));
xopt=fminsearch(@(x) f(x(1),x(2)),x0,options)
toc

phi=xopt(1);
theta=xopt(2);
XY=[r_hat(phi,theta) * pos_take'; phi_hat(phi,theta) * pos_take']';

% Zed= @(phi,theta) (theta_hat(phi,theta) * pos_take')';
% Zedbar= @(phi,theta) mean(Zed(phi,theta));
% ring_width=2;

% Z=Zed(phi,theta);
% Zbar=Zedbar(phi,theta);
% Zbar0=Zbar;
% x0=xopt;

% intensity2 = exp(-((Z-Zbar).^2)/(2*ring_width^2));
Zed= @(phi,theta) (theta_hat(phi,theta) * pos_take')';
Zedbar= @(phi,theta) mean(Zed(phi,theta));

p0=EllipseDirectFit(XY);
xysamp0=sampleEllipse2D(p0);



Z=Zed(phi,theta);
Zbar=Zedbar(phi,theta);


ring_width=2

near_ring = abs(Zed(phi,theta)-Zedbar(phi,theta))<1*ring_width;


p=EllipseDirectFit(XY(near_ring,:));
xysamp=sampleEllipse2D(p);

markersize=24*scaleVals(intensity,0.5);

% figure(5); 
scatter(ax1, XY(:,1),XY(:,2),'.');
title(ax1,'2D View')
hold(ax1,'on');
plot(ax1,xysamp(:,1)+p(end-1),xysamp(:,2)+p(end),'-g','LineWidth',3)
% plot(ax1,xysamp0(:,1)+p(end-1),xysamp0(:,2)+p(end),'--k')
hold(ax1,'off')
xlabel(ax1,'$\hat{x}$','interpreter','latex');ylabel(ax1,'$\hat{y}$','interpreter','latex');

% R= @(x) [r_hat(x(1),x(2))' , phi_hat(x(1),x(2))', theta_hat(x(1),x(2))'];
% R= @(x) [r_hat(x(1),x(2)); phi_hat(x(1),x(2)); theta_hat(x(1),x(2))];
Ropt=[r_hat(phi,theta); phi_hat(phi,theta); theta_hat(phi,theta)];
Ropt=[r_hat(phi,theta)', phi_hat(phi,theta)', theta_hat(phi,theta)'];
Rinv = inv(Ropt);
% xyzsamp=(Ropt * [xysamp-p(end-1:end), zeros(size(xysamp,1),1)]')'+[p(end-1:end),0];
xyzsamp=([xysamp+p(end-1:end), zeros(size(xysamp,1),1)]')';
xyzsamp0=([xysamp0, zeros(size(xysamp,1),1)]')';
% XYZ=(Ropt * pos_take')';
xyzsamp = xyzsamp + [0,0, Zbar];

xyzsamp3 = (Ropt*xyzsamp')';

rhat=r_hat(phi,theta);
thetahat=theta_hat(phi,theta);
phihat=phi_hat(phi,theta);
offset = p(end-1)*rhat+p(end)*phihat;
% xyzsamp2=xyzsamp3 +((objectsPrev.*scale)*theta_hat(phi,theta)')*theta_hat(phi,theta);
xyzsamp2= xyzsamp3 +((objectsPrev-objectSize).*scale);



% figure(7)
scatter3(ax2, XY(:,1),XY(:,2),Z,'Marker','.', 'SizeData', markersize);

hold(ax2,'on')
title(ax2,'Ring-Centered 3D View')
plot3(ax2, xyzsamp(:,1),xyzsamp(:,2),xyzsamp(:,3),'-g', 'LineWidth', 3)
% plot3(ax2, xyzsamp0(:,1),xyzsamp0(:,2),xyzsamp0(:,3)+Zbar,'--k')
hold(ax2,'off')
xlabel(ax2,'$\hat{x}$','interpreter','latex');ylabel(ax2,'$\hat{y}$','interpreter','latex');zlabel(ax2,'$\hat{z}$','interpreter','latex');

bright = full_vol(:)>=intensity(1);
intensity = full_vol(bright);
bright_pos = all_pos(bright,:);
markersize=24*scaleVals(intensity,0.5);
figure(6)
scatter3(ax3, bright_pos(:,1),bright_pos(:,2), -bright_pos(:,3),'Marker','.', 'SizeData', markersize)
hold(ax3,'on')

plot3(ax3, xyzsamp2(:,1),xyzsamp2(:,2),-xyzsamp2(:,3),'-g', 'LineWidth', 3)

hold(ax3,'off')
xlabel(ax3,'X');ylabel(ax3,'Y');zlabel(ax3,'Z');
% view([0,0,1])
if i>start_frame
    view(ax3,AZ,EL)
else
    view(ax3,45,60)
end
xlim(ax3,[0,size(data,1)]*scale(1))
ylim(ax3,[0,size(data,2)]*scale(2))
zlim(ax3,[-size(data,3),0]*scale(3))



title(ax3,'Full 3D View')

drawnow
% pause(4)
[AZ,EL] = view(ax3);


end