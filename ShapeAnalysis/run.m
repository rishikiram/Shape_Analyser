load('/Users/rishi/GitHub/ImageSequences_LacticAcid.mat');

Masks = ImagingProject.ListWithMovies(51).TrackingResults.Segmentation.TimePoint(17).CellMasksInEntireZVolume;
CurrentMask = Masks(1).ListWithPixels_3D;

s1 = Shape(CurrentMask);
%s1 = CreateImage(s1);
%s1 = CreatePerimeter(s1);
%im = GetImage(s1);
%s1 = CreateAxes(s1);
s1 = AdjustImageToRectangle(s1);
%ShowImage(s1);

s2 = Shape(Masks(2).ListWithPixels_3D);
s2 = AdjustImageToRectangle(s2);
%ShowImage(s2);


%s = regionprops(im,'Centroid', 'MajorAxisLength','MinorAxisLength','Orientation','Circularity');

Im = GetImage(s1);
Rect = GetRectangle(s1);


%ShapesHandle = figure('Name','Shapes','NumberTitle','off');no need?

MainAxesHandle = axes('YDir', 'reverse','XTick',[],'YTick',[] );
MainAxesHandle.Position = [0,0,1,1];
CircularityText = num2str(GetCircularity(s1));
CircularityTextHandle = text(.7,0.9,['Circularity: ',CircularityText],'Units','normalized','Color','r');
ImageAxisHandle = axes('YDir', 'reverse','XTick',[],'YTick',[] );
ImageAxisHandle.Position=[0,0,0.65,1];
imshow(Im);
line(Rect.xcors,Rect.ycors, 'Color', 'red', 'LineWidth', 2);



%{
fig = imshow(Image,'InitialMagnification','fit');
hold on
line(Rect.xcors,Rect.ycors, 'Color', 'red', 'LineWidth', 2);
hold off
truesize( [500, 500]);
%}
