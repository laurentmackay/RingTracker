function y = mip(x,i)
if nargin < 2
    i=length(size(x));
end
y=squeeze(max(x,[],i));
end

