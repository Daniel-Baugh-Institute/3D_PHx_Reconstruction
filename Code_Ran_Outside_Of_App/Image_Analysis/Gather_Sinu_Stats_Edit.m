function Gather_Sinu_Stats(Path,res)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Strel = ones(7,7,7);

if nargin<2
    res = [0.621 0.621 0.54];
end

if exist(fullfile(Path,'Sinusoids.tif'),'file') ==2
    %Import Skeleton
    [Sinu] = Import_Tiff_3d(Path,'Sinusoids.tif');

    %Set Edge
    Edge = zeros(size(Sinu));
    Edge(:,:,1:3) = 1; Edge(:,:,end-2:end) = 1;
    Edge(:,1:3,:) = 1; Edge(:,end-2:end,:) = 1;
    Edge(1:3,:,:) = 1; Edge(end-2:end,:,:) = 1;
    Edge_idx = find(Edge);

    %Set CV
    [CV] = Import_Tiff_3d(Path,'CV_Mask.tif');
    [x,y,z] = size(CV);
    CV(isnan(CV)) = 0;
    if any(CV(:))
        [~,CV_I] = bwdist(CV);
    else
        CV_I = -1*ones(size(CV));
    end
    CV = imdilate(CV,Strel);
    CV_idx = find(CV);

    %Set PV
    [PV] = Import_Tiff_3d(Path,'PV_Mask.tif');
    PV(isnan(PV)) = 0;
    if any(PV(:))
        [~,PV_I] = bwdist(PV);
    else
        PV_I = -1*ones(size(PV));
    end
    PV = imdilate(PV,Strel);
    PV_idx = find(PV);

    %Graph Skeletons
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

    E = imdilate(Sinu,ones(3,3,3)) & ~ Sinu;
    F = C;
    F(~E) = 0;
    C(~Sinu) = 0;

    d = sqrt(2*0.621^2 + 0.54^2)/sqrt(3);
    for i = 1:numel(link)
       link(i).Radius = mean(D(F==i))*d; 
    end


    %% First Order Nodes
    % Determine Node types
    for j = 1:numel(node)
        if numel(intersect(node(j).idx,Edge_idx)) > 0
            node(j).Edge = 1;
        else
            node(j).Edge = 0;
        end
        if numel(intersect(node(j).idx,CV_idx)) > 0
            node(j).CV = 1;
        else
            node(j).CV = 0;
        end
        if numel(intersect(node(j).idx,PV_idx)) > 0
            node(j).PV = 1;
        else
            node(j).PV = 0;
        end
    end 
    
    %% First order links
    %Gather first order stats
    [x,y,z] = size(Skel);
    for j=1:numel(link)
         n1 = link(j).n1;
         n2 = link(j).n2;
         if node(n1).Edge==1 || node(n2).Edge ==1
             link(j).Edge = 1;
         else
             link(j).Edge = 0;
         end
         if node(n1).ep==1 || node(n2).ep ==1
             link(j).el = 1;
         else
             link(j).el = 0;
         end
         if node(n1).CV==1 || node(n2).CV ==1
             link(j).CV = 1;
         else
             link(j).CV = 0;
         end
         if node(n1).PV==1 || node(n2).PV ==1
             link(j).PV = 1;
         else
             link(j).PV = 0;
         end
         link(j).D_X = (node(n1).comx - node(n2).comx)*res(1);
         link(j).D_Y = (node(n1).comy - node(n2).comy)*res(2);
         link(j).D_Z = (node(n1).comz - node(n2).comz)*res(3);
         C_X = (node(n1).comx + node(n2).comx)/2;
         C_Y = (node(n1).comy + node(n2).comy)/2;
         C_Z = (node(n1).comz + node(n2).comz)/2;
         link(j).CX = C_X*res(1);
         link(j).CY = C_Y*res(2);
         link(j).CZ = C_Z*res(3);
         link(j).S_D = sqrt(link(j).D_X^2 + link(j).D_Y^2 + link(j).D_Z^2);
         
         %Information about distance and angle to CV
         idx = CV_I(round(C_X),round(C_Y),round(C_Z));
         if idx > 0
             %Distance
             [CV_X,CV_Y,CV_Z] = ind2sub([x,y,z],idx);
             CV_X = CV_X*res(1);
             CV_Y = CV_Y*res(2);
             CV_Z = CV_Z*res(3);
             link(j).D_CV_X =link(j).CX - CV_X;
             link(j).D_CV_Y =link(j).CY - CV_Y;
             link(j).D_CV_Z =link(j).CZ - CV_Z;
             link(j).D_CV = sqrt(link(j).D_CV_X^2 + link(j).D_CV_Y^2 + link(j).D_CV_Z^2);
             
             %Angle
             u = [link(j).D_X link(j).D_Y link(j).D_Z];
             v = [link(j).D_CV_X link(j).D_CV_Y link(j).D_CV_Z];
             Theta = min(acosd(dot(u,v)/(norm(u)*norm(v))),acosd(dot(-u,v)/(norm(-u)*norm(v))));
             link(j).CV_Theta = Theta;
         else %No CV in image
             link(j).D_CV_X = -1;
             link(j).D_CV_Y = -1;
             link(j).D_CV_Z = -1;
             link(j).D_CV = -1;
             link(j).CV_Theta = -1;
         end
         
         %Information about distance and angle to PV
         idx = PV_I(round(C_X),round(C_Y),round(C_Z));
         if idx > 0
             %Distance
             [PV_X,PV_Y,PV_Z] = ind2sub([x,y,z],idx);
             PV_X = PV_X*res(1);
             PV_Y = PV_Y*res(2);
             PV_Z = PV_Z*res(3);
             link(j).D_PV_X =link(j).CX - PV_X;
             link(j).D_PV_Y =link(j).CY - PV_Y;
             link(j).D_PV_Z =link(j).CZ - PV_Z;
             link(j).D_PV = sqrt(link(j).D_PV_X^2 + link(j).D_PV_Y^2 + link(j).D_PV_Z^2);
             
             %Angle
             u = [link(j).D_X link(j).D_Y link(j).D_Z];
             v = [link(j).D_PV_X link(j).D_PV_Y link(j).D_PV_Z];
             Theta = min(acosd(dot(u,v)/(norm(u)*norm(v))),acosd(dot(-u,v)/(norm(-u)*norm(v))));
             link(j).PV_Theta = Theta;
         else %No PV in image
             link(j).D_PV_X = -1;
             link(j).D_PV_Y = -1;
             link(j).D_PV_Z = -1;
             link(j).D_PV = -1;
             link(j).PV_Theta = -1;
         end        
         
         %Curved Distance estimate
         points = link(j).point;
         C_D = 0;
         for k = 2:numel(points)
             [x1,y1,z1] = ind2sub([x,y,z],points(k-1));
             [x2,y2,z2] = ind2sub([x,y,z],points(k));
             C_D =C_D + sqrt( ((x1-x2)*res(1))^2 + ((y1-y2)*res(2))^2 + ((z1-z2)*res(3))^2);
         end
         link(j).C_D = C_D;
         link(j).N_L = numel(points);
    end
    
    
end

