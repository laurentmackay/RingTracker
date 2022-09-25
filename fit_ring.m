
ring_vol = getVol(data(:,:,:,34,1), objectsPrev, objectSize);
% ring_vol = data(:,:,:,34,1);
pos = getPos(ring_vol);
[data_sorted, i_sorted] =  sort(ring_vol(:));

%%
N_take = 4e3;
i_take = i_sorted(end-(N_take-1):end);
intensity = ring_vol(i_take);
pos_take = pos(i_take,:);

% remove the center of mass
CM = mean(pos_take);
posp = pos_take - CM;


% now rotate all points into the xy plane ...
% start by finding the plane:

[u s v]=svd(posp);

% rotate the data into the principal axes frame:

posp = posp*v;

x0= [39 12 0.037 pi 2]'; % initial parameters    

a = x0(1);
b = x0(2);
alpha = x0(3);
z = [x0(4:5) ; 0]';

phi = linspace(0,2*pi,100)';
simdat = [a*cos(phi) b*sin(phi) zeros(size(phi))];
R = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0, 0, 1];
simdat = simdat*R  + ones(size(simdat,1), 1)*z ; 


figure(1);clf(); hold on
h=scatter3(posp(:,1),posp(:,2),posp(:,3),36*(intensity-intensity(1)+1)/(intensity(end)-intensity(1)));

plot3(simdat(:,1),simdat(:,2),zeros(size(simdat,1),1),'r-')

%%

% fit the equation for an ellipse to the rotated points


options=optimset('Display','iter');
tic;
xopt = fminsearch(@fellipse,x,options,posp,intensity)
toc


%%


a = xopt(1);
b = xopt(2);
alpha = xopt(3);
z = [xopt(4:5) ; 0]';

phi = linspace(0,2*pi,100)';
simdat = [a*cos(phi) b*sin(phi) zeros(size(phi))];
R = [cos(alpha), -sin(alpha), 0; sin(alpha), cos(alpha), 0; 0, 0, 1];
simdat = simdat*R  + ones(size(simdat,1), 1)*z ; 


figure, hold on
plot3(posp(:,1),posp(:,2),posp(:,3),'o')
plot3(simdat(:,1),simdat(:,2),zeros(size(simdat,1),1),'r-')