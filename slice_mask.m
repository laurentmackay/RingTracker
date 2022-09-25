function mask = slice_mask(xy, p1, p2, w)
%returns a binary mask with a band of width `w` that passes between two points p1 and p2




x1=p1(1);
x2=p2(1);

y1=p1(2);
y2=p2(2);

%https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#:~:text=In%20Euclidean%20geometry%2C%20the%20distance,nearest%20point%20on%20the%20line.
% dist = abs(xy(:,2)-m*xy(:,1)-b)/sqrt(1+m^2);
dist = abs((x2-x1)*(y1-xy(:,2))-(x1-xy(:,1))*(y2-y1))/sqrt((x2-x1)^2+(y2-y1)^2);
mask = dist<w/2;'p[';

end

