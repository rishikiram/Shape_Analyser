classdef ShapeFigure
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ShapeList
    end
    
    methods
        function obj = ShapeFigure(Shape,ShapeList)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.ShapeList = ShapeList;
            obj = AddShape(obj,Shape);
        end
        function obj = AddShape(obj,Shape)
            obj.ShapeList = [obj.Shapelist; Shape];
        end
        function CreateWindow(obj)
        
            MainAxesHandle = axes('YDir', 'reverse','XTick',[],'YTick',[] );
            MainAxesHandle.Position = [0,0,1,1];
            CircularityText = num2str(GetCircularity(s1));
            CircularityTextHandle = text(.7,0.9,['Circularity: ',CircularityText],'Units','normalized','Color','r');
            ImageAxisHandle = axes('YDir', 'reverse','XTick',[],'YTick',[] );
            ImageAxisHandle.Position=[0,0,0.65,1];
            imshow(Im);
            line(Rect.xcors,Rect.ycors, 'Color', 'red', 'LineWidth', 2);
        
        end
        
    end
end

