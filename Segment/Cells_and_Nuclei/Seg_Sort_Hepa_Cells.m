%% Justin Melunis, PhD
% Thomas Jefferson University

function Seg_Sort_Hepa_Cells(Path)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Import Cell Data
Cells = Import_Tiff_3d(Path,'Cell_Seg.tif','uint16');
Nuc = Import_Tiff_3d(Path,'Hepa_Nuclei.tif');

%% Remove too small of cells, etc
R = regionprops3(Cells,'Volume','VoxelIdxList');
for i = 1:size(R,1)
    %Set of rules to determine what is a cell
    if R.Volume(i) < 5000 || numel(find(Nuc & Cells==i)) == 0
        Cells(R.VoxelIdxList{i}) = 0;
    end
end
Cells = shift_matrix(Cells);
Write_Tiff_3d(Cells,'Hepa_Cell_Seg',Path,'uint16')
end

