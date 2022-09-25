function pos = getPos(x)
sz=size(x);

inds = arrayfun(@(ell) 1:ell,sz,'UniformOutput',false);
grids=cell(1,length(sz));
[grids{:}]=ndgrid(inds{:});

pos = cell2mat(cellfun(@(y) y(:),grids,'UniformOutput',false));
end

