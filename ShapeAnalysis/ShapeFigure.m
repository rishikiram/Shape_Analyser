classdef ShapeFigure
    %Creates figure and axes to display a list of shapes.
    properties
        ShapeList
        MainAxesHandle
        ImageAxesHandleList
        TextAxesHandleList
        HistogramHandleList
    end
    
    methods
        function obj = ShapeFigure(ShapeList)
            %Sets shape list of obj
            if nargin > 0
                obj.ShapeList = ShapeList;
            end
        end
        function obj = AddShape(Shape ,obj)
            %add shape to list
            rows = size(obj.ShapeList,1); 
            obj.ShapeList{rows+1,1} = Shape;
        end
        function obj = CreateWindow(obj)
            %creates a roughly square figure with axes to be filled with
            %images - figure is square or one row wider than square
            
            numrows = floor( sqrt( size( obj.ShapeList, 1) + 1));%%plus one becasue the last axes will be filled with text 
            numcols = ceil( (size( obj.ShapeList, 1) + 1) / numrows );%%^^^^
            axisheight = 1/numrows;
            axislength = 1/numcols;
            
            AxesList = cell(numrows, numcols);
            TextAxes = cell(numrows, numcols);
            NumberOfTextLines = 3;%<---change number of text lines here
            figure1 = figure('Name', 'Cell Data');
            obj.MainAxesHandle = axes('XTick',[],'YTick',[] );%'YDir', 'reverse',
            obj.MainAxesHandle.Position = [0,0,1,1];
            for c = 1:numcols
                for r=1:numrows
                    %{ 
                    %fills from bottom left to top right
                    AxesList(r, c) = { axes( 'YDir', 'reverse','XTick',[],'YTick',[]) };
                    AxesList{r, c}.Position =  [axislength*(c-1),axisheight*(r-1)+axisheight*0.1,axislength, axisheight*0.9];
                    TextAxes(r,c) = { axes('XTick',[],'YTick',[]) };
                    TextAxes{r, c}.Position =  [axislength*(c-1),axisheight*(r-1),axislength, axisheight*0.1];
                    %}
                    %fills from top left to bottom right
                    AxesList(r, c) = { axes( 'YDir', 'reverse','XTick',[],'YTick',[]) };
                    AxesList{r, c}.Position =  [axislength*(c-1),(1-axisheight*r)+axisheight*NumberOfTextLines/10,axislength, axisheight*(1-NumberOfTextLines/10)];
                    TextAxes(r,c) = { axes('XTick',[],'YTick',[]) };
                    TextAxes{r, c}.Position =  [axislength*(c-1),(1-axisheight*r),axislength, axisheight*NumberOfTextLines/10];
                    
                end
            end
            obj.ImageAxesHandleList = AxesList;
            obj.TextAxesHandleList = TextAxes;
        end
        function FillWindow(obj)
            %fills axes with images and text
            ishape = 1;
            for c=1:size(obj.ImageAxesHandleList,2)
                for r=1:size(obj.ImageAxesHandleList,1)
                    %%show avergare cicularity
                    if ishape > size(obj.ShapeList,1)
                        AC = num2str(ShapeFigure.GetAverageCircularity(obj.ShapeList));
                        text(0.05,0.5,['Average Circularity: ', newline AC],...
                            'Units','normalized',...
                            'Color','k',...
                            'FontUnits','normalized',...
                            'FontSize', 0.1,...
                            'Parent', obj.ImageAxesHandleList{r,c});
                        break;
                    end
                    %%show image
                    image = GetImage(obj.ShapeList{ishape,1});
                    %{
                    if(size(image,1)>size(image,2))
                        rotatedimage = imrotate(image,90);
                    end
                    %}
                    imshow(image, 'Parent', obj.ImageAxesHandleList{r,c} );
                    
                    %%draw rectangle
                    Rectangle = GetRectangle(obj.ShapeList{ishape,1});
                    %{
                    if 1==( exist rotatedimage )
                        line(Rectangle.ycors,Rectangle.xcors, 'Color', 'red', 'LineWidth', 2,'Parent', obj.ImageAxesHandleList{r,c});
                    end
                    %}
                    line(Rectangle.xcors,Rectangle.ycors,...
                        'Color', '#EDB120',...
                        'LineWidth', 2,...
                        'Parent', obj.ImageAxesHandleList{r,c});
                    
                    %%Draw longest line
                    LongestLine = GetLongestLine(obj.ShapeList{ishape,1});
                    line(LongestLine(:,1),LongestLine(:,2),...
                        'Color', '#77AC30',...
                        'LineWidth', 2,...
                        'Parent', obj.ImageAxesHandleList{r,c},...
                        'LineStyle','--');
                    %%display stats
                    
                    Circularity = num2str( GetCircularity(obj.ShapeList{ishape,1}) );
                    ShapeAxes = GetAxesLength(obj.ShapeList{ishape,1}) ;
                    AxesRatio = num2str(ShapeAxes(1)/ShapeAxes(2));
                    ConcavePercentage = num2str(GetPercentAreaConcave(obj.ShapeList{ishape,1}));
                    t = ['Circularity: ' Circularity newline 'Axes Ratio: ' AxesRatio newline 'Concave Area %: ' ConcavePercentage];
                    text(0.05,0.5,t,...
                        'Units','normalized',...
                        'Color','k',...
                        'FontUnits','normalized',...
                        'FontSize', 0.75/3,...
                        'Parent', obj.TextAxesHandleList{r,c});
                    
                    %{
                    Circularity = num2str( GetCircularity(obj.ShapeList{ishape,1}) );
                    RP = GetRPCircularity(obj.ShapeList{ishape,1});
                    RPCirc = num2str(1/RP.Circularity);
                    text(0.05,0.5,['My Circularity: ' Circularity newline 'RP Circ ' RPCirc],'Units','normalized','Color','#A2142F','FontUnits','normalized','FontSize', 0.75/2,'Parent', obj.TextAxesHandleList{r,c});
                    %}
                    
                    ishape = ishape + 1;
                    
                    
                end
            end
        end
        function obj = CreateHistogram(obj, variable)
            VariableList = zeros(size(obj.ShapeList,1),1);
            
            switch variable
                case 'Circularity'
                    for i = 1:size(obj.ShapeList,1)
                        VariableList(i,1) = GetCircularity(obj.ShapeList{i,1});
                    end
                    rows = size(obj.HistogramHandleList,1); 
                    obj.HistogramHandleList{rows+1,1}.figure = figure('Name', [variable ' Histogram'] );
                    obj.HistogramHandleList{rows+1,1}.axes = axes('XTick',[],'YTick',[] );
                    obj.HistogramHandleList{rows+1,1}.hiastogram = histogram(VariableList );
                case 'PercentAreaConcave'
                    for i = 1:size(obj.ShapeList,1)
                        VariableList(i,1) = GetPercentAreaConcave(obj.ShapeList{i,1});
                    end
                    rows = size(obj.HistogramHandleList,1); 
                    obj.HistogramHandleList{rows+1,1}.figure = figure('Name', [variable ' Histogram'] );
                    obj.HistogramHandleList{rows+1,1}.axes = axes('XTick',[],'YTick',[] );
                    obj.HistogramHandleList{rows+1,1}.hiastogram = histogram(VariableList );
                case 'AxesRatio'
                    for i = 1:size(obj.ShapeList,1)
                        ShapeAxes = GetAxesLength(obj.ShapeList{i,1}) ;
                        VariableList(i,1) = ShapeAxes(1)/ShapeAxes(2);
                    end
                    rows = size(obj.HistogramHandleList,1); 
                    obj.HistogramHandleList{rows+1,1}.figure = figure('Name', [variable ' Histogram'] );
                    obj.HistogramHandleList{rows+1,1}.axes = axes('XTick',[],'YTick',[] );
                    obj.HistogramHandleList{rows+1,1}.hiastogram = histogram(VariableList );
                otherwise
                    disp('Invalid variable input for Histogram');
            end
        
        end
        function obj = CreateScatterPlot(shapelist)
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

