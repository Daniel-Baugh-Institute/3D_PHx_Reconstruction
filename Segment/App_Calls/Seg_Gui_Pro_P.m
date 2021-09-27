%% Justin Melunis, PhD
% Thomas Jefferson University

%% This Function is called on the liver segmentation app and chooses what type of segmentation to undergo based on the vaue of the input, v.
%Runs code multiple data sets in parallel

%N_Core = number of parallel workers that we wish to use

%V (1 = All, 2 = Architecture Only, 3 = Nuclei Only)

%Path_List is a list of all the paths to files for segmentation, where each
%path corresponds to a single set of images

%End_Folders is the last folder in the path that is displayed on the
%progress bar
function Seg_Gui_Pro_P(N_Core,v,Path_List,End_Folders)

%Create parallel pool
delete(gcp('nocreate'))
parpool(N_Core)
D = parallel.pool.DataQueue;
%Set up to allow for multiWaitBar to be updated
afterEach(D, @UpdateWaitbar);

%Count Number of Files being ran
N = numel(Path_List);
multiWaitbar( 'CloseAll' );
if N > 1
    multiWaitbar( 'All Data Sets',0);
end
pause(rand*0.01)
parfor i=1:N
    %Set Path
    Path = Path_List{i};
    EF = End_Folders{i};
    EFP = EF;
    send(D, {EF,0});
    pause(2)
    if v == 1
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
            %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP];
            send(D,{EFP,'Relabel',EF});
            [Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path);
            send(D,{EF,'Increment',0.15});
            % Segment out Bile part 1
            EF2 = ['Seg_Void_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [V,GS] = Seg_Void_Pro(img_us,Path);
            send(D,{EF,'Increment',0.15});
            % Segmenting out veins
            EF2 = ['Seg_Veins_P1_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
            send(D,{EF,'Increment',0.15});
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Veins_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);
            send(D,{EF,'Increment',0.15});
            % Segment out Bile Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Sinu_2(Sinu_both,Sinu_us,PV_Mask,CV_Mask,Path);
            send(D,{EF,'Increment',0.15});
            %% Nuclei Segmentation
            EF2 = ['Seg_Nuclei_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Nuclei_Pro(Path);
            send(D,{EF,'Increment',0.25});
        else
            disp([Path ' does not contain the proper files'])
        end 
    elseif v == 2 %% Architecture Only Segmentation
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
                        %% Architecture Segmentation
            EF = ['Seg_Sinu_P1_' EFP];
            send(D,{EFP,'Relabel',EF});
            [Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path);
            send(D,{EF,'Increment',0.2});
            % Segment out Bile part 1
            EF2 = ['Seg_Void_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [V,GS] = Seg_Void_Pro(img_us,Path);
            send(D,{EF,'Increment',0.2});
            % Segmenting out veins
            EF2 = ['Seg_Veins_P1_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
            send(D,{EF,'Increment',0.2});
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Veins_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);
            send(D,{EF,'Increment',0.2});
            % Segment out Bile Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            send(D,{EF,'Relabel',EF2});
            EF = EF2;
            Seg_Sinu_2(Sinu_both,Sinu_us,PV_Mask,CV_Mask,Path);
            send(D,{EF,'Increment',0.2});
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') == 2
            EF = ['Seg_Nuclei_' EFP];
            send(D,{EFP,'Relabel',EF});
            Seg_Nuclei_Pro(Path);
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

function UpdateWaitbar(In)
    a = numel(In);
    if a == 2
        multiWaitbar( In{1},In{2});
    else
        multiWaitbar( In{1},In{2},In{3});
    end
end