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
DataVol = [];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Volume_Data'),'file') ==2
        time = get_time(Path);
        disp(i)
%         disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Volume_Data'));
        T = time*ones(size(Data,1),1);
        DataVol = [DataVol; [T  Data]];
    else
        disp([Path ' does not contain the proper files'])
    end
end
csvwrite(fullfile(In_Path,'Volume'),DataVol);
 labels = strsplit('Time,total_volume,percent CV,percent PV,percent Sinu,percent Bile,percent cell,adjusted percent Sinu,adjusted percent Bile,adjusted percent cell',',');
 xlswrite(fullfile(In_Path,'Volume_Data_Labels'),labels,'Sheet1');