%% Justin Melunis, PhD
% Thomas Jefferson University

function [image_out] = RescaleIm(image_in)
%Rescales an image into the range of 0 to 1
a=min(image_in(:));
image_in = image_in - a;
image_out = image_in/max(image_in(:));
end

