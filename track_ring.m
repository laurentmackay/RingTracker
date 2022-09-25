[nm, p]=uigetfile('*.tif','Select first image file');
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

start_frame=34;

mip_0 = mip(data(:,:,:,start_frame,channel));



figure(1);imagesc(mip_0);title('Max. Int. Proj. (xy-view) - Please place ROI around ring');
rectxy=GINPUTRECT();
ix=floor(rectxy(1));
lx=ceil(rectxy(3));
iy=floor(rectxy(2));
ly=ceil(rectxy(4));

[~,max_spread]=max(rectxy(3:4));
mip_1 = mip(data(iy:(iy+ly),ix:(ix+lx),:,start_frame,channel),max_spread);
figure(2);imagesc(mip_1');title('Max. Int. Proj. (xz-view) - Please place ROI around ring');

rect2=GINPUTRECT();

iz = floor(rect2(2));
lz = ceil(rect2(4));

coords = [sum(rectxy([1,1,3])) sum(rectxy([2,2,4])) sum(rect2([2,2,4]))]/2;

%%


objectsPrev=coords+0.5+[0 0 0];
objectSize=[rectxy(3:4) rect2(4)]/2;

objectsPrev = objectsPrev([2,1,3]);
objectSize = objectSize([2,1,3]);


searchSize=objectSize+[1,1,1];
i=start_frame;
chan = data(:,:,:,:,1);
sz=size(chan);
sz(3)=4;
% % pad_above = rand(sz)*mean(chan(:))*0.01;
% % chan=cat(3,pad_above,chan);
% while i <= N_frames-2
% %    mip_curr=mip(data(:,:,:,i));
% %     imagesc(mip_curr);
% %     drawnow
%     
%     [objectsNext,n]=estimateVelocity(chan,i,objectsPrev,objectSize,searchSize,'normxcorr');
%     objectsPrev=objectsNext;
%     i=i+n;
% end
% disp('done following ring')