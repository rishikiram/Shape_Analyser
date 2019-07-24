classdef MotilityAnalyzer
    %MotilityAnalyzer Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        VelocityList
        CentroidList
        MaskList
    end
    
    methods
        function obj = MotilityAnalyzer(Masks, Centroids)
            %MotilityAnalyzer Construct an instance of this class
            %   Detailed explanation goes here
            obj.MaskList = Masks;
            obj.CentroidList =Centroids;
            
        end
        function obj = CreateVelocityList(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.VelocityList = zeros( size(obj.MaskList,1)-1, 1);
            for i = 1: size(obj.MaskList,1)-1
               obj.VelocityList(i) = MotilityAnalyzer.FindDistanceBetween( obj.CentroidList(i,:),obj.CentroidList(i+1,:) );
            end
        end
        function obj =  DisplayMasks(obj)
            
        end
        function obj = CreatePlot(obj)

        end
    end
    methods(Static)
        function dist = FindDistanceBetween(cor1,cor2)
            dist = sqrt( (cor1(1)-cor2(1)).^2 + (cor1(2)-cor2(2)).^2 + (cor1(3)-cor2(3)).^2);
        end
    end
end

