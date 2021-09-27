%% Justin Melunis, PhD
% Thomas Jefferson University

function [time,scale_out,scale_in] = Convert_time(a,scale,scale2)
%This function takes in a string containing 
%Month is based on 30 days
%Year is based on 365 days
if nargin < 2
    scale = 'hr';
end
scale_out = find_scale(scale);

idx = regexp(a,'\d');
Num = str2num(a(idx));
if isempty(Num)
    Num = 1;
end
a(idx) = [];
a = strtrim(a);
if nargin < 3
    scale_in = find_scale(a);
else
    scale_in = find_scale(scale2);
end
time = Num*scale_in/scale_out;

scale_in = disp_scale(scale_in);
scale_out = disp_scale(scale_out);

end

function scale = find_scale(in)
    in = lower(in);
    if any(strcmp(in,{'s','sec','second','seconds'}))
        scale = 1;
    elseif any(strcmp(in,{'m','min','minute','minutes'}))
        scale = 60;
    elseif any(strcmp(in,{'h','hr','hour','hours'}))
        scale = 3600;
    elseif any(strcmp(in,{'d','day','days'}))
        scale = 86400;
    elseif any(strcmp(in,{'w','wk','week','weeks'}))
        scale = 604800;
    elseif any(strcmp(in,{'mon','mth','mnth','month','months'}))
        scale = 2592000;
    elseif any(strcmp(in,{'y','yr','year','years'}))
        scale = 31536000;
    end
end

% 
function out = disp_scale(scale)
    if scale == 1
        out = 'sec';
    elseif scale == 60
        out = 'min';
    elseif scale == 3600
        out = 'hr';
    elseif scale ==86400
        out = 'day';
    elseif scale == 604800
        out = 'week';
    elseif scale == 2592000
        out = 'month';
    elseif scale == 31536000
        out = 'year';
    end
end

