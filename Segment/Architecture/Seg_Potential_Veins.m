%% Justin Melunis, PhD
% Thomas Jefferson University

function [PV_Mask,CV_Mask] = Seg_Potential_Veins(V,V_C,V_P,V_min)
%%%%% Find Potential PV
PV_Mask = false(size(V_C));
if any(V_P(:))
    CV_D = V_P & V_min;
    chisel = ~V & V_P;
    CV_D(chisel) = 0;
    if any(CV_D(:))
        PV_Mask = imfill2border(CV_D,chisel,11); %fills the portal vein to make contact with chisel
    end
end
if any(PV_Mask(:))
    PV_Mask = imclose(PV_Mask,strel('sphere',8));
    PV_Mask = imopen(PV_Mask,strel('sphere',8));
end
%%%%% Chisel the CV down to its proper shape
CV_Mask = false(size(V_C));
if any(V_C(:))
    CV_D = V_C & V_min;
    chisel = ~V & V_C;
    CV_D(chisel) = 0;
    if any(CV_D(:))
        CV_Mask = imfill2border(CV_D,chisel,11); %fills the central vein to make contact with chisel
    end
end

if any(CV_Mask(:))
    CV_Mask = imclose(CV_Mask,strel('sphere',8));
    CV_Mask = imopen(CV_Mask,strel('sphere',8));
end

