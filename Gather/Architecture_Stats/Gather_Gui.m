%% Justin Melunis, PhD
% Thomas Jefferson University

function Gather_Gui(v,Path_List,End_Folders)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N = numel(Path_List);
multiWaitbar( 'CloseAll' );
if N > 1
    multiWaitbar( 'All Data Sets',0);
end

for i=1:N
    %Set Path
    Path = Path_List{i};
    EF = End_Folders{i};
    EFP = EF;
    multiWaitbar(EF,0);
    pause(2)
    if v == 1
        if exist(fullfile(Path,'Sinusoids.tif'),'file') ==2 && exist(fullfile(Path,'Bile.tif'),'file') ==2

            EF = ['Gather_Sinu_Stats_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Gather_Sinu_Stats(Path);
            multiWaitbar(EF,'Increment',0.25);

            EF2 = ['Gather_Bile_Stats_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Gather_Bile_Stats(Path);
            multiWaitbar(EF,'Increment',0.25);

            EF2 = ['Gather_Cell_Stats_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Gather_Cell_Stats(Path);
            multiWaitbar(EF,'Increment',0.45);

            EF2 = ['Gather_Volume_Stats_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Gather_Volume_Stats(Path);
            multiWaitbar(EF,'Increment',0.05);
        else
            disp([Path ' does not contain the proper files'])
        end 
    elseif v == 2 %% Architecture Only Segmentation
        if exist(fullfile(Path,'Sinusoids.tif'),'file') ==2
            EF = ['Gather_Sinu_Stats_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Gather_Sinu_Stats(Path);
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') ==2
            EF = ['Gather_Bile_Stats_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Gather_Bile_Stats(Path);
        end
    elseif v == 4 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') ==2
            EF = ['Gather_Cell_Stats_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Gather_Cell_Stats(Path);
        end
    elseif v == 5 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') ==2
            EF = ['Gather_Volume_Stats_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Gather_Cells_Stats(Path);
        end    
    else
        EF = ['Test_1_' EFP];
        multiWaitbar(EFP,'Relabel',EF);
        pause(rand*10);
        multiWaitbar(EF,'Increment',0.2);
        EF2 = ['Test_2_' EFP];
        multiWaitbar(EF,'Relabel',EF2);
        EF = EF2;
        pause(rand*10);
        multiWaitbar(EF,'Increment',0.2);
        EF2 = ['Test_3_' EFP];
        multiWaitbar(EF,'Relabel',EF2);
        EF = EF2;
        pause(rand*10);
        multiWaitbar(EF,'Increment',0.2);
        EF2 = ['Test_4_' EFP];
        multiWaitbar(EF,'Relabel',EF2);
        EF = EF2;
        pause(rand*10);
        multiWaitbar(EF,'Increment',0.2);
        EF2 = ['Test_5_' EFP];
        multiWaitbar(EF,'Relabel',EF2);
        EF = EF2;
        pause(rand*10);
        multiWaitbar(EF,'Increment',0.2);
    end
    multiWaitbar(EF,'Close');
    multiWaitbar('All Data Sets','Increment',1/N);
end
multiWaitbar( 'CloseAll' );
end


