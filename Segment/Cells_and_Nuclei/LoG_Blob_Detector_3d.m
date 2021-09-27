%% Justin Melunis, PhD
% Thomas Jefferson University

function [AB,F_List,Data,Data_Sum,Data_Max] = LoG_Blob_Detector_3d(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Input Parser

p = inputParser;
p.CaseSensitive = false;
validationFcn = @(x) validateattributes(x,{'numeric'},{'positive'});
addRequired(p,'Img')
addOptional(p,'BW',[])
addOptional(p,'SigMin',8,validationFcn)
addOptional(p,'SigMax',14,validationFcn)
addOptional(p,'SigStep',1,validationFcn)
addOptional(p,'angles',0:30:179,validationFcn)
addParameter(p,'method','LoG',@(x) any(validatestring(x,{'LoG','gLoG'})));
addParameter(p,'gpu','off',@(x) any(validatestring(x,{'off','on'})));
addParameter(p,'foreground','both',@(x) any(validatestring(x,{'bright','dark','both'})));
addParameter(p,'ScaleFactor','Sigma',@(x) any(validatestring(x,{'Sigma','log'})));
addParameter(p,'alpha',1,@(x) assert(isnumeric(x) && (x > 0)));
parse(p,varargin{:})
Img = p.Results.Img;
BW = p.Results.BW;
method = p.Results.method;
angles = p.Results.angles;
SigMin = p.Results.SigMin;
SigMax = p.Results.SigMax;
SigStep = p.Results.SigStep;
gpu = p.Results.gpu;
Fore = p.Results.foreground;
ScaleFactor = p.Results.ScaleFactor;
alpha = p.Results.alpha;
F_Size = 2*ceil(2*SigMax)+1;

gen = 1;
if any(strcmpi(method,{'LoG','DoG'}))
   gen = 0;
end

Img = im2double(Img);
ImgIn = Img;
if strcmpi(Fore,'dark')
    Img = imcomplement(Img);
end

Depth = floor((SigMax - SigMin)/SigStep)+1;
N_Filter = Depth;

counter = 0;

F_List = SigMax:-SigStep:SigMin;
%% Decide to run on GPU or not, default is not
if strcmpi(gpu,'on')
    Img = gpuArray(Img);
end

%% Determine scaling factors
SF = (1 + log(F_List.^alpha).^3);


%% Apply filters to 
tic
Data = [];
for i = 1:numel(F_List)
    A = imgaussfilt3(Img,F_List(i)/sqrt(2));
    B = imgaussfilt3(Img,F_List(i)*sqrt(2));
    Data(:,:,:,i) = (A - B)*SF(i);
end
toc

Data = im2double(Data);
Data_Sum = sum(Data,4);
Data_Max = max(Data,[],4);
DD = RescaleIm(Data_Sum);

AB = imextendedmax(DD,0.001);
for i = 0.002:0.001:0.01
    AA = imextendedmax(DD,0.01);
    AB = AB | AA;
end

if ~isempty(BW)
    AB(~BW) = 0;
else
    BW = imbinarize(DD);
    AB(~BW) = 0;
end

end

