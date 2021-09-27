if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

for i=1:numel(Path_List)
    tic
    %Set Path
    Path = Path_List{i};
    if exist([Path 'Cells.xls'],'file') ==2
        tic
        disp(['segmenting on ' Path])
        Ca_Pre_Sim(Path)
    else
        disp([Path ' does not contain the proper files'])
    end
    toc
end
