classdef Shape
    %Shape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ShapePixels
        Image
    end
    
    methods
        
        function obj = Shape(PixelListOfMask)
            %Shape Construct an instance of this class
            %   Needs input of an array of n rows and 2 or more columns,
            %   in [x,y,z] format
            obj.ShapePixels = PixelListOfMask;
            %obj.Image = [];
            
        end
        function outputImage = GetImage(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isempty(obj.Image)
                obj = CreateImage(obj);
            end
            
            outputImage = obj.Image;
            
        end
        function ShowImage(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if isempty(obj.Image)
               obj = CreateImage(obj);
            end
            
            imshow(obj.Image,'InitialMagnification','fit');
            truesize( [500, 500]);
            
        end
        function obj = CreateImage(obj)
            xRange = max( obj.ShapePixels(:,1) ) - min( obj.ShapePixels(:,1) ) + 1;
            yRange = max( obj.ShapePixels(:,2) ) - min( obj.ShapePixels(:,2) ) + 1;
            obj.Image = zeros( yRange, xRange);
            
            for r=1:1:size(obj.ShapePixels)
                cor = [ (obj.ShapePixels(r,1)- min(obj.ShapePixels(:,1)) +1) , (obj.ShapePixels(r,2)- min( obj.ShapePixels(:,2))+1) ];
                obj.Image(cor(2), cor(1)) = 200;
            end
        
        end
        function obj = CreatePerimeter(obj)
            
            obj.Image = bwperim(obj.Image);
            
        end
        function obj = CreateAxes(obj)
            %% second method
            p = find(obj.Image);
            PerimPoints = zeros(size(p,1),2);
            for row=1:1:size(p(:,1), 1)
                rownum = size(obj.Image(:,1));
                PerimPoints(row,1) = mod(p(row,1),rownum(1));
                if PerimPoints(row,1) == 0
                    PerimPoints(row,1) = 19;
                end
                PerimPoints(row,2) = ( ceil( p(row,1)/rownum(1) ) );
            end
            %op = [ mod(p,obj.Image(:,1)), (ceil(p/obj.Image(:,1))) ];
            
            %Axis = [dist, x1,y1,x2,y2 ];
            %Axis.dist = 0;
        end
        
        
        
    end
end

