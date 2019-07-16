classdef ShapeFigure
    %Creates figure and axes to display a list of shapes.
    properties
        ShapeList
        MainAxes
        ImageAxesList
        TextAxesList
    end
    
    methods
        function obj = ShapeFigure(ShapeList)
            %Sets shape list of obj
            obj.ShapeList = ShapeList;
        end
        function obj = AddShape(obj,Shape)
            %add shape to list
            obj.ShapeList = [obj.Shapelist; Shape];
        end
        function obj = CreateWindow(obj)
            %creates a roughly square figure with axes to be filled with
            %images - figure is square or one row wider than square
            
            numrows = floor( sqrt( size( obj.ShapeList, 1) + 1));
            numcols = ceil( (size( obj.ShapeList, 1) + 1) / numrows );
            axisheight = 1/numrows;
            axislength = 1/numcols;
            
            AxesList = cell(numrows, numcols);
            TextAxes = cell(numrows, numcols);
            obj.MainAxes = axes('YDir', 'reverse','XTick',[],'YTick',[] );
            obj.MainAxes.Position = [0,0,1,1];
            for c = 1:numcols
                for r=1:numrows
                    AxesList(r, c) = { axes( 'YDir', 'reverse','XTick',[],'YTick',[]) };
                    AxesList{r, c}.Position =  [axislength*(c-1),axisheight*(r-1)+axisheight*0.1,axislength, axisheight*0.9];
                    TextAxes(r,c) = { axes('XTick',[],'YTick',[]) };
                    TextAxes{r, c}.Position =  [axislength*(c-1),axisheight*(r-1),axislength, axisheight*0.1];
                end
            end
            obj.ImageAxesList = AxesList;
            obj.TextAxesList = TextAxes;
        end
        function FillWindow(obj)
            %fills axes with images and text
            ishape = 1;
            for c=1:size(obj.ImageAxesList,2)
                for r=1:size(obj.ImageAxesList,1)
                    
                    image = GetImage(obj.ShapeList{ishape,1});
                    if(size(image,1)>size(image,2))
                        %flip array
                        new = zeros( size(image,2),size(image,1) );
                        
                    end
                    imshow(image, 'Parent', obj.ImageAxesList{r,c} );
                    Rectangle = GetRectangle(obj.ShapeList{ishape,1});
                    line(Rectangle.xcors,Rectangle.ycors, 'Color', 'red', 'LineWidth', 2,'Parent', obj.ImageAxesList{r,c});
                    ishape = ishape + 1;
                    if ishape > size(obj.ShapeList,1)
                        AC = num2str(ShapeFigure.GetAverageCircularity(obj.ShapeList));
                        text(0.05,0.6,['Average Circularity: ' newline ,AC],'Units','normalized','Color','r','FontUnits','normalized','FontSize', 0.1);
                        break;
                    end
                end
            end
        end
        
    end
    methods(Static)
        function AverageCirculary = GetAverageCircularity(shapelist)
            %return number calculated from given list
            totalCircularity = 0;
            numCircularity = 0;
            
            for i = 1:size(shapelist,1)
                totalCircularity = totalCircularity+GetCircularity(shapelist{i,1});
                numCircularity = numCircularity+1;
            end
            AverageCirculary = totalCircularity/numCircularity;
        end
    end
end

