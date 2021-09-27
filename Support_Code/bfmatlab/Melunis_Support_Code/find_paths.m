%% Justin Melunis, PhD
% Thomas Jefferson University

function [Path_List,end_folders] = find_paths(In_Path)
%Finds the deepest subfolder paths and folder names for all subfolders
%within the In_Path. 
if strcmp(In_Path(end),'\')==0
    In_Path(end+1) = '\';
end

Path_List =[];
DIR = dir(In_Path);
idx = [DIR.isdir];
end_folders=[];
if any(idx(3:end)) %if this isnt the deepest folder, search deeper
    for i=3:numel(idx)
        if idx(i)==1
            %iteratively goes deeper and deeper and brings the deepest
            %folders out and collect's their deepest folder lists
            [In_List,e_f] = find_paths([In_Path DIR(i).name '\']);
            Path_List = [Path_List In_List];
            end_folders = [end_folders e_f];
        else

        end
    end
else %if this is the deepest folder
    %then pass this folder's info up a level
    Path_List = {In_Path};
    a = strsplit(In_Path,'\');
    end_folders = a(end-1);
end

