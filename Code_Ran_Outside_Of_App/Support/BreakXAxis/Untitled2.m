FV=isosurface((S > 0)*255,1);
N=isonormals((S > 0)*255,FV.vertices);
FV.faces=[FV.faces(:,3) FV.faces(:,2) FV.faces(:,1)];
clear OBJ
OBJ.vertices = FV.vertices;
OBJ.vertices_normal = N;
OBJ.material = material;
OBJ.objects(1).type='g';
OBJ.objects(1).data='skin';
OBJ.objects(2).type='usemtl';
OBJ.objects(2).data='skin';
OBJ.objects(3).type='f';
OBJ.objects(3).data.vertices=FV.faces;
OBJ.objects(3).data.normal=FV.faces;
write_wobj(OBJ,'Sinu_Full.obj');