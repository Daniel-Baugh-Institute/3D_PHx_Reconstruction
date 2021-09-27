%% Justin Melunis, PhD
% Thomas Jefferson University

%% This Function is called on the liver segmentation app and chooses what type of segmentation to undergo based on the vaue of the input, v.

%V (1 = All, 2 = Architecture Only, 3 = Nuclei Only)

%Path_List is a list of all the paths to files for segmentation, where each
%path corresponds to a single set of images

%End_Folders is the last folder in the path that is displayed on the
%progress bar

function Seg_Gui_Pro(v,Path_List,End_Folders)
%Non-para Proliferation Segmentation

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
        if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
            %% Architecture Segmentation
            % Segment out sinusoids part 1
            EF = ['Seg_Sinu_P1_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            [Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path);
            multiWaitbar(EF,'Increment',0.15);
            % Segment out Bile part 1
            EF2 = ['Seg_Void_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [V,GS] = Seg_Void_Pro(img_us,Path);
            multiWaitbar(EF,'Increment',0.15);
            % Segmenting out veins
            EF2 = ['Seg_Veins_P1_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
            multiWaitbar(EF,'Increment',0.15);
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Veins_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);
            multiWaitbar(EF,'Increment',0.15);
            % Segment out Bile Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Sinu_2(Sinu_both,Sinu_us,PV_Mask,CV_Mask,Path);
            multiWaitbar(EF,'Increment',0.15);
            %% Nuclei Segmentation
            EF2 = ['Seg_Nuclei_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Nuclei_Pro(Path);
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
            [Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path);
            multiWaitbar(EF,'Increment',0.2);
            % Segment out Bile part 1
            EF2 = ['Seg_Void_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [V,GS] = Seg_Void_Pro(img_us,Path);
            multiWaitbar(EF,'Increment',0.2);
            % Segmenting out veins
            EF2 = ['Seg_Veins_P1_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
            multiWaitbar(EF,'Increment',0.2);
            % Segmenting Sinu Part 2
            EF2 = ['Seg_Veins_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            [PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);
            multiWaitbar(EF,'Increment',0.2);
            % Segment out Bile Part 2
            EF2 = ['Seg_Sinu_P2_' EFP];
            multiWaitbar(EF,'Relabel',EF2);
            EF = EF2;
            Seg_Sinu_2(Sinu_both,Sinu_us,PV_Mask,CV_Mask,Path);
            multiWaitbar(EF,'Increment',0.2);
        else
            disp([Path ' does not contain the proper files'])
        end
    elseif v == 3 %% Nuclei Only Segmentation
        if exist(fullfile(Path,'Bile.tif'),'file') ==2
            EF = ['Seg_Nuclei_' EFP];
            multiWaitbar(EFP,'Relabel',EF);
            Seg_Nuclei_Pro(Path);
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


