        function DrawVerticalSlice(app, line, callback)

            xy_coords = fliplr(get(line, 'Position'));



            [~,max_spread] = max(abs(diff(xy_coords)));
            app.max_spread=max_spread;
            min_spread = 1*(max_spread==2) + 2*(max_spread==1);
            inds = floor(min(xy_coords(:,min_spread))/app.scale(min_spread)):ceil(max(xy_coords(:,min_spread))/app.scale(min_spread));

            inds2 = ~slice_mask(app.all_pos, xy_coords(1,:), xy_coords(2,:), 1);
            data = app.data(:,:,:,app.curr_frame, app.channel);
            inds3=sub2ind(size(app.data,[1,2,3]), app.pos_inds(inds2, 1), app.pos_inds(inds2, 2), app.pos_inds(inds2, 3));

            data(inds3)=0;

            if max_spread==2
                mip_1 = mip(data,1);
                drx='y';
            else
                mip_1 = mip(data,2);
                drx='x';
            end

            app.SideImage.CData=mip_1';
            xdata = (1:(size(mip_1',2)))*app.scale(max_spread);
            app.SideAxes.XLim=[xdata(1), xdata(end)+app.scale(max_spread)];
            app.SideImage.XData=xdata;

            if nargin==3
                callback(xy_coords, max_spread);
            end

            drawnow limitrate

        end