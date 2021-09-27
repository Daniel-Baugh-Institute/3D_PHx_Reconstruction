%% Justin Melunis, PhD
% Thomas Jefferson University

function Gather_Gui_P(N_Core,v,Path_List,End_Folders)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Create parallel pool
delete(gcp('nocreate'))
parpool(N_Core)
D = parallel.pool.DataQueue;
%Set up to allow for multiWaitBar to be updated
afterEach(D, @UpdateWaitbar);

N = numel(Path_List);
multiWaitbar( 'CloseAll' );
if N > 1
    multiWaitbar( 'All Data Sets',0);
end

parfor i=1:N
    %Set Path
    Path = Path_List{i};
    EF = End_Folders{i};
    EFP = EF;
    send(D, {EF,0});
    pause(2)
    if v == 1
        if exist(fullfile(Path,'Sinusoids.tif'),'file') ==2 && exist(fullfile(Path,'Bile.tif'),'file') ==2

            EF = ['Gather_Sinu_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            Gather_Sinu_Stats(Path);
            send(D,{EF,'Increment',0.25});

            EF2 = ['Gather_Bile_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            EF = EF2;
            Gather_Bile_Stats(Path);
            send(D,{EF,'Increment',0.25});

            EF2 = ['Gather_Cell_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            EF = EF2;
            Gather_Cell_Stats(Path);
            send(D,{EF,'Increment',0.45});

            EF2 = ['Gather_Volume_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            EF = EF2;
            Gather_Volume_Stats(Path);
            send(D,{EF,'Increment',0.05});
        else
            disp([Path ' does not contain the proper files'])
        end 
    elseif v == 2 %% Architecture Only Segmentation
        if exist(fullfile(Path,'Sinusoids.tif'),'file') ==2
            EF = ['Gather_Sinu_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            Gather_Sinu_Stats(Path);
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') ==2
            EF = ['Gather_Bile_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            Gather_Bile_Stats(Path);
        end
    elseif v == 4 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') ==2
            EF = ['Gather_Cell_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            Gather_Cell_Stats(Path);
        end
    elseif v == 5 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') ==2
            EF = ['Gather_Volume_Stats_' EFP];
            send(D,{EFP,'Relabel',EF});
            Gather_Cells_Stats(Path);
        end    
    else
        EF = ['Test_1_' EFP];
        send(D,{EFP,'Relabel',EF});
        pause(rand*10);
        send(D,{EF,'Increment',0.2});
        EF2 = ['Test_2_' EFP];
        send(D,{EF,'Relabel',EF2});
        EF = EF2;
        pause(rand*10);
        send(D,{EF,'Increment',0.2});
        EF2 = ['Test_3_' EFP];
        send(D,{EF,'Relabel',EF2});
        EF = EF2;
        pause(rand*10);
        send(D,{EF,'Increment',0.2});
        EF2 = ['Test_4_' EFP];
        send(D,{EF,'Relabel',EF2});
        EF = EF2;
        pause(rand*10);
        send(D,{EF,'Increment',0.2});
        EF2 = ['Test_5_' EFP];
        send(D,{EF,'Relabel',EF2});
        EF = EF2;
        pause(rand*10);
        send(D,{EF,'Increment',0.2});
    end
    multiWaitbar(EF,'Close');
    multiWaitbar('All Data Sets','Increment',1/N);
end
multiWaitbar( 'CloseAll' );
end

function UpdateWaitbar(In)
    a = numel(In);
    if a == 2
        multiWaitbar( In{1},In{2});
    else
        multiWaitbar( In{1},In{2},In{3});
    end
end
