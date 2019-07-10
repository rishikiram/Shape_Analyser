classdef Shape
    %Rishi Tikare Yang: Judy Cannons Lab, with Paulus Mrass 
    %Shape Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MaskPixelList%input of from tracking results list of cell mask [x,y,z] 
        Image 
        ImagePerimeter%binary image of perimeter of cell mask
        LongestLine%[x1,y1,x2,y2], coordinates of farthest points on perimeter
        Area%of cell mask
        Rectangle%[xcors, ycors, area, perimeter]
        Axes%[major length, minor length], taken from sides of the rectangle
    end
    
    methods
        
        function obj = Shape(PixelListOfMask)
            %Shape Construct an instance of this class
            %   Needs input of an array of n rows and 2 or more columns,
            %   in [x,y,z] format
            obj.MaskPixelList = PixelListOfMask;
            obj.Area = size(PixelListOfMask,1);
            LongestLine = [0,0,0,0];%[x1,y1,x2,y2], coordinates of farthest points on perimeter
            
        end
        function outputImage = GetImage(obj)
            %returns created image from mask pixel list
            xRange = max( obj.MaskPixelList(:,1) ) - min( obj.MaskPixelList(:,1) ) + 1;
            yRange = max( obj.MaskPixelList(:,2) ) - min( obj.MaskPixelList(:,2) ) + 1;
            outputImage = zeros( yRange, xRange);
            
            for r=1:1:size(obj.MaskPixelList)
                cor = [ (obj.MaskPixelList(r,1)- min(obj.MaskPixelList(:,1)) +1) , (obj.MaskPixelList(r,2)- min( obj.MaskPixelList(:,2))+1) ];
                outputImage(cor(2), cor(1)) = 1;
            end
            
        end
        function outputRectangle = GetRectangle(obj)
            %returns rectangle structure
            outputRectangle = obj.Rectangle;
            
        end
        function outputLongestLine = GetLongestLine(obj)
            %returns longestline [x1,y1,x2,y2]
            outputLongestLine = obj.LongestLine;
            
        end
        function LongestLineToPerimeterRatio = GetLongestLineToPerimeterRatio(obj)
            %return number from 1 to 1.571, 1 being a circle and 1.571
            %being a line
            %the number could also be less than 1, and this would mean is
            %is a really weird shape because the major axis in the longest
            %line
            if obj.LongestLine == zeros(1,4)
                obj = CreateAxes(obj);
            end
            if isempty(obj.ImagePerimeter)
                obj = CreatePerimeter(obj);
            end
            ImagePerimeterList = find(obj.ImagePerimeter);
            ImagePerimeterLength = size(ImagePerimeterList(:,1));
            LongestLineLength = sqrt( power((obj.LongestLine(1)-obj.LongestLine(3)),2) + power((obj.LongestLine(2)-obj.LongestLine(4)),2) );
            LongestLineToPerimeterRatio = LongestLineLength/ImagePerimeterLength * pi;
        
        end
        function ShowImage(obj)
            %shows image and rectangle
            if isempty(obj.Image)
               obj = CreateImage(obj);
            end
            
            imshow(obj.Image,'InitialMagnification','fit');
            
            if ~isempty(obj.Rectangle)
            hold on
            %for i = 1:1:4
                %line([obj.Rectangle.xcors(i),obj.Rectangle.xcors(i+1)],[obj.Rectangle.ycors(i),obj.Rectangle.ycors(i+1)]);
                line(obj.Rectangle.xcors,obj.Rectangle.ycors, 'Color', 'red', 'LineWidth', 2);
            %end
            hold off
            end
            truesize( [500, 500]);
            
        end
        function obj = CreateImage(obj)
            %creates image from mask pixel list
            xRange = max( obj.MaskPixelList(:,1) ) - min( obj.MaskPixelList(:,1) ) + 1;
            yRange = max( obj.MaskPixelList(:,2) ) - min( obj.MaskPixelList(:,2) ) + 1;
            obj.Image = zeros( yRange, xRange);
            
            for r=1:1:size(obj.MaskPixelList)
                cor = [ (obj.MaskPixelList(r,1)- min(obj.MaskPixelList(:,1)) +1) , (obj.MaskPixelList(r,2)- min( obj.MaskPixelList(:,2))+1) ];
                obj.Image(cor(2), cor(1)) = 1;
            end
        
        end
        function obj = AdjustImageToRectangle(obj)
            %rescales image to show entire rectangle and image
            if isempty(obj.Rectangle)
                obj = CreateAxes(obj);
            end
            
            rc = [obj.Rectangle.ycors,obj.Rectangle.xcors];
            impix = Shape.GetPixelList(obj.Image);
            pixlist = [rc; impix];
            
            xRange = ceil( max( pixlist(:,2) ) - min( pixlist(:,2)) + 1 );
            yRange = ceil(max( pixlist(:,1) ) - min( pixlist(:,1)) + 1);
            obj.Image = zeros( yRange, xRange);
            
            minx = floor( min(pixlist(:,2)) );
            miny = floor( min(pixlist(:,1)) ); 
            for r=1:1:size(impix)
                cor = [ (impix(r,1)- miny +1) , (impix(r,2)- minx+1) ];
                obj.Image(cor(1), cor(2)) = 1;
            end
            for r=1:1:size(rc)
                cor = [ (rc(r,1)- miny +1) , (rc(r,2)- minx+1) ];
                obj.Rectangle.xcors(r)=cor(2);
                obj.Rectangle.ycors(r)=cor(1);
            end
        
        end
        function obj = CreatePerimeter(obj)
            %creates perimeter, binary image
            if isempty(obj.Image)
                obj = CreateImage(obj);
            end
            obj.ImagePerimeter = bwperim(obj.Image);
            
        end
        function obj = CreateAxes(obj)
            %% Creates a circumscribed rectangle of the smallest area and finds the longest line between points on perimeter of cell
            if isempty(obj.ImagePerimeter)
                obj = CreatePerimeter(obj);
            end
            
            PerimPoints = Shape.GetPixelList(obj.ImagePerimeter);
            PerimPoints(:,3) = zeros(size(PerimPoints(:,1),1),1);
            maxdist = 0;
            for pixel1 = 1:1: size(PerimPoints, 1)
                for pixel2 = 1:1: size(PerimPoints, 1)
                    if pixel1~=pixel2 && PerimPoints(pixel1,3) ~= 1 && PerimPoints(pixel1,3) ~= 1
                        
                        ydist = PerimPoints(pixel1,1) - PerimPoints(pixel2,1);
                        xdist = PerimPoints(pixel1,2) - PerimPoints(pixel2,2);
                        if sqrt((ydist*ydist)+(xdist*xdist)) > maxdist 
                            maxdist = sqrt((ydist*ydist)+(xdist*xdist));
                            obj.LongestLine(1)=PerimPoints(pixel1,2);
                            obj.LongestLine(2)=PerimPoints(pixel1,1);
                            obj.LongestLine(3)=PerimPoints(pixel2,2);
                            obj.LongestLine(4)=PerimPoints(pixel2,1);
                        end
                    end
                end
                PerimPoints(pixel1,3) = 1; 
            end
            [xlist, ylist, a, p]= minboundrect(PerimPoints(:,2),PerimPoints(:,1));
            obj.Rectangle.xcors = xlist;
            obj.Rectangle.ycors = ylist;
            obj.Rectangle.area = a;
            obj.Rectangle.perimeter = p;
            l1 = sqrt( ((xlist(1) - xlist(2)).^2) + ((ylist(1) - ylist(2)).^2) );
            l2 = sqrt( ((xlist(2) - xlist(3)).^2) + ((ylist(2) - ylist(3)).^2) );
            obj.Axes = [max(l1,l2), min(l1,l2)];

        end
        
        
        
        
    end
    methods(Static)
        function Pixels = GetPixelList(Image)
            %take an image and retuns list of [y,x] or [row,column]
            %coordinates that are true or not zero
            p = find(Image);
            Pixels = zeros(size(p,1),2);%[row,col]
            for row=1:1:size(p(:,1), 1)
                numofrows = size(Image(:,1),1);
                Pixels(row,1) = mod(p(row,1),numofrows);
                if Pixels(row,1) == 0 
                    Pixels(row,1) = numofrows; 
                end
                Pixels(row,2) = ( ceil( p(row,1)/numofrows ) );
            end
        end
        
        
        
    end
end

