classdef MotilityAnalyzer
    %MotilityAnalyzer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Timepoint
        VelocityList
        CentroidList
        MaskList
    end
    
    methods
        function obj = MotilityAnalyzer(Results)
            %MotilityAnalyzer Construct an instance of this class
            %   Detailed explanation goes here
            obj.Timepoint = Results;
            
        end
        function obj = CreateCentroidList(obj)
            for i = 1: size(obj.Timepoint)
                Masks = obj.Timepoint(i).CellMasksInEntireZVolume;
                x = Masks
            end
        end
        function obj = CreateVelocityList(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            for i = 1:size(obj.MaskList,1)
                x1 = TimePoint(i).CentroidX;
                VelocityList(i) = FindDistanceBetween(x1,y1,x2,y2);
            end
        end
        
    end
    methods(Static)
        function dist = FindDistanceBetween(x1,y1,x2,y2)
            dist = sqrt((x1-x2).^2 + (y1-y2).^2);
        end
    end
end

