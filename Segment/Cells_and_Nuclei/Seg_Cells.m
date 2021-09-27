%% Justin Melunis, PhD
% Thomas Jefferson University

function [Cells, L] = Seg_Cells(path_in,Beta)
if nargin <2
    Beta = 0.1; 
end
x_len = 0.621; 
y_len = 0.621;
z_len = 0.54;

%% Bring in the space that is not cells
[c2] = Import_Tiff_3d(path_in,'Bile.tif');
[c3] = Import_Tiff_3d(path_in,'CV_Mask.tif');
c3(isnan(c3)) = 0;
[c4] = Import_Tiff_3d(path_in,'Sinusoids.tif');
[c5] = Import_Tiff_3d(path_in,'PV_Mask.tif');
c5(isnan(c5)) = 0;
dead_space = c2 | c3 | c4| c5;
d_cs = bwdist(dead_space);

%bring in Nuclei
[Nuclei] = Import_Tiff_3d(path_in,'Hepa_Nuclei.tif');
d_ci = bwdist(Nuclei);


%% segment cells based on a signed maurer distance transform (Maurer et al, 2003)
dist = Beta*d_ci./(Beta*d_ci + (1-Beta)*d_cs);
D = dist;
D = D - min(D(:));
D(dead_space) = 0;
D = D/max(D(:)) * 100;
D = imhmin(D,5);
D(dead_space)=inf;
L = watershed(D);
L(dead_space) = 0;
Cells = im2uint16(L);
Write_Tiff_3d(Cells,'Cell_Seg',path_in,'uint16')
%% references to find methods
% Link for reconstruction method: https://arxiv.org/ftp/arxiv/papers/1410/1410.4598.pdf
% Friebel, A., J. Neitsch, T. Johann, S. Hammad, J. Hengstler, D. Drasdo and 
% S. Hoehme (2015). TiQuant: Software for tissue analysis, quantification and 
% surface reconstruction.

% Signed Maurer Distance Transformation
% Maurer, C.R. et al. (2003) A Linear Time Algorithm for Computing
% Exact Euclidean Distance Transforms of Binary Images in Arbitrary
% Dimensions, IEEE - Transactions on Pattern Analysis and Machine
% Intelligence, 25(2): 265-270. 

% watershed
% Beare, R and Lehmann G. (2006) The watershed transform in ITK
% discussion and new developments, http://hdl.handle.net/1926/202. 