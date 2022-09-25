[nm, p]=uigetfile('~/Desktop/*.tif','Select first image file');
fn=[p nm];
data = read_tiff(fn);
disp('Done loading tiff stack')
N_frames=size(data,4);
channel=1;

%%
figure(1);
for i=1:N_frames
    mip_curr=mip(data(:,:,:,i,channel));
    imagesc(mip_curr);
    drawnow
    title(['frame # ' num2str(i)])
end


%%
%data = zeros(width,height,slices,frames,channels);

start_frame=28;

mip_0 = mip(data(:,:,:,start_frame,channel));



figure(1);imagesc(mip_0);title('Max. Int. Proj. (xy-view) - Please Select Objects');
xy_coords=GINPUT2;
xy_coords=fliplr(xy_coords);

N_coords = size(xy_coords,1);
coords=[xy_coords nan(N_coords,1)];

[~,max_spread] = max(abs(diff(xy_coords)));
min_spread = 1*(max_spread==2) + 2*(max_spread==1);
inds = floor(min(xy_coords(:,min_spread))):ceil(max(xy_coords(:,min_spread)));
% if 
if max_spread==2
    mip_1 = mip(data(inds,:,:,start_frame, channel),1);
    drx='y';
else
    mip_1 = mip(data(:,inds,:,start_frame, channel),2);
    drx='x';
end

for i = 1:size(xy_coords,1)
% hline.XData=[1 1]*xy_coords(i,1);
figure(2);imagesc(mip_1');title(['Max. Int. Proj. (' drx 'z-view) - Please Select Vertical Position']);
hline = line([1 1]*xy_coords(i,max_spread)+0.5,[0,size(data,3)+1],'Color','r');

xz_coords=GINPUT2;
coords(i,3)=xz_coords(2);
end
%%


objectsPrev=coords+1;
objectSize=[4 4 1];
searchSize=[8,8,3];
for i = start_frame:N_frames-2
%    mip_c  urr=mip(data(:,:,:,i));
%     imagesc(mip_curr);
%     drawnow
    
    objectsNext=findObjectsAutoXYZ(data(:,:,:,i,channel),data(:,:,:,i+1, channel),objectsPrev,objectSize,searchSize,'normxcorr');
    objectsPrev=objectsNext;
    pause(0.15)
%     saveas(3,['centrosome_track_' num2str(i) '.png'])
end
