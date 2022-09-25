function y = com(x)
sz=size(x);

inds = arrayfun(@(ell) 1:ell,sz,'UniformOutput',false);
grids=cell(length(sz),1);
[grids{:}]=ndgrid(inds{:});

y=zeros(length(sz),1);
minx=min(x(:));
for i=1:length(sz)
    y(i)=sum(grids{i}(:).*(x(:)-minx));
end
y=y/sum(x(:)-minx);
end

