%% Justin Melunis, PhD
% Thomas Jefferson University

function Write_Tiff_3d(img,fname,path,type)
%Writes a 3d matrix (Img) into a 3d .tif image with the filename of fname and at the path of the input path.
%You can dictate to change the bit depth in which the image is stored with
%type

%if you dont specify a type, uses whatever type the matrix was
if nargin < 4
    type = 'skip';
end

%If you gave the filename with the format, removes the format
C = strsplit(fname,'.');
fname = C{1};

%Specifies a .tif format
fname = [fname '.tif'];

%Converts file type
if strcmpi(type,'uint8') == 1
    img=uint8(img);
elseif strcmpi(type,'double') == 1
    img = double(img);
elseif strcmpi(type,'binary') == 1
    img = logical(img);
elseif strcmpi(type,'uint16') == 1
    img=uint16(img);
end

%if no path is given, will save in current directory
if nargin < 3
    path='';
end
%checks to make sure the input matrix is 3d
N=ndims(img);
[~,~,z]=size(img);
%if 3d, save it
if N==3
    %creates the file with the first frame of the z stack
    tiff = img(:, :, 1);
    imwrite(tiff,fullfile(path,fname),'WriteMode','overwrite')
    %iteratively adds the remaining frames
    for i = 2:z
        tiff = img(:, :, i);
        imwrite(tiff,fullfile(path,fname),'WriteMode','append')
    end
    %if not 3d, displays an error
else
   disp('dimension mismatch, did not save file');
end
