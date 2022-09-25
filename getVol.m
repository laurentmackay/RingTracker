function y = getSubVol(x,pos,subsz)
    sz=size(x);
    bounds = pos+[-1; 1]*subsz;
    inds =  arrayfun(@(i) max(floor(bounds(1,i)),1):min(ceil(bounds(2,i)),sz(i)),1:size(bounds,2),'UniformOutput',0);
    
    y=x(inds{:});
end

