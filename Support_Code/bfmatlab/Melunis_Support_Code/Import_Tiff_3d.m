%% Justin Melunis, PhD
% Thomas Jefferson University

function [out] = Import_Tiff_3d(fp,fn,type)
%imports 3d images into 3d matrices

if nargin < 3
    type = 'double';
end
%uses PATH as a global variable. This way, if you run this function
%multiple times without giving a path, you will open to the folder that you
%last used
global PATH
%% Find file path and name, starting at whatever information you place in. 
%If you give a filename and filepath (fn,fp) then it will open that file, 
%otherwise it will prompt you to select a file
if nargin == 0
    %if you do not give a path, looks for a global path and sets fp as that
    fp = set_path(PATH);
    [fn,fp] = uigetfile([fp '*.tif;*.tiff']);
elseif nargin ==1
    if numel(fp)==0 || fp(1)==0
        fp = set_path(PATH);
    end
    [fn,fp] = uigetfile([fp '*.tif;*.tiff']);
elseif nargin ==2
    if (numel(fp)==0 || fp(1)==0)
        if numel(PATH)==0 || PATH(1)==0
            [fn,fp] = uigetfile('*.tif;*.tiff');
        else
            %if you give a filename and not a path, looks to see if there
            %is a global path, if not, assumes you are looking for the file
            %in the currentl directory
            fp = set_path(PATH);
        end
    end
    if numel(fn)==0 || fn(1)==0
        [fn,fp] = uigetfile([fp '*.tif;*.tiff']);
    end
end
%sets the global path variable to the path you are going to use
PATH = fp;
fname= fullfile(fp,fn);

%% Read out image
%reads the info of the image and finds out the depth of the image
info = imfinfo(fname);
num_images = numel(info);
for k = 1:num_images
    A = imread(fname, k);
    out(:,:,k)=A;
end

%converts the image into the input type, if none is given, converts to
%double and normalizes to a range between 0 and 1
if strcmpi(type,'double')==1
    out = im2double(out);
    [out] = RescaleIm(out);
elseif strcmpi(type,'uint8')==1
    out = im2uint8(out);  
elseif strcmpi(type,'uint16')==1
    out = im2uint16(out);  
else
    disp('error in type, will open as double')
    out = im2double(out);
    [out] = RescaleIm(out);
end

%% function for simplicity in code
function fp = set_path(PATH)
    if numel(PATH)==0 || PATH(1)==0
        PATH = '';
    end
    fp = PATH;
end
end