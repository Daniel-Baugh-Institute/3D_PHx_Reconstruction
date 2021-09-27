if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

addpath('..\Image_Analysis')
addpath('..\Support_Code')
addpath(genpath('..\Support_Code'))
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
        tic
        
        %% Architecture Segmentation
        disp(['segmenting on ' Path])
        Seg_Arch(Path);

        %% Nuclei Segmentation
        disp('Segmenting Nuclei');
        Seg_Nuclei(Path);
        
        %% Cell Segmentation
        disp('Segmenting Cells');
        Seg_Cells(Path);
        Seg_Sort_Hepa_Cells(Path)
        disp([Path ' segmented and saved'])
        
        toc
    else
        disp([Path ' does not contain the proper files'])
    end
end