classdef ShapeFigure
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ShapeList
        MainAxesHandle
        MinorAxesHandleList
    end
    
    methods
        function obj = ShapeFigure(ShapeList)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.ShapeList = ShapeList;
        end
        function obj = AddShape(obj,Shape)
            obj.ShapeList = [obj.Shapelist; Shape];
        end
        function obj = CreateWindow(obj)
            
            numrows = floor( sqrt( size( obj.ShapeList, 1)));
            numcols = ceil(size( obj.ShapeList, 1) / numrows );
            axisheight = 1/numrows;
            axislength = 1/numcols;
            AxesHandleList = cell(size( obj.ShapeList, 1),1);
            
            obj.MainAxesHandle = axes('YDir', 'reverse','XTick',[],'YTick',[] );
            obj.MainAxesHandle.Position = [0,0,1,1];
            AxesNum = 1;
            %AxesHandleList(size(obj.ShapeList,1),1) = axes;%dont know how
            %to create list of axes pointers
            for c = 1:1:numrows
                for r=1:1:numcols
                    AxesHandleList(AxesNum, 1) = axes( 'YDir', 'reverse' );%,'XTick',[],'YTick',[]
                    AxesHandleList(AxesNum, 1).Position = [axislength*(r-1),axisheight*(c-1),axislength, axisheight];
                end
            end
            obj.MinorAxesHandleList = AxesHandleList;
        end
        function obj = FillWindow(obj)
        end
    end
end

