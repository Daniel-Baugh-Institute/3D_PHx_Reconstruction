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
res = [0.54 0.54 0.621];
parfor i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Bile_Skeleton.tif'),'file') ==2
        disp(i)
        disp(Path)
        tic
        Gather_Cell_Stats(Path,res);
        toc
    else
        disp([Path ' does not contain the proper files'])
    end
end