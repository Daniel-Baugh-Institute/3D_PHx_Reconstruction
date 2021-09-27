%% Justin Melunis, PhD
% Thomas Jefferson University

function Seg_Arch_P(Path)

%% Segment out sinusoids part 1
% disp('Segmenting Sinusoids part 1');
[Sinu,Sinu2,img4,c2,g2] = Seg_Sinu_1(Path);
%% Segment out Bile part 1
% disp('Segmenting Bile part 1');
[Bile] = Seg_Bile_1(c2,Sinu,g2);

%% Segmenting out veins
% disp('Segmenting CV/PV part 1');
[PV_Mask,CV_Mask] = Seg_Veins(img4,Bile,Path);

%% Using skeleton to finish segmenting out Sinusoids
% disp('Segmenting Sinusoids part 2');
[Sinu,PV_Mask,CV_Mask] = Seg_Sinu_2(Sinu,Sinu2,PV_Mask,CV_Mask,Path);

%% %% Segment out Bile Part 2
% disp('Segmenting Bile part 2');
Seg_Bile_2(Bile,PV_Mask,CV_Mask,Sinu,Path);

