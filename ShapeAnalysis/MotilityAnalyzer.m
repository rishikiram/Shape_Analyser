classdef MotilityAnalyzer
    %MotilityAnalyzer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        VelocityList
        CentroidList
        MaskList
        ShapeList
        Figure
    end
    
    methods
        function obj = MotilityAnalyzer(Masks, Centroids)
            %MotilityAnalyzer Construct an instance of this class
            %   Detailed explanation goes here
            obj.MaskList = Masks;
            obj.CentroidList =Centroids;
            obj.Figure = ShapeFigure();
            
        end
        function obj = CreateVelocityList(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.VelocityList = zeros( size(obj.MaskList,1)-1, 1);
            for i = 1: size(obj.MaskList,1)-1
               obj.VelocityList(i) = MotilityAnalyzer.FindDistanceBetween( obj.CentroidList(i,:),obj.CentroidList(i+1,:) );
            end
        end
        function obj = CreateShapeList(obj)
            obj.ShapeList = cell(size(obj.MaskList,1),1);
            for i=1:size(obj.MaskList,1)
                obj.ShapeList(i,1) ={ Shape(obj.MaskList{i,1}) };
                %obj.ShapeList{i,1} = AdjustImageToRectangle(obj.ShapeList{i,1});
            end
        end
        
        function obj =  DisplayMasks(obj)
            
            obj.Figure = CreateWindow(obj.Figure, obj.ShapeList);
            FillWindow(obj.Figure, obj.ShapeList);
            
        end
        function obj = PlotVelocityVs(obj, variable, PreserveVelocityOrShape)
            if nargin > 2 && isequal(PreserveVelocityOrShape , 'Shape')
                
                AdjustedVelocityList = obj.VelocityList;
                InitialValue = obj.VelocityList(1,1);
                for i = 1:size(AdjustedVelocityList, 1)-1
                    AdjustedVelocityList(i,1) = (AdjustedVelocityList(i,1)+AdjustedVelocityList(i+1,1))/2;
                end
                
                AdjustedVelocityList = [InitialValue ;AdjustedVelocityList];  
                yVariable = ShapeFigure.CreateVariableList(obj.ShapeList, variable);
                obj.Figure = CreateScatterPlot(obj.Figure, AdjustedVelocityList, yVariable);
            else 
               yVariable = ShapeFigure.CreateVariableList(obj.ShapeList, variable);
               AdjustedVariableList = zeros(size(obj.VelocityList,1),1);
               for i=1:size(obj.VelocityList,1)
                   AdjustedVariableList(i,1) = (yVariable(i,1)+yVariable(i+1,1))/2;
               end
               obj.Figure = CreateScatterPlot(obj.Figure, obj.VelocityList, AdjustedVariableList);
            end
        end
        
        
    end
    methods(Static)
        function dist = FindDistanceBetween(cor1,cor2)
            dist = sqrt( (cor1(1)-cor2(1)).^2 + (cor1(2)-cor2(2)).^2 + (cor1(3)-cor2(3)).^2);
        end
    end
end

