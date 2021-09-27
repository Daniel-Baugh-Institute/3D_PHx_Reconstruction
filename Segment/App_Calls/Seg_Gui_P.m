%% Justin Melunis, PhD
% Thomas Jefferson University

%% This Function is called on the liver segmentation app and chooses what type of segmentation to undergo based on the vaue of the input, v.
%Runs code multiple data sets in parallel

%N_Core = number of parallel workers that we wish to use

%V (1 = All, 2 = Architecture Only, 3 = Nuclei Only, 4 = Cell Only)

%Path_List is a list of all the paths to files for segmentation, where each
%path corresponds to a single set of images

%End_Folders is the last folder in the path that is displayed on the
%progress bar

function Seg_Gui_P(N_Core,v,Path_List,End_Folders)

%% Create parallel pool which creates multiple, parallel workers
delete(gcp('nocreate')) %Delete any previous pool, the 'nocreate' prevents the program from creating a pool, then deleting it
parpool(N_Core) %Creates the parallel workers

%% Set up to allow for multiWaitBar to be updated from multiple, independent
%workers
D = parallel.pool.DataQueue; %Creates a dataqueue that allows transfer between workers 
afterEach(D, @UpdateWaitbar); %Sets up that when D is called, it will run UpdateWaitbar function (at the bottom)

N = numel(Path_List);%Count Number of Files being ran
%% Set up the progress bar
multiWaitbar( 'CloseAll' ); %Clears the waitbar
if N > 1 %if more than 1 path
    multiWaitbar( 'All Data Sets',0); %Opens an overall progress bar at top
end
pause(rand*0.01)

parfor i=1:N
    %Set Path
    Path = Path_List{i}; %Set Path
    EF = End_Folders{i}; %Set the end folder
    EFP = EF; %Set a holding value as the end folder, is used to tell where in the process each image set is
    send(D, {EF,0}); %Calls D(the data que) and sends the inputs EF,0 to the UpdateWaitbar function
    pause(10) %Pauses for a significant amount of time, so that the data que does not have any errors
    if v == 1 %All segmentation
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
            %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP]; %Create progress bar label
            send(D,{EFP,'Relabel',EF}); %Set progress bar
            [Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(Path);
            send(D,{EF,'Increment',0.1}); %Update the progress of the progress bar by sending to the dataqueue, D
            % Segment out Bile part 1
            EF2 = ['Seg_Bile_P1_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [Bile] = Seg_Bile_1(c2,Sinu,g2);
            send(D,{EF,'Increment',0.1});
            % Segmenting out veins
            EF2 = ['Seg_Veins_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path);
            send(D,{EF,'Increment',0.1});
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path);
            send(D,{EF,'Increment',0.1});
            % Segment out Bile Part 2
            EF2 = ['Seg_Bile_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path);Seg_Arch_P(Path);
            send(D,{EF,'Increment',0.1});
            %% Nuclei Segmentation
            EF2 = ['Seg_Nuclei_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Nuclei(Path);
            send(D,{EF,'Increment',0.25});
            %% Cell Segmentation
            EF2 = ['Seg_Cells_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Cells(Path);
            Seg_Sort_Hepa_Cells(Path);
            send(D,{EF,'Increment',0.25});
        else
            disp([Path ' does not contain the proper files'])
        end 
    elseif v == 2 %% Architecture Only Segmentation
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
                        %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP];
            send(D,{EFP,'Relabel',EF});
            [Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(Path);
            send(D,{EF,'Increment',0.2});
            % Segment out Bile part 1
            EF2 = ['Seg_Bile_P1_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [Bile] = Seg_Bile_1(c2,Sinu,g2);
            send(D,{EF,'Increment',0.2});
            % Segmenting out veins
            EF2 = ['Seg_Veins_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path);
            send(D,{EF,'Increment',0.2});
            % Segment Sinu Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path);
            send(D,{EF,'Increment',0.2});
            % Segment out Bile Part 2
            EF2 = ['Seg_Bile_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path);
            send(D,{EF,'Increment',0.2});
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') == 2
            EF = ['Seg_Nuclei_' EFP];
            send(D,{EFP,'Relabel',EF});
            Seg_Nuclei(Path);
        end
    elseif v == 4 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') == 2
            EF = ['Seg_Cells_' EFP];
            send(D,{EFP,'Relabel',EF});
            Seg_Cells(Path);
            Seg_Sort_Hepa_Cells(Path);
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
    send(D,{EF,'Close'});
    send(D,{'All Data Sets','Increment',1/N});
end
multiWaitbar( 'CloseAll' );
end

function UpdateWaitbar(In) %Function to update waitbar
    a = numel(In); %Find how many inputs
    if a == 2 %if 2, use the 2 to update
        multiWaitbar( In{1},In{2});
    else %if it is not 2 variables, it may be 3, so update with 3
        multiWaitbar( In{1},In{2},In{3});
    end
end
