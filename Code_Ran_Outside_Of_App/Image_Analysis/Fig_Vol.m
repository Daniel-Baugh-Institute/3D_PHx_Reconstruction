function [outputArg1,outputArg2] = Fig_Vol(DataVol)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
n = unique(DataVol(:,1));
xAS = zeros(size(n)); xAS_h = xAS; xAS_l = xAS;
xAB = xAS; xAB_h = xAS; xAB_l = xAS;
xAC = xAS; xAC_h = xAS; xAC_l = xAS;
for i = 1:numel(n)
    listAS = DataVol(DataVol(:,1) == n(i), 8);
    listAB = DataVol(DataVol(:,1) == n(i), 9);
    listAC = DataVol(DataVol(:,1) == n(i), 10);
    xAS(i) = median(listAS);
    xAS_h(i) = max(listAS);
    xAS_l(i) = min(listAS);
    xAB(i) = median(listAB);
    xAB_h(i) = max(listAB);
    xAB_l(i) = min(listAB);
    xAC(i) = median(listAC);
    xAC_h(i) = max(listAC);
    xAC_l(i) = min(listAC);
end

