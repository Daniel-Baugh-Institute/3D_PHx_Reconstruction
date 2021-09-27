if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

for i=1:numel(Path_List)
    tic
    i
    %Set Path
    Path = Path_List{i};
    if exist([Path 'CV_Mask.tif'],'file') ==2
        disp(['Composite on ' Path])
        Create_Composite(Path);
    else
        disp([Path ' does not contain the proper files'])
    end
    toc
end