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
Sample = [];
headers = strsplit('time,sample,count,radius,cd,sd,d_cv,cv_theta,d_pv,pv_theta,el,edge,cv,pv',',');
Cols1 = [2,3,4,5,6,7,8,9,13,14,15,16];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Sinu_Branch_Data'),'file') ==2
        tic
        time = get_time(Path);
        disp(i)
        disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Sinu_Branch_Data'));
        Data = Data(:,Cols1);
        T = time*ones(size(Data,1),1);
        S = i*ones(size(Data,1),1);
        Data1st = [Data1st; [T  S Data]];
        toc
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Sinu_Branch_Labels'),headers);
csvwrite(fullfile(In_Path,'Sinu_Branch_Data'),Data1st);