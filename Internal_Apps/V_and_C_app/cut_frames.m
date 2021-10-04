%% Justin Melunis, PhD
% Thomas Jefferson University

function cut_frames(Path,start_frame,out_frame) %Path of images, # of images to cut from start, # to cut from end
    if nargin < 2
        start_frame = 0;
    end
    if nargin < 3
        out_frame = 0;
    end
    a = dir([Path]);
    a = {a.name};
    for i = numel(a):-1:1; b = a{i}; 
        if numel(b) < 4 || ~strcmpi('.tif',b(end-3:end))
            a(i) = []; 
        end 
    end
    fnames = a;
    for i = 1:numel(fnames)
        fname = fnames{i};
        img = Import_Tiff_3d(Path,fname); %import image
        img = img(:,:,start_frame + 1: end - out_frame); %cuts image
        Write_Tiff_3d(img,fname,Path,'uint16') %resave image
    end
end

