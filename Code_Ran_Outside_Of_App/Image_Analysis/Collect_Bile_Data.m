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

Data1st = [];
headers = strsplit('time,sample,count,Count_EL,cd,sd,d_cv,cv_theta,d_pv,pv_theta,el,edge,cv,pv',',');
Cols1 = [2,3,4,5,6,7,8,9,13,14,15,16];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Bile_Data_Link_First_Order'),'file') ==2
        tic
        time = get_time(Path);
        disp(i)
        disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Bile_Data_Link_First_Order'));
        Data = Data(:,Cols1);
        T = time*ones(size(Data,1),1);
        Samp = i*ones(size(Data,1),1);
        Data1st = [Data1st; [T  Samp Data]];
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Bile_Branch_Labels'),headers,'Link_1st_Order');
csvwrite(fullfile(In_Path,'Bile_Branch_Data'),Data1st);