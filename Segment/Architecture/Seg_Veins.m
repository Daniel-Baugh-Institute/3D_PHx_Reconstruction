%% Justin Melunis, PhD
% Thomas Jefferson University

function [PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[V,GS] = Seg_Void(img4,Bile,Path);
[V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS);
[PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min);
end

