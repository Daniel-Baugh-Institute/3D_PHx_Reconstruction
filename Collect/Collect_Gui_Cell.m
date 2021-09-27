function Collect_Gui_Cell(Path_List,In_Path)

Data1st = [];
headers_1 = strsplit('time,volume,CV_theta,D_CV,D_PV,MA_L,Eccentricity_M,Eccentricity_E,B_CP,B_CVP,B_PVP,B_SP,B_BP',',');
Cols1 = [3,10,11,12,16,17,18,21,23,25,27,29];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Cell_Stats'),'file') ==2
        time = get_time(Path);
        Data = csvread(fullfile(Path,'Cell_Stats'));
        Data = Data(:,Cols1);
        T = time*ones(size(Data,1),1);
        Data1st = [Data1st; [T  Data]];
    else
        disp([Path ' does not contain the proper files'])
    end
end
xlswrite(fullfile(In_Path,'Cells_Labels'),headers_1,'Cells');
csvwrite(fullfile(In_Path,'Cells'),Data1st);
end

