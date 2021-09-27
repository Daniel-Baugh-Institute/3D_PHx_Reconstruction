function [Ca,Time] = Ca_Signaling(varargin)

%% Create Input Parser, this is how you can set default values for all of the signaling, and adjust from inputs
p = inputParser;
%Gap junctions on ==1, off == 0
addParameter(p,'Gap',1,@(x) isnumeric(x) && isscalar(x) && ((x == 0) || (x == 1) ))

%Gap Conectivity
addParameter(p,'Conn','constant',@(x) isstring(x) && any(strcmpi({'constant','custom'},x)))
addParameter(p,'Conn_Custom',[])
addParameter(p,'Gap_Value',0.5,@(x) isnumeric(x) && isscalar(x) && ((x == 0) || (x == 1) ))
%number of cells
addParameter(p,'Cells',8,@(x) isnumeric(x) && isscalar(x) && (x > 0));

%Parameters that are consistent across all cells
addParameter(p,'A',0.2,@(x) isnumeric(x) && (x > 0))
addParameter(p,'B',0.082,@(x) isnumeric(x) && (x > 0))
addParameter(p,'D',1.6,@(x) isnumeric(x) && (x > 0))
addParameter(p,'E',1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'F',0.01,@(x) isnumeric(x) && (x > 0))
addParameter(p,'H',1.8,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k1',0.5,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k2',0.15,@(x) isnumeric(x) && (x > 0))
addParameter(p,'k3',1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'kcat',0.45,@(x) isnumeric(x) && (x > 0))
addParameter(p,'kd',0.34,@(x) isnumeric(x) && (x > 0))
addParameter(p,'khr',1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'L',0.00015,@(x) isnumeric(x) && (x > 0))

%Time parameters
addParameter(p,'t_max',1000,@(x) isnumeric(x) && (x > 0))
addParameter(p,'dt',0.1,@(x) isnumeric(x) && (x > 0))

%kr and kip3 change based on cell location between 
%kr
addParameter(p,'kr_fit','linear',@(x) (isstring(x) && strcmpi('linear',x)) | ~isstring(x)); %,'constant','exp' would be good additions
addParameter(p,'kr_max',1,@(x) isnumeric(x) && (x > 0))
addParameter(p,'kr_min',0.7,@(x) isnumeric(x) && (x > 0))

%kip3
addParameter(p,'kip3_fit','linear',@(x) (isstring(x) && strcmpi('linear',x)) | ~isstring(x)); %,'constant','exp' would be good additions
addParameter(p,'kip3_max',0.9,@(x) isnumeric(x) && (x > 0))
addParameter(p,'kip3_min',0.7,@(x) isnumeric(x) && (x > 0))

%Initial Values
addParameter(p,'Cal_Init',0.2)
addParameter(p,'Cat_Init',500)
addParameter(p,'G_Init',0.25)
addParameter(p,'Ip3_Init',0.1)
addParameter(p,'r_Init',0.5)

parse(p,varargin{:})

%% Initialize Parameters
Gap = p.Results.Gap;
n_cell = p.Results.Cells;

%Fixed Params
A = p.Results.A;
B = p.Results.B;
D = p.Results.D;
E = p.Results.E;
F = p.Results.F;
H = p.Results.H;
k1 = p.Results.k1;
k2 = p.Results.k2;
k3 = p.Results.k3;
kcat = p.Results.kcat;
kd = p.Results.kd;
khr = p.Results.khr;
L = p.Results.L;

%simplification
r1 = kd + khr*H;

%time params
t_max = p.Results.t_max;
dt = p.Results.dt;

%kr Initialize
if strcmpi(p.Results.kr_fit,'linear')
    dkr = (p.Results.kr_max - p.Results.kr_min)/(p.Results.Cells - 1);
    kr = (p.Results.kr_min:dkr:p.Results.kr_max)';
else
    kr = p.Results.kr_fit';
%... can add the other cases here if you want, exp would be a good one
end

%kip3 Initialize
if strcmpi(p.Results.kip3_fit,'linear')
    dip3 = (p.Results.kip3_max - p.Results.kip3_min)/(p.Results.Cells - 1);
    kip3 = (p.Results.kip3_min:dip3:p.Results.kip3_max)';
else
    kip3 = p.Results.kip3_fit';
%... can add the other cases here if you want, exp would be a good one
end

%Initiate Model Values
if numel(p.Results.r_Init) == 1
    r = ones(n_cell,1)*p.Results.r_Init;
else
    r = p.Results.r_Init';
end

if numel(p.Results.Ip3_Init) == 1
    ip3 = ones(n_cell,1)*p.Results.Ip3_Init;
else
    ip3 = p.Results.Ip3_Init';
end
if numel(p.Results.G_Init) == 1
    g = ones(n_cell,1)*p.Results.G_Init;
else
    g = p.Results.G_Init';
end
if numel(p.Results.Cat_Init) == 1
    cat = ones(n_cell,1)*p.Results.Cat_Init;
else
    cat = p.Results.Cat_Init';
end
if numel(p.Results.Cal_Init) == 1
    cal = ones(n_cell,1)*p.Results.Cal_Init;
else
    cal = p.Results.Cal_Init';
end

%Create Connectivity Network
Conn = [];
for i = 2:1:p.Results.Cells
    c_list = [i-1, i];
    if strcmpi(p.Results.Conn,'constant') 
        c_list(3) = p.Results.Gap_Value;
    else
        c_list(3) = p.Results.Conn_Custom(i-1);
    end
    Conn = [Conn; c_list];
end

%% Simulate 
Ca = cal;
Time = 0:dt:t_max;

for t = dt:dt:t_max

    %Calculate chemical changes
    dr = kr.*(1 - r) - r1*r;
    dip3 = ((kip3.*H.*r)./(kcat + r))    .*      (1 - (k3./(cal+k3)))        - D .* ip3./2;
    dcal = (1 - g)    .*    (((A .*(ip3./2).^4)  ./  ((k1 + (ip3./2)).^4)) + L)   .*   (cat - cal)    -   B.*(cal.^2)./(k2^2 + cal.^2);
    dg = E * (cal.^4) .* (1 - g) - F;
    dcat = -dcal;
    
    %Calculate mass transfer of ip3
    tip3 = zeros(n_cell,1);
    if Gap == 1
        for i = 1:size(Conn,1)
            T = Conn(i,3)*(ip3(Conn(i,2)) - ip3(Conn(i,1)));
            tip3(Conn(i,1)) = tip3(Conn(i,1)) + T;
            tip3(Conn(i,2)) = tip3(Conn(i,2)) - T;
        end
    end
    r = r + dt* dr;
    ip3 = ip3 + dt * (dip3 + tip3);
    cal = cal + dt * dcal;
    g = g + dt * dg;
    cat = cat + dt * dcat;
    
    Ca = [Ca,cal];
end

end

