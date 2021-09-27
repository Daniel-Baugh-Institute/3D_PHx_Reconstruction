%% Justin Melunis, PhD
% Thomas Jefferson University

function Gather_Cell_Stats(Path,res)

if nargin < 2
    res = [0.621 0.621 0.54];
end

%% Import Cell Data
Cells = Import_Tiff_3d(Path,'Hepa_Cell_Seg.tif','uint16');
Nuc = Import_Tiff_3d(Path,'Hepa_Nuclei_Seg.tif','uint16');
Comp = Import_Tiff_3d(Path,'Composite.tif','uint8');
[CV] = Import_Tiff_3d(Path,'CV_Mask.tif');
[x,y,z] = size(CV);
CV(isnan(CV)) = 0;
if any(CV(:))
    [~,CV_I] = bwdist(CV);
else
    CV_I = -1*ones(size(CV));
end
[PV] = Import_Tiff_3d(Path,'PV_Mask.tif');
PV(isnan(PV)) = 0;
if any(PV(:))
    [~,PV_I] = bwdist(CV);
else
    PV_I = -1*ones(size(CV));
end
%% Create a 6 voxel connected strel to dialate on
S = zeros(3,3,3); S(:,:,2)=[0 1 0; 1 1 1; 0 1 0]; S(2,2,1) = 1; S(2,2,3) = 1;

%Gather Stats
R = regionprops3(Cells,'Volume','VoxelIdxList','Centroid');
R2 = regionprops3_2(Cells);
MA = reshape([R2.MajorAxis],3,size(R,1))';
MA_L = [R2.MajorAxisLength]'.*([(sqrt((MA(:,1)*res(1)).^2 + (MA(:,2)*res(2)).^2 + (MA(:,3)*res(3)).^2))]);
Cell_Num = [1:1:size(R,1)]';
Cell_Vol = R.Volume*res(1)*res(2)*res(3);
Cell_X = R.Centroid(:,2);
Cell_Y = R.Centroid(:,1);
Cell_Z = R.Centroid(:,3);
Meri_Eccen = [R2.MeridionalEccentricity]';
Equat_Eccen = [R2.EquatorialEccentricity]';

CV_X = -1*ones(size(Cell_X)); CV_Y = CV_X; CV_Z = CV_X; D_CV = CV_X; D_PV = D_CV; CV_Theta = D_CV;
Num_Nuc = zeros(size(R,1),1);
for i = 1:size(R,1)
    idx = CV_I(round(R.Centroid(i,2)), round(R.Centroid(i,1)),round(R.Centroid(i,3)));
    if idx > 0
        [X,Y,Z] = ind2sub([x,y,z],idx);
        CV_X(i) = (R.Centroid(i,2) - X)*res(1);
        CV_Y(i) = (R.Centroid(i,1) - Y)*res(2);
        CV_Z(i) = (R.Centroid(i,3) - Z)*res(3);
        D_CV(i) = sqrt(CV_X(i)^2 + CV_Y(i)^2 + CV_Z(i)^2);
        u = R2(i).MajorAxis;
        v = [CV_Y(i) CV_X(i) CV_Z(i)];
        Theta = min(acosd(dot(u,v)/(norm(u)*norm(v))),acosd(dot(-u,v)/(norm(-u)*norm(v))));
        CV_Theta(i) = Theta;
    end
    idx = PV_I(round(R.Centroid(i,2)), round(R.Centroid(i,1)),round(R.Centroid(i,3)));
    if idx > 0
        [X,Y,Z] = ind2sub([x,y,z],idx);
        PV_X(i) = (R.Centroid(i,2) - X)*res(1);
        PV_Y(i) = (R.Centroid(i,1) - Y)*res(2);
        PV_Z(i) = (R.Centroid(i,3) - Z)*res(3);
        D_PV(i) = sqrt(CV_X(i)^2 + CV_Y(i)^2 + CV_Z(i)^2);
    end
    %Determine the number of nuclei each cell has
    CellV = Cells==i; 
    CN = unique(Nuc(CellV));
    CN = CN(CN>0);
    Num_Nuc(i) = numel(CN);
end

%% Gather Boundary Information
%Initiate
R.IdxVoxels = cell(size(R,1),1);
R.BoundaryVoxels = cell(size(R,1),1);
R.B_Voxels = cell(size(R,1),1);
R.T_Bound = zeros(size(R,1),1);
R.B_C = zeros(size(R,1),1);
R.B_C_P = zeros(size(R,1),1);
R.B_CV = zeros(size(R,1),1);
R.B_CV_P = zeros(size(R,1),1);
R.B_PV = zeros(size(R,1),1);
R.B_PV_P = zeros(size(R,1),1);
R.B_S = zeros(size(R,1),1);
R.B_S_P = zeros(size(R,1),1);
R.B_B = zeros(size(R,1),1);
R.B_B_P = zeros(size(R,1),1);
R.B_Voxels = cell(size(R,1),1);
%Fill Rows
for i = 1:size(R,1)
    %Boundary Voxel Index List
    CellV = Cells==i;
    Boundary = imdilate(CellV,S) & ~ CellV;
    R.B_Voxels(i) = {find(Boundary)};
    %Total
    T_Bound = numel(find(Boundary));
    R.T_Bound(i) = T_Bound;
    %Cell
    T = numel(find(Boundary & Comp == 0));
    R.B_C(i) = T;
    R.B_C_P(i) = T/T_Bound;
    %CV
    T = numel(find(Boundary & Comp == 1));
    R.B_CV(i) = T;
    R.B_CV_P(i) = T/T_Bound;
    %PV
    T = numel(find(Boundary & Comp == 2));
    R.B_PV(i) = T;
    R.B_PV_P(i) = T/T_Bound;
    %Sinusoids
    T = numel(find(Boundary & Comp == 3));
    R.B_S(i) = T;
    R.B_S_P(i) = T/T_Bound;
    %Bile
    T = numel(find(Boundary & Comp == 4));
    R.B_B(i) = T;
    R.B_B_P(i) = T/T_Bound;
end
headers = {'Cell_Number','Num_Nuclei','Volume (uM^3)','Center_X (Voxel)','Center_Y (Voxel)','Center_Z (Voxel)',...
'CV_X','CV_Y','CV_Z', 'CV_Theta','D_CV','D_PV','MA_X','MA_Y','MA_Z','MA_L','Eccentricity_M','Eccentricity_E',...
'Total_Boundary','Boundary_Cell','Boundary_Cell_Percent','Boundary_CV','Boundary_CV_Percent',...
'Boundary_PV','Boundary_PV_Percent','Boundary_Sinusoid','Boundary_Sinusoid_Percent',...
'Boundary_Bile','Boundary_Bile_Percent'};
Data = [Cell_Num,Num_Nuc,Cell_Vol,Cell_X,Cell_Y,Cell_Z,CV_X,CV_Y,CV_Z,CV_Theta,D_CV,D_PV,MA,MA_L,Meri_Eccen,Equat_Eccen,...
    [R.T_Bound],[R.B_C],[R.B_C_P],[R.B_CV],[R.B_CV_P],[R.B_PV],[R.B_PV_P],[R.B_S],[R.B_S_P],[R.B_B],[R.B_B_P]];
% % 
% % %Save to XLS
xlswrite([Path 'Cell_Labels'],headers,'Sheet1');
csvwrite(fullfile(Path,'Cell_Stats'),Data);

% 
% %% Create Adjacency Matrix
Adj = zeros(size(R,1),size(R,1));
for i = 1:(size(R,1) - 1)
    for j = i+1:size(R,1)
        Adj(i,j) = numel(intersect(R.B_Voxels{i},R.B_Voxels{j}) );
    end
end
Adj = sparse(Adj);
[row,col,v] = find(Adj);
xlswrite(fullfile(Path,'Cell_Adjacency_Headers'),{'Cell1','Cell2','N_Surface_Voxels'});

Data = [row, col, v];
csvwrite(fullfile(Path,'Cell_Adjacency'),Data);
end

