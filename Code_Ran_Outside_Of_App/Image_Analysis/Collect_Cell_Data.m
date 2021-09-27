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

res = [0.621 0.621 0.54];
Data1st = [];
headers_1 = strsplit('time,sample,volume,CV_theta,D_CV,D_PV,MA_L,Eccentricity_M,Eccentricity_E,B_CP,B_CVP,B_PVP,B_SP,B_BP',',');
Cols1 = [3,10,11,12,16,17,18,21,23,25,27,29];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Cell_Stats'),'file') ==2
%         tic
        time = get_time(Path);
%         disp(i)
%         disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Cell_Stats'));
        Data = Data(:,Cols1);
        Samp = i*ones(size(Data,1),1);
        T = time*ones(size(Data,1),1);
        Data1st = [Data1st; [T Samp Data]];
%         toc
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Cells_Labels'),headers_1);
csvwrite(fullfile(In_Path,'Cells'),Data1st);