function Collect_Gui_Sinu(Path_List,In_Path)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Data1st = [];
Data2nd = [];
headers_1 = strsplit('time,el,edge,cv,pv,sd,cd,dcv,cv_theta,dpv,pv_theta',',');
Cols1 = [5,6,7,8,9,10,14,18,19,23];
headers_2 = strsplit('time,el,order2,count,sd,cd,dcv,cv_theta,dpv,pv_theta',',');
Cols2 = [2,3,4,5,6,10,14,15,19];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Sinu_Data_Link_First_Order'),'file') ==2
        tic
        time = get_time(Path);
        disp(i)
        disp([num2str(time) ' - ' Path])
        Data = csvread(fullfile(Path,'Sinu_Data_Link_First_Order'));
        Data = Data(:,Cols1);
        T = time*ones(size(Data,1),1);
        Data1st = [Data1st; [T  Data]];
        %2nd Order
        Data = csvread(fullfile(Path,'Sinu_Data_Link_Second_Order'));
        Data = Data(:,Cols2);
        T = time*ones(size(Data,1),1);
        Data2nd = [Data2nd; [T  Data]];
        toc
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Sinu_Data_Labels'),headers_1,'Link_1st_Order');
xlswrite(fullfile(In_Path,'Sinu_Data_Labels'),headers_2,'Link_2nd_Order');
csvwrite(fullfile(In_Path,'Sinu_1st_Order'),Data1st);
csvwrite(fullfile(In_Path,'Sinu_2nd_Order'),Data2nd);
end

