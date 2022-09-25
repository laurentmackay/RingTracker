function [objectsNext,n]=estimateVelocity(data,frame,objectsPrev,objectSize,searchSize,trackMethod)
plotting = true;
% This function takes two successive images and a set of coordinates and
% finds the new locations of the objects marked by the coordinates.  Three
% global variables are required - objectSize, searchSize and trackMethod.
% objectsize is the size of the object to be tracked in pixel units,
% searchSize is the expected size of the region in which the object might
% move (centered on the previous location) also in units of pixels and
% trackMethod is a string ('Xcorr2', 'NormXcorr2' or 'Max') which specifies
% the tracking method to be used.
%
% The syntax for the function call is
%
% >> nextCoords=trackObjects(prevImg,nextImg,prevCoords)
%

N_dim = ndims(data)-1;
m1=cell(1,N_dim);
m2=cell(1,N_dim);

if N_dim ==3
    normxcorr=@normxcorr3;
elseif N_dim==2
    normxcorr=@normxcorr2;
end


prev=data(:,:,:,frame-1);
curr=data(:,:,:,frame);
sz=size(curr);


N_objects=size(objectsPrev,1);
N_dim = ndims(curr);
objectsNext=nan(size(objectsPrev));


for o=1:N_objects
    
    % The image of the object to be searched for:
    object_bounds = objectsPrev(o,:)+[-1; 1]*objectSize;
    inds =  arrayfun(@(i) max(floor(object_bounds(1,i)),1):min(ceil(object_bounds(2,i)),sz(i)),1:size(object_bounds,2),'UniformOutput',0);
    
    objectImage=curr(inds{:});
    

    
    if strcmp(trackMethod,'xcorr')
        flipped_object = objectImage;
        for i=1:N_dim
            flipped_object = flip(flipped_object,i);
        end
    end
    % The image search zone in the previous image (searchZone1) will give the previous
    % coordinates of the object in the search zone reference frame.  This
    % is a lazy way of dealing with the coordinate change.  The benefit of
    % it is that if, for some strange reason (it happens), the search image
    % has a better match in the previous search frame than itself, it will
    % probably have a similar better match in the next search frame.  So
    % the xcorr algorithm will err twice, returning the
    % translation of the wrong object - most likely a correct translation
    % for the true object as well.  Possible quirks???
    
    
    search_bounds = objectsPrev(o,:)+[-1; 1]*searchSize;
    
    inds =  arrayfun(@(i) max(floor(search_bounds(1,i)),1):min(ceil(search_bounds(2,i)),sz(i)),1:size(search_bounds,2),'UniformOutput',0);
    
    
    searchZone1=prev(inds{:});
    
        switch trackMethod
        case 'xcorr'
            sig1 = convn(searchZone1,flipped_object);
        case 'normxcorr'
            sig1=normxcorr(objectImage,searchZone1);
        case 'max'
            sig1=searchZone1;
        end
        [~,i1]=max(sig1(:));
    [m1{:}] = ind2sub(size(sig1),i1);
    
    
    deltaM=zeros(1,N_dim);
    n=0;
    while all(deltaM==0)
        
    n=n+1;
    next=data(:,:,:,frame+n);
    
    searchZone2=next(inds{:});
    
    figure(4);
    threewaymip(searchZone2)
    cm = com(searchZone2)
    cm2 = com(mip(searchZone2))
        subplot(1,3,1);
        hold on
    plot(cm(2),cm(1),'ro','MarkerSize',12);
     plot(cm2(2),cm2(1),'gx','MarkerSize',12);
     hold off
    subplot(1,3,2);
        hold on
    plot(cm(3),cm(1),'ro','MarkerSize',12);
    hold off
     subplot(1,3,3);
    hold on
    plot(cm(3),cm(2),'ro','MarkerSize',12);
    hold off
    drawnow
    
    switch trackMethod
        
        case 'xcorr'
            sig1 = convn(searchZone1,flipped_object);
            sig2 = convn(searchZone2,flipped_object);
        case 'normxcorr'
            sig1=normxcorr(objectImage,searchZone1);
            sig2=normxcorr(objectImage,searchZone2);
        case 'max'
            sig1=searchZone1;
            sig2=searchZone2;
    end

    [~,i2]=max(sig2(:));
    [m2{:}] = ind2sub(size(sig2),i2);
%     
%     com1=com(searchZone1);
%     com2=com(searchZone2);
%     (com2-com1)'
% (cell2mat(m2)-cell2mat(m1))
    deltaM = (cell2mat(m2)-cell2mat(m1));
    end
%     if n>1
%         deltaM=deltaM/(n-1);
%     end
    objectsNext(o,:) = objectsPrev(o,:) + deltaM  ;
% objectsNext(o,:) = objectsPrev(o,:) + (com2-com1)';
    
end
%
if plotting
    figure(3);
for i=1:n
threewaymip(data(:,:,:,frame+i))
    objectsNext = objectsPrev + deltaM*(i/(n+1));
    subplot(1,3,1);
        hold on
    plot(objectsNext(:,2),objectsNext(:,1),'ro','MarkerSize',12);
     hold off
    subplot(1,3,2);
        hold on
    plot(objectsNext(:,3),objectsNext(:,1),'ro','MarkerSize',12);
    hold off
     subplot(1,3,3);
    hold on
    plot(objectsNext(:,3),objectsNext(:,2),'ro','MarkerSize',12);
    hold off
    drawnow
end
end
