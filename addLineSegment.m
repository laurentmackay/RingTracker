function out = addLineSegment(app, ax, line, highlight, callback)

    function out = PtDragging(app, sz, callback)
        function inner(pt, evt)
            pt.MarkerSize=sz;

            if nargin>2
                callback(pt, evt)
            end

        end
        out=@inner;
    end
    width=0.5;
    if nargin>3 && ~isempty(highlight)
        highlight_with_line = highlight(app, {'LineWidth',width }, {'LineStyle','--'} );
        highlight_no_line = highlight(app, {'LineWidth',width/4}, {'LineStyle','-'} );
    end
    
    function inner(app, event)
        color = 'y';
        sz = 4;

        if isempty(app.TopDownPts) && isempty(app.(line))

            %
            %                 roi = drawellipse(app.TopDownAxes,'Center',event.IntersectionPoint(1:2), ...
            %                     'InteractionsAllowed', 'translate','Color','y','LineWidth',1,...
            %                     'Markersize',0.0001, 'FixedAspectRatio',1, 'SemiAxes', [sz(2), sz(1)]*0.05);

            roi = drawpoint(app.(ax),'Position',event.IntersectionPoint(1:2), ...
                'Color',color,...
                'Markersize',sz,'Deletable', false);

            addlistener(roi,'MovingROI', PtDragging(app, 1));
            addlistener(roi,'ROIMoved', PtDragging(app, sz));
            app.TopDownPts = [app.TopDownPts roi];


        elseif length(app.TopDownPts)==1
             roi = drawline(app.(ax),'Position',[get(app.TopDownPts(1),'Position'); event.IntersectionPoint(1:2)], ...
                'Color',color,'LineWidth', width,...
                'Markersize',sz,'Deletable', false);
            app.(line) = roi;

            if exist('highlight_no_line','var')
                addlistener(app.SpindleLine, 'MovingROI', highlight_no_line);
                addlistener(app.SpindleLine, 'ROIMoved', highlight_with_line);
                highlight_with_line(roi, event)
            end

            if exist('callback','var')
                callback(app)
            end

            delete(app.TopDownPts(1))
            app.TopDownPts = [];
        end


    end
out  =  @inner;
end