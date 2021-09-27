addpath('..\Image_Analysis')
addpath('..\Support_Code')
addpath(genpath('..\Support_Code'))

if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

DataNuc = [];

headers_1 = strsplit('time,sample,volume,C2_Mean,C2_Median,C2_G_Mean,C2_G_Median',',');
Cols1 = [2,12,13,14,15];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Nuclei_Stats'),'file') ==2
%         tic
        time = get_time(Path);
%         disp(i)
%         disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Nuclei_Stats'));
        Data = Data(:,Cols1);
        T = time*ones(size(Data,1),1);
        Sam = i*ones(size(Data,1),1);
        DataNuc = [DataNuc; [T Sam Data]];
%         toc
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Nuclei_Labels'),headers_1);
csvwrite(fullfile(In_Path,'Nuclei'),DataNuc);