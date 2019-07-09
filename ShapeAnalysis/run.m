load('/Users/rishi/Documents/GitHub/ImageSequences_LacticAcid.mat');

Masks = ImagingProject.ListWithMovies(51).TrackingResults.Segmentation.TimePoint(17).CellMasksInEntireZVolume;
CurrentMask = Masks(1).ListWithPixels_3D;

s1 = Shape(CurrentMask);
s1 = CreateImage(s1);
%ShowImage(s1)

s1 = CreatePerimeter(s1);
ShowImage(s1);
CreateAxes(s1);

clear; 
clc;


