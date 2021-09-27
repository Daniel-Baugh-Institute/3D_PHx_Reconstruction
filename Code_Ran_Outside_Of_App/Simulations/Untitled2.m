
A = unique([unique(Cells(:,:,109)); unique(Cells(1,:,:)); unique(Cells(:,1,:))]);
A(A<1) = [];
R = zeros(1024,1024,109);
for i = 1:numel(A)
    AMax(i) = max(SG(i,:));
    AMin(i) = min(SG(i,:));
end

% B = unique(Cells(:));
% B(B<1) =[];
% R = zeros(1024,1024,109);
% for i = 1:numel(B)
%     BMax(i) = max(SG(i,:));
%     BMin(i) = min(SG(i,:));
% end

axes('Units', 'normalized', 'Position', [0 0 1 1])

writerObj = VideoWriter('Ca2+_Waves_3d.avi');
writerObj.FrameRate = 30;
open(writerObj)
for j = 8501:5:10001
    idx = j;
    for i = 1:numel(A)
        R(Cells == A(i)) = (SG(A(i),idx)-AMin(i))/(AMax(i)-AMin(i));
    end
    pause(0.001)
%     imagesc(R)
%     s = surf(X,Y,R);
%     s.EdgeColor = 'none';
%     zlim([0 1])
%     for i = 1:numel(B)zsli
%         R(Cells == B(i)) = (SG(B(i),idx)-BMin(i))/(BMax(i)-BMin(i));
%     end 
    h = slice(X,Y,Z,R,xslice,yslice,zslice);
    for k = 1:numel(h); set(h(k),'edgecolor','none'); end
    hAxes = gca;
    hAxes.DataAspectRatio = [0.621,0.621,0.54];
    hAxes.YLim = [0 1024];
    hAxes.XLim = [0 1024];
    az = -37.5; el = 30;
%     vol3d('CData',R,'alpha',R);
    view(az,el)
    caxis([0 1])
    axis off
    f = getframe(hAxes);
    writeVideo(writerObj, f);
end

close(writerObj);