function y = scaleVals(x,min_scale)
if nargin==1
    min_scale=0;
end
maxx=max(x);
minx=min(x);
y = (x-minx+min_scale*maxx)/((1+min_scale)*maxx-minx);
end

