%% Justin Melunis, PhD
% Thomas Jefferson University

function convert_to_channels(Path,fname,cnum,corder,type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3 || isempty(cnum)
    cnum = 4;
end

if nargin < 4 || isempty(corder)
    corder = 1:1:cnum;
end

if nargin < 5 || isempty(type)
    type = 'uint16';
end

Data = bfopen(fullfile(Path,fname));
Idata = Data{1};
Depth = size(Idata,1)/cnum;
count = 1;

for i = 1:cnum
    ch = corder(i);
    D = [];
    for j = 1:1:Depth
        idx = count + (j-1) * cnum;
        D(:,:,j) = Idata{idx,1};
    end
%     D = RescaleIm(D);
    Write_Tiff_3d(D,['c' num2str(ch)],Path,type);
    count = count + 1;
end

