function Ca_Pre_Sim(Path)

%% Import Cells File and gather information from that
num = csvread(fullfile(Path,'Cell_Stats'));
Out = [num(:,1),num(:,4)*0.621,num(:,5)*0.621,num(:,6)*0.54,num(:,11),num(:,12)];

% Save Information
headers = {'Cell_Number','X','Y','Z','Distance_CV_Center','Distance_PV_Center'};
% xlswrite([Path 'Simulation'],headers,'Cells','A1');
% xlswrite([Path 'Simulation'],Out,'Cells',['A2:F' num2str(size(Out,1) + 1)]);
xlswrite(fullfile(Path,'Simulation_Headers'),headers,'Cells','A1');
csvwrite(fullfile(Path,'Simulation_Cells'),Out);

%% Set adjacency standards
num = csvread(fullfile(Path,'Cell_Adjacency'));
conn = num(:,3);
num = num(conn > quantile(conn,0.1),:);
%Alter rates
conn = boxcox(log(num(:,3)));
fd = fitdist(conn,'normal');
y = normcdf(conn,fd.mu,fd.sigma);
y = (y - min(y)); y = (y/max(y))*0.8 + 0.1;
num(:,3) = y;
headers = {'Cell_1','Cell_2','Connectivity_Value'};
xlswrite(fullfile(Path,'Simulation_Headers'),headers,'Simulation_Connections');
csvwrite(fullfile(Path,'Simulation_Connections'),num);

end

