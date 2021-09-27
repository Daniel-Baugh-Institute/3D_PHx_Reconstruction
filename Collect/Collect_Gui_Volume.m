function Collect_Gui_Volume(Path_List,In_Path)

DataVol = [];
for i=1:numel(Path_List)
    %Set Path
    Path = Path_List{i};
    if exist(fullfile(Path,'Volume_Data'),'file') ==2
        time = get_time(Path);
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

