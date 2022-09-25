function [outputArg1,outputArg2] = threewaymip(varargin)

i=0;
for x=varargin
    x=x{1};
i=i+1;
subplot(nargin,3,i);
imagesc(mip(x,3))
i=i+1;
subplot(nargin,3,i);
imagesc(mip(x,2))
i=i+1;
subplot(nargin,3,i);
imagesc(mip(x,1))
end
end

