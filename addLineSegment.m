function out = addLineSegment(app, ax, line, highlight, callback, varargin)

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
        if length(highlight)==1
            highlight={highlight, highlight};

        end
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
                'Markersize',sz,'Deletable', false, varargin{:});
            app.(line) = roi;

            if exist('highlight','var') && ~isempty(highlight)
                addlistener(app.(line), 'MovingROI', highlight{1});
                addlistener(app.(line), 'ROIMoved', highlight{2});
                feval(highlight{2}, roi, event);
            end

            if exist('callback','var') && ~isempty(callback)
                callback(app)
            end

            delete(app.TopDownPts(1))
            app.TopDownPts = [];
        end


    end
out  =  @inner;
end