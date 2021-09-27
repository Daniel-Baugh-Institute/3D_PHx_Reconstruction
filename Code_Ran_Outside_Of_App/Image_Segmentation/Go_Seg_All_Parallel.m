if ~exist('In_Path','var')
    In_Path = uigetdir;
    [Path_List,end_folders] = find_paths(In_Path);
end

if ~exist('Path_List','var')
    [Path_List,end_folders] = find_paths(In_Path);
end

addpath(genpath('..\'))

%Find the number of workers that we wish to use
if ~exist('N_Workers','var')
    nw = feature('numcores');
    [user,sys] = memory;
    if ~exist('M_Mem','var')
        M_Mem = sys.PhysicalMemory.Available;
    end
    mc = floor(M_Mem/(15*10^9));
    N_Workers = min(nw,mc);
end

delete(gcp('nocreate'))
parpool(N_Workers)

D = parallel.pool.DataQueue;
afterEach(D, @UpdateWaitbar);
N = numel(Path_List);
if N > 1
    multiWaitbar( 'All Data Sets',0);
end
pause(rand);
parfor i=1:N
    %Set Path
    Path = Path_List{i};
    EF = end_folders{i};
    send(D, {EF,0});
    if exist(fullfile(Path,'c1.tif'),'file') ==2 && exist(fullfile(Path,'c2.tif'),'file') ==2 && exist(fullfile(Path,'c3.tif'),'file') ==2 && exist(fullfile(Path,'c4.tif'),'file') ==2
        %% Architecture Segmentation
        Seg_Arch_P(Path);
        send(D, {EF,'Increment',0.5});
        %% Nuclei Segmentation
        Seg_Nuclei(Path);
        send(D, {EF,'Increment',0.25});
        %% Cell Segmentation
        Seg_Cells(Path);
        Seg_Sort_Hepa_Cells(Path);
        send(D, {EF,'Increment',0.25});
    else
        disp([Path ' does not contain the proper files'])
    end      % computation
    send(D, {'All Data Sets',1/N});
    send(D, {EF,'Close'});
end
multiWaitbar( 'CloseAll' );

function UpdateWaitbar(In)
    a = numel(In);
    if a == 2
        multiWaitbar( In{1},In{2});
    else
        multiWaitbar( In{1},In{2},In{3});
    end
end