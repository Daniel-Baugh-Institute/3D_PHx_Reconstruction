%% Justin Melunis, PhD
% Thomas Jefferson University

function [img,iter] = imfill2border(img,border,max_num,strel_shape,max_it)
if nargin<3
    max_num = 20;
end

if nargin<4
    strel_shape = 'cube';
end

if nargin<5
   max_it = 5; 
end

if mod(max_num,2) == 0
   max_num = max_num - 1; 
end
change = 1;
iter = 0;
while change ==1
    iter = iter + 1;
    img_old = img;
    change = 0;
    for mm = max_num:-2:3
        a = imclose(border,strel(strel_shape,mm));
        b = imclose((img| border),strel(strel_shape,mm));
        img = img | (b-a);
    end
    for mm = 5:-2:3
        a = imdilate(img,strel(strel_shape,mm));
        b = imerode((a|border),strel(strel_shape,mm));
        b(border) = 0;
        img = img | (b);
    end
    if (numel(find((~img_old & img))>0)) && (iter < max_it)
        change = 1;
    end
end

% img = imdilate(img,strel('cube',5));
% img(border) = 0;

