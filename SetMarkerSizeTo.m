function out=setMarkerSizeTo(sz)
function inner(x, varargin)
    x.MarkerSize=sz;
end
out = @inner;
end

