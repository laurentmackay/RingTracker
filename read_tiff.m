function [data, varargout] = read_tiff(fn)

    function val = parseDescription(key)
        key_str = strcat(string(key),"=");
        mask = ~cellfun(@isempty,regexp(desc,key_str));
        if nnz(mask)>0
            val_str = desc(mask);
            val=str2double(regexprep(val_str,key_str,''));
        else
            val=1;
        end
    end

warning('off','all')
tstack = Tiff(fn);
warning('on','all')

[width,height] = size(tstack.read());
info = imfinfo(fn);
desc=strsplit(string(info(1).ImageDescription),newline);

channels = parseDescription('channels');
frames = parseDescription('frames');
slices = parseDescription('slices');




data = zeros(width,height,slices,frames,channels);
% varargout{1}=data;



if nargout==2
    scale = 1./[info(1).XResolution, info(1).YResolution, 1];
    varargout={scale};
end

for j = 1:frames
    for i=1:slices
        for k=1:channels
            data(:,:,i,j,k) = tstack.read();   
            if tstack.lastDirectory()
                break;
            else
                tstack.nextDirectory();
            end
        end
    end
end


end

