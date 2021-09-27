addpath('..')

if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

for i=1:numel(Path_List)
    i
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
        tic
        %% Nuclei Segmentation
        disp('Segmenting Nuclei');
        Seg_Nuc_Prolif(Path);
        
    else
        disp([Path ' does not contain the proper files'])
    end
end