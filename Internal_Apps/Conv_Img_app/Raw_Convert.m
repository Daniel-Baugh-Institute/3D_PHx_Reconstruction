%% Justin Melunis, PhD
% Thomas Jefferson University

function Raw_Convert(Path,cnum,corder,type,ext)
%% Inputs 
%Path - The directory of the file we are trying to convery
%cnum - Number of channels in the image
%corder - Channel Order
%type - exportation type, how you would like to save the file, default is
%uint16
%ext - extention type to find the list of files inside the path directory

%This function converts microscope files into individual channel, 3d images. If there
%are multiple microscope images inside the path directory, this function
%will create a sub folder for each image, move the microscope image to that
%folder, and then convert it into individual channels. 

if nargin < 2 || isempty(cnum)
    cnum = 4;
end
if nargin < 3 || isempty(corder)
    corder = 1:1:cnum;
end
if nargin < 4 || isempty(type)
    type = 'uint16';
end

if nargin < 5 || isempty(ext)
    ext = '.oib';
end

files = dir(Path);
L = length(files);
index = false(1, L);
for k = 1:L
    M = length(files(k).name);
    if M > numel(ext) && strcmp(files(k).name(M + 1 - numel(ext) : M), ext)
        index(k) = true;
    end
end
images = files(index);
%if multiple microscope images
if numel(images) > 1
    for i = 1:numel(images)
        %make sup folder
        mkdir(fullfile(Path,images(i).name(1:end-numel(ext))));
        %copy image to its sub file
        copyfile(fullfile(Path,images(i).name),fullfile(Path,images(i).name(1:end-numel(ext)),images(i).name));
        %convert image
        convert_to_channels(fullfile(Path,images(i).name(1:end-numel(ext))),images(i).name,cnum,corder,type)
    end
elseif numel(images) == 0
    print(['no oib files in folder' Path])
else
    %convert image
    convert_to_channels(Path,images(1).name,cnum,corder,type)
end

