load('/Users/rishi/GitHub/ImageSequences_LacticAcid.mat');

Masks = ImagingProject.ListWithMovies(51).TrackingResults.Segmentation.TimePoint(17).CellMasksInEntireZVolume;
CurrentMask = Masks(1).ListWithPixels_3D;

s1 = Shape(CurrentMask);
%s1 = CreateImage(s1);
%s1 = CreatePerimeter(s1);
%im = GetImage(s1);
%s1 = CreateAxes(s1);
s1 = AdjustImageToRectangle(s1);
ShowImage(s1);

%s = regionprops(im,'Centroid', 'MajorAxisLength','MinorAxisLength','Orientation','Circularity');
%{
rect = GetRectangle(s1);
ShowImage(s1);
hold on
for i = 1:1:4
line([rect.xcors(i),rect.xcors(i+1)],[rect.ycors(i),rect.ycors(i+1)]);
end
hold off
%}            


