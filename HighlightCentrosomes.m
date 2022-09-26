        function out=HiglightCentrosomes(app, varargin)

            if isempty(varargin)
                varargin={{},{}};
            end

            function annotate(xy_coords, max_spread)

                if isempty(app.SpindleLine)
                    return
                end

                set(app.SpindleLine,varargin{1}{:})

                colors=['y', 'y'];



                if isempty(app.SideLines)
                    for i = 1:size(xy_coords,1)
                        app.SideLines(i) = line( app.SideAxes, [1 1]*xy_coords(i,max_spread),[0,size(app.data,3)+1],'Color',colors(i));
                    end
                else

                    for i = 1:size(xy_coords,1)
                        set(app.SideLines(i),'XData',[1 1]*xy_coords(i,max_spread));
                    end
                end

                
                    pos1=fliplr(xy_coords(1, :));
                    pos2=fliplr(xy_coords(2, :));
                    m=slope(pos1, pos2);
                    b=offset( pos1, pos2);

                    xmin=0;
                    xmax=size(app.data,2)*app.scale(2);

                    ymin=0;
                    ymax=size(app.data,1)*app.scale(1);

                    if b<ymax
                        y0=b;
                        x0=0;
                    else
                        y0=ymax;
                        x0=(ymax-b)/m;
                    end

                    y1=b+xmax*m;
                    if y1>ymax
                        y1=ymax;
                        x1=(ymax-b)/m;
                    else
                        x1=xmax;
                    end
                    disp(m)
                    if isempty(app.TopDownLines)

                        app.TopDownLines(1)=line(app.TopDownAxes, [x0, x1], [y0, y1],'Color','w', 'LineWidth',0.1);
                        app.TopDownLines(2)=line(app.TopDownAxes, [x0, x1], [y0, y1],'Color','w', 'LineWidth',0.1);



                    end

                    w=app.SearchWidth.Value/2;
                    delta_x = w*sqrt(1/(1+(1/m)^2));
                    delta_y = -delta_x/m;
                    set(app.TopDownLines(1),'XData', [x0, x1] + delta_x,'YData', [y0, y1] + delta_y,varargin{2}{:});
                    set(app.TopDownLines(2),'XData', [x0, x1] - delta_x,'YData', [y0, y1] - delta_y,varargin{2}{:});

            end


            function inner(line, evt)
                DrawVerticalSlice(app, line, @annotate)
            end
            out = @inner;
        end