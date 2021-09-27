function Ca_Sim(Path,varargin)
%set up pair relationships


%Initial Values
Cali = 0.2; %uM
Cati = 500; %uM
gi = 0.25;
IP3i = 0.1;
ri = 0.5;

%Parameters
A = 0.2;
B = 0.082;
D = 1.6;
E = 1;
F = 0.01;
H = 1.8;
k1 = 0.5;
k2 = 0.15;
k3 = 1;
kcat = 0.45;
kd = 0.34;
khr = 1;
kip3max = .9000;
kip3min = .7000;
krmax = 2;
krmin = 1;
L = 0.00015;
t_max = 1000;
dt = 0.1;

%Simplifications
r1 = kd + khr*H;

%Calculate Cell specific features
Cells = csvread(fullfile(Path,'Simulation_Cells'));
Dist = Cells(:,5);
Dist = Dist - min(Dist); Dist = Dist/max(Dist);
Dist(Dist > 0.7) = 0.7; Dist = Dist/max(Dist);
kr = (krmax - krmin)*(1 - Dist) + krmin;
kip3 = (kip3max - kip3min)*(1 - Dist) + kip3min;
%Calculate Connection Features
Conn = csvread(fullfile(Path,'Simulation_Connections'));
n_cell = size(Cells,1);

%Initiate Model With Gap
r = ones(n_cell,1)*ri;
ip3 = ones(n_cell,1)*IP3i;
g = ones(n_cell,1)*gi;
cat = ones(n_cell,1)*Cati;
cal = ones(n_cell,1)*Cali;

dr = zeros(n_cell,1);
dip3 = zeros(n_cell,1);
dg = zeros(n_cell,1);
dcat = zeros(n_cell,1);
dcal = zeros(n_cell,1);
int = 0;

%Simulation
Ca = cal;
tic
for t = dt:dt:t_max

    %Calculate chemical changes
    dr = kr.*(1 - r) - r1*r;
    dip3 = ((kip3.*H.*r)./(kcat + r))    .*      (1 - (k3./(cal+k3)))        - D .* ip3./2;
    dcal = (1 - g)    .*    (((A .*(ip3./2).^4)  ./  ((k1 + (ip3./2)).^4)) + L)   .*   (cat - cal)    -   B.*(cal.^2)./(k2^2 + cal.^2);
    dg = E * (cal.^4) .* (1 - g) - F;
    dcat = -dcal;
    
    %Calculate mass transfer of ip3
    tip3 = zeros(n_cell,1);
    for i = 1:size(Conn,1)
        T = Conn(i,3)*(ip3(Conn(i,2)) - ip3(Conn(i,1)));
        tip3(Conn(i,1)) = tip3(Conn(i,1)) + T;
        tip3(Conn(i,2)) = tip3(Conn(i,2)) - T;
    end
    r = r + dt* dr;
    ip3 = ip3 + dt * (dip3 + tip3);
    cal = cal + dt * dcal;
    g = g + dt * dg;
    cat = cat + dt * dcat;
    
    Ca = [Ca,cal];
end
t = 0:dt:t_max;
csvwrite(fullfile(Path,'Simulation_Gap.csv'),[t; Ca]);

%Initiate Model No Gap
r = ones(n_cell,1)*ri;
ip3 = ones(n_cell,1)*IP3i;
g = ones(n_cell,1)*gi;
cat = ones(n_cell,1)*Cati;
cal = ones(n_cell,1)*Cali;

dr = zeros(n_cell,1);
dip3 = zeros(n_cell,1);
dg = zeros(n_cell,1);
dcat = zeros(n_cell,1);
dcal = zeros(n_cell,1);
int = 0;

%Simulation
Ca = cal;
for t = dt:dt:t_max

    %Calculate chemical changes
    dr = kr.*(1 - r) - r1*r;
    dip3 = ((kip3.*H.*r)./(kcat + r))    .*      (1 - (k3./(cal+k3)))        - D .* ip3./2;
    dcal = (1 - g)    .*    (((A .*(ip3./2).^4)  ./  ((k1 + (ip3./2)).^4)) + L)   .*   (cat - cal)    -   B.*(cal.^2)./(k2^2 + cal.^2);
    dg = E * (cal.^4) .* (1 - g) - F;
    dcat = -dcal;
    
    r = r + dt* dr;
    ip3 = ip3 + dt * (dip3 + tip3);
    cal = cal + dt * dcal;
    g = g + dt * dg;
    cat = cat + dt * dcat;
    
    Ca = [Ca,cal];
end
t = 0:dt:t_max;
csvwrite(fullfile(Path,'Simulation_No_Gap.csv'),[t; Ca]);
toc

