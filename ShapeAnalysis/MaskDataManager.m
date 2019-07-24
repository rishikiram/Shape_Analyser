classdef MaskDataManager
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MovieLibrary
        Movie = 46;
        Frame = 1;
    end
    
    methods
        function obj = MaskDataManager(PMMovieLibrary)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.MovieLibrary = PMMovieLibrary;
        end
        
        function obj = SetMovie(mov)
            obj.Movie = mov;
        end
        function obj = SetFrame(fr)
            obj.Frame = fr;
        end
        function obj = SetMovieLibrary(lib)
            obj.MovieLibrary = lib;
        end
        
        function [MaskList,CentroidList] = GetMaskDataOfFrame(obj)
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            MaskDataAtFrame = obj.MovieLibrary.ListhWithMovieObjects{obj.Movie,1}.Tracking.TrackingCellForTime{obj.Frame,1};
            MaskList = MaskDataAtFrame(:,6);
            yList = cell2mat(MaskDataAtFrame(:,3));
            xList = cell2mat(MaskDataAtFrame(:,4));
            zList = cell2mat(MaskDataAtFrame(:,5));
            CentroidList = [xList,yList,zList];
        end
        function [MaskList,CentroidList] = GetMaskDataOfCellOverMovie(obj, CellID)
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            testrow = MaskDataManager.GetRowOfCell(CellID, obj.Frame, obj.Movie, obj.MovieLibrary);
             if isempty(testrow)
                 MaskList = [];
                 CentroidList = [];
                 return
             end
            ListOfFrames = obj.MovieLibrary.ListhWithMovieObjects{obj.Movie,1}.Tracking.TrackingCellForTime;
            
            CentroidList = zeros(size(ListOfFrames,1),3);
            MaskList = cell(size(ListOfFrames,1), 1);
            for i = 1:size(ListOfFrames,1)
                row = MaskDataManager.GetRowOfCell(CellID, obj.Frame, obj.Movie, obj.MovieLibrary);
                MaskList{i,1} = ListOfFrames{i,1}{row,6};
                
                CentroidList(i,1) = cell2mat(ListOfFrames{i,1}(row,4));%xcor
                CentroidList(i,2) = cell2mat(ListOfFrames{i,1}(row,3));%ycor
                CentroidList(i,3) = cell2mat(ListOfFrames{i,1}(row,5));%zcor
            end
        end
    end
    methods(Static)
        function row = GetRowOfCell(ID, Frame, Movie, PMMovieLibrary)
            MaskDataAtFrame = PMMovieLibrary.ListhWithMovieObjects{Movie,1}.Tracking.TrackingCellForTime{Frame,1};
            ar = cell2mat(MaskDataAtFrame(:,1));
            row = find((ar == ID));
            
        end
        
    
    end
end

