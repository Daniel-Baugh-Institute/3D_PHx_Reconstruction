if ~exist('In_Path','var')
    In_Path = uigetdir();
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

for k = 1:numel(Path_List)
    k
    Path = Path_List{k};
    [Sinu] = Import_Tiff_3d(Path,'Sinusoids.tif');
    Sinu = logical(Sinu);
    Skel = bwskel(Sinu,'MinBranchLength',20);
    [~,node,link] = Skel2Graph3D(Skel,20);
    N = zeros(size(Skel));
    for i = 1:numel(node)
       N(node(i).idx) = 1;
    end

    A = zeros(size(Skel));
    for i = 1:numel(link)
        A(link(i).point) = i; 
    end
    A(N==1) = 0;

    [D,idx] = bwdist(Skel | N);

    C = A(idx);
     C(~Sinu) = 0;
    Write_Tiff_3d(C,'Sinu_Seg',Path,'uint16')
end