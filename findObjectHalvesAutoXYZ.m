function objectsNext=findObjectsAutoXYZ(prev,curr,next,objectsPrev,objectSize,searchSize,trackMethod)
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

N_dim = ndims(prev);
m1=cell(1,N_dim);
m2=cell(1,N_dim);


if N_dim ==3
    normxcorr=@normxcorr3;
elseif N_dim==2
    normxcorr=@normxcorr2;
end

sz=size(prev);
scale=[5, 5, 1];
prev=imresize3(prev,sz.*scale);
next=imresize3(next,sz.*scale);
curr=imresize3(curr,sz.*scale);

objectsPrev = (objectsPrev-1).*scale+1;
objectSize = (objectSize-1).*scale+1;
searchSize = (searchSize-1).*scale+1;

N_objects=size(objectsPrev,1);
N_dim = ndims(prev);
objectsNext=nan(size(objectsPrev));


m1tot=zeros(3,length(sz)*2);
m2tot=zeros(3,length(sz)*2);


for o=1:N_objects
    
    % The image of the object to be searched for:
    
    object_bounds_0 = objectsPrev(o,:)+[-1; 1]*objectSize;
%     object_bounds = repmat(object_bounds_0,[1,1,2*length(sz)]);
    objectImages=cell(2*length(sz));
    for i=1:length(sz)
        object_bounds = object_bounds_0;
        object_bounds(1,i) = objectsPrev(o,i);
        inds =  arrayfun(@(i) max(floor(object_bounds(1,i)),1):min(ceil(object_bounds(2,i)),sz(i)*scale(i)),1:size(object_bounds,2),'UniformOutput',0);
        
        objectImages{2*i-1} = curr(inds{:});
        
        object_bounds = object_bounds_0;
        object_bounds(2,i) = objectsPrev(o,i);
        
       inds =  arrayfun(@(i) max(floor(object_bounds(1,i)),1):min(ceil(object_bounds(2,i)),sz(i)*scale(i)),1:size(object_bounds,2),'UniformOutput',0);
        
        objectImages{2*i} = curr(inds{:});
        
    end
%     inds =  arrayfun(@(i) max(floor(object_bounds(1,i)),1):min(ceil(object_bounds(2,i)),sz(i)),1:size(object_bounds,2),'UniformOutput',0);
    
%     objectImage=prev(inds{:});
    

    
%     if strcmp(trackMethod,'xcorr')
%         flipped_object = objectImage;
%         for i=1:N_dim
%             flipped_object = flip(flipped_object,i);
%         end
%     end
    % The image search zone in the previous image (searchZone1) will give the previous
    % coordinates of the object in the search zone reference frame.  This
    % is a lazy way of dealing with the coordinate change.  The benefit of
    % it is that if, for some strange reason (it happens), the search image
    % has a better match in the previous search frame than itself, it will
    % probably have a similar better match in the next search frame.  So
    % the xcorr algorithm will err twice, returning the
    % translation of the wrong object - most likely a correct translation
    % for the true object as well.  Possible quirks???
    
    
    search_bounds_0 = objectsPrev(o,:)+[-1; 1]*searchSize;
    searchZones1=cell(2*length(sz));
     searchZones2=cell(2*length(sz));
        for i=1:length(sz)
        search_bounds = search_bounds_0;
        search_bounds(1,i) = objectsPrev(o,i);
        
        
                inds =  arrayfun(@(i) max(floor(search_bounds(1,i)),1):min(ceil(search_bounds(2,i)),sz(i)*scale(i)),1:size(search_bounds,2),'UniformOutput',0);
        
        searchZones1{2*i-1} = prev(inds{:});
         searchZones2{2*i-1} = next(inds{:});
        
                 search_bounds = search_bounds_0;
        search_bounds(2,i) = objectsPrev(o,i);
        
        
                inds =  arrayfun(@(i) max(floor(search_bounds(1,i)),1):min(ceil(search_bounds(2,i)),sz(i)*scale(i)),1:size(search_bounds,2),'UniformOutput',0);
        
        searchZones1{2*i} = prev(inds{:});
         searchZones2{2*i} = next(inds{:});
        
        end
    
%     inds =  arrayfun(@(i) max(floor(search_bounds(1,i)),1):min(ceil(search_bounds(2,i)),sz(i)),1:size(search_bounds,2),'UniformOutput',0);
    
    
%     searchZone1=prev(inds{:});
%     searchZone2=next(inds{:});
%     
%     figure(4);
%     threewaymip(searchZone2)
%     drawnow
    for i=1:2*length(sz)
            sig1=normxcorr(objectImages{i},searchZones1{i});
            sig2=normxcorr(objectImages{i},searchZones2{i});
            
        [~,i1]=max(sig1(:));
        [m1{:}] = ind2sub(size(sig1),i1);

        [~,i2]=max(sig2(:));
        [m2{:}] = ind2sub(size(sig2),i2);
        
        try
        m1tot(:,i)=cell2mat(m1);
        m2tot(:,i)=cell2mat(m2);
        catch err
            disp(err)
        end
        
    end

    

% (cell2mat(m2)-cell2mat(m1))
    objectsNext(o,:) = objectsPrev(o,:) + mean((m2tot-m1tot),2)'./(2);
% objectsNext(o,:) = objectsPrev(o,:) + (com2-com1)';
    
end
%
if plotting
    figure(3);

threewaymip(data(:,:,:,frame+1))

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

 objectsNext= objectsNext./scale

