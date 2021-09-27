%% Justin Melunis, PhD
% Thomas Jefferson University

function [V_C,V_P,V_min] = Seg_Sort_Potential_Veins(V,GS)
%V_C = Potential Central Vein Maximal Area
%V_P = Potential Portal Vein Maximal Area
%V_min = Minimal Vein sizes

%%%%% Find the areas which are potentially part of the CV
V_min = imclose(V,strel('cube',10));
V_min = imopen(V_min,strel('cube',10));
V_min=imerode(V_min,strel('cube',5));
V_min = bwareaopen(V_min,75000);  %Minimal CV Area %Could potentially adjust this
% R = regionprops3(V_min,'Volume','VoxelIdxList');
 
% V2 = imerode(V_min,strel('cube',20));
% V2 = bwareaopen(V2,50000);
% f = find(V2 == 1);
% 
% for i = 1:size(R,1)
%     if isempty(intersect(f,R.VoxelIdxList{i}))
%        V_min(R.VoxelIdxList{i}) = 0; 
%     end
% end

V_C=imdilate(V_min,strel('cube',50)); %All the potential voxels for the CV,
%Assumption that veins are not close enough to be combined here

V_P = zeros(size(V_C));
Seg = bwconncomp(V_C);
for i=1: Seg.NumObjects %Keep only web areas which overlap some form of GS staining
    a = intersect(GS,Seg.PixelIdxList{i});
    if numel(a) < 10
        V_C(Seg.PixelIdxList{i})=0;
        V_P(Seg.PixelIdxList{i})=1;
    end
end  


