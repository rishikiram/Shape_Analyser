classdef Shape
    %Shape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ShapePixels
        Image
        MajorAxis = [0,0,0,0];%[x1,y1,x2,y2], coordinates of farthest points on primeter
        Area
        Perimeter
        
    end
    
    methods
        
        function obj = Shape(PixelListOfMask)
            %Shape Construct an instance of this class
            %   Needs input of an array of n rows and 2 or more columns,
            %   in [x,y,z] format
            obj.ShapePixels = PixelListOfMask;
            obj.Area = size(PixelListOfMask,1);
            obj.Perimeter = [];
            
            
        end
        function outputImage = GetImage(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            xRange = max( obj.ShapePixels(:,1) ) - min( obj.ShapePixels(:,1) ) + 1;
            yRange = max( obj.ShapePixels(:,2) ) - min( obj.ShapePixels(:,2) ) + 1;
            outputImage = zeros( yRange, xRange);
            
            for r=1:1:size(obj.ShapePixels)
                cor = [ (obj.ShapePixels(r,1)- min(obj.ShapePixels(:,1)) +1) , (obj.ShapePixels(r,2)- min( obj.ShapePixels(:,2))+1) ];
                outputImage(cor(2), cor(1)) = 1;
            end
            
        end
        function MajorAxisToPerimeterRatio = GetMajorAxisToPerimeterRatio(obj)
            %return number from 1 to 1.571, 1 being a circle and 1.571
            %being a line
            %the number could also be less than 1, and this would mean is
            %is a really weird shape because the major axis in the longest
            %line
            if obj.MajorAxis == zeros(1,4)
                obj = CreateAxes(obj);
            end
            if isempty(obj.Perimeter)
                obj = CreatePerimeter(obj);
            end
            MajorAxisLength = sqrt( power((obj.MajorAxis(1)-obj.MajorAxis(3)),2) + power((obj.MajorAxis(2)-obj.MajorAxis(4)),2) );
            MajorAxisToPerimeterRatio = MajorAxisLength/obj.Perimeter * pi;
        
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
                obj.Image(cor(2), cor(1)) = 1;
            end
        
        end
        function obj = CreatePerimeter(obj)
            
            obj.Image = bwperim(obj.Image);
            p = find(obj.Image);
            obj.Perimeter = size(p,1);
            
        end
        function obj = CreateAxes(obj)
            %% second method
            p = find(obj.Image);
            PerimPoints = zeros(size(p,1),3);%[row,col,(has been compared to all other pixels)truefalse]
            for row=1:1:size(p(:,1), 1)
                numofrows = size(obj.Image(:,1),1);
                PerimPoints(row,1) = mod(p(row,1),numofrows);
                if PerimPoints(row,1) == 0 
                    PerimPoints(row,1) = 19; 
                end
                PerimPoints(row,2) = ( ceil( p(row,1)/numofrows ) );
            end
            maxdist = 0;
            for pixel1 = 1:1: size(PerimPoints, 1)
                for pixel2 = 1:1: size(PerimPoints, 1)
                    if pixel1~=pixel2 && PerimPoints(pixel1,3) ~= 1 && PerimPoints(pixel1,3) ~= 1
                        
                        ydist = PerimPoints(pixel1,1) - PerimPoints(pixel2,1);
                        xdist = PerimPoints(pixel1,2) - PerimPoints(pixel2,2);
                        if sqrt((ydist*ydist)+(xdist*xdist)) > maxdist 
                            maxdist = sqrt((ydist*ydist)+(xdist*xdist));
                            obj.MajorAxis(1)=PerimPoints(pixel1,2);
                            obj.MajorAxis(2)=PerimPoints(pixel1,1);
                            obj.MajorAxis(3)=PerimPoints(pixel2,2);
                            obj.MajorAxis(4)=PerimPoints(pixel2,1);
                        end
                    end
                end
                PerimPoints(pixel1,3) = 1; 
            end
            
        end
        
        
        
        
    end
end

