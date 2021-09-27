function Seg_Arch_Pro(Path,Path_out)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    Path_out = Path;
end
tic
disp('Segmenting Sinusoids part 1');
[Sinu_both,Sinu_us,img_us] = Seg_Sinu_1_Pro(Path);

%% Segmenting out veins
disp('Segmenting CV/PV part 1');
[V,GS] = Seg_Void_Pro(img_us,Path);
[V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
[PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);


Seg_Sinu_2(Sinu_both,Sinu_us,PV_Mask,CV_Mask,Path_out);
toc
end

