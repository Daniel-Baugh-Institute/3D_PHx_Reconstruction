%% Justin Melunis, PhD
% Thomas Jefferson University

%% This Function is called on the liver segmentation app and chooses what type of segmentation to undergo based on the vaue of the input, v.

%V (1 = All, 2 = Architecture Only, 3 = Nuclei Only, 4 = Cell Only)

%Path_List is a list of all the paths to files for segmentation, where each
%path corresponds to a single set of images

%End_Folders is the last folder in the path that is displayed on the
%progress bar

function Seg_Gui(v,Path_List,End_Folders)

N = numel(Path_List); %numel of image sets
%% Set up waitbar
multiWaitbar( 'CloseAll' ); %Clears the waitbar
if N > 1 %if more than 1 path
    multiWaitbar( 'All Data Sets',0); %Opens an overall progress bar at top
end

for i=1:N
    %Set Path 
    Path = Path_List{i}; %Set Path
    EF = End_Folders{i}; %Set the end folder
    EFP = EF; %Set a holding value as the end folder, is used to tell where in the process each image set is
    multiWaitbar(EF,0); %Starts a progress bar for the ith path
    pause(2) %Wait 2 seconds, lets the progress bar load and prevents errors
    if v == 1 %All segmentation
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2 %if all images exist
            %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP]; %Create progress bar label
            multiWaitbar(EFP,'Relabel',EF); %Set progress bar
            [Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(Path); %Sinu seg 1
            multiWaitbar(EF,'Increment',0.1); %Update the progress of the progress bar
            % Segment out Bile part 1
            EF2 = ['Seg_Bile_P1_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [Bile] = Seg_Bile_1(c2,Sinu,g2); %Bile Seg 1
            multiWaitbar(EF,'Increment',0.1);
            % Segmenting out veins
            EF2 = ['Seg_Veins_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path); %Segments CV and PV
            multiWaitbar(EF,'Increment',0.1);
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path); %Improves the sinu seg by using the sinu skeleton, also closes gaps with CV and PV
            multiWaitbar(EF,'Increment',0.1);
            % Segment out Bile Part 2
            EF2 = ['Seg_Bile_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path); %Removes Sinu/Bile overlap and skeletonizes the bile canaliculi
            multiWaitbar(EF,'Increment',0.1);
            %% Nuclei Segmentation
            EF2 = ['Seg_Nuclei_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Nuclei(Path); %Segments Nuclei using gLoG blob detector
            multiWaitbar(EF,'Increment',0.25);
            %% Cell Segmentation
            EF2 = ['Seg_Cells_' EFP];
            multiWaitbar(EF,'Relabel',EF);
            EF = EF2;
            Seg_Cells(Path); %Segments cells
            Seg_Sort_Hepa_Cells(Path); %Removes erroneous cells (too small, no nuclei, etc)
            multiWaitbar(EF,'Increment',0.25);
        else
            disp([Path ' does not contain the proper files'])
        end 
    elseif v == 2 %% Architecture Only Segmentation
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
            %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            [Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(Path);
            multiWaitbar(EF,'Increment',0.2);
            % Segment out Bile part 1
            EF2 = ['Seg_Bile_P1_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [Bile] = Seg_Bile_1(c2,Sinu,g2);
            multiWaitbar(EF,'Increment',0.2);
            % Segmenting out veins
            EF2 = ['Seg_Veins_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path);
            multiWaitbar(EF,'Increment',0.2);
            % Using skeleton to finish segmenting out Sinusoids
            EF2 = ['Seg_Sinu_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path);
            multiWaitbar(EF,'Increment',0.2);
            % Segment out Bile Part 2
            EF2 = ['Seg_Bile_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path);Seg_Arch_P(Path);
            multiWaitbar(EF,'Increment',0.2);
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') ==2
            EF = ['Seg_Nuclei_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Seg_Nuclei(Path);
        end
    elseif v == 4 %% Cell Only Segmentation
        if exist(fullfile(Path,'Hepa_Nuclei.tif'),'file') ==2
            EF = ['Seg_Cells_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Seg_Cells(Path);
            Seg_Sort_Hepa_Cells(Path);
        end
    else %This runs a test on the app to show that the app is properly working
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
    multiWaitbar(EF,'Close'); %Remove the path
    multiWaitbar('All Data Sets','Increment',1/N); %Step forward in the all data sets progress bar
end
multiWaitbar( 'CloseAll' ); %Close the waitbar
end
