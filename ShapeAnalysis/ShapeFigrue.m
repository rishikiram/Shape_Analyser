classdef ShapeFigrue
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ShapeList
    end
    
    methods
        function obj = ShapeFigrue(Shape,ShapeList)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.ShapeList = ShapeList;
            obj = AddShape(obj);
        end
        function obj = AddShape(obj,Shape)
            obj.ShapeList = [obj.Shapelist; Shape];
        end
        function CreateWindow(obj)
        
            
        
        end
    end
end

