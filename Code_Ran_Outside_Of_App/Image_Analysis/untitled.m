times = [0 12 24 48 72 96 168 672 2160];
DataCol = 5;
% DataCol2 = 12;
% DataCol2 = 13;
% DataCol2 = 9;
% DataCol = 8; DataCol2 = 9;


for u = 1:numel(times)
    A = DataBile(DataBile(:,1)==times(u) & DataBile(:,4)==1 ,DataCol);
%     A = Data2ndb(Data2ndb(:,1)==times(u),DataCol);
%     A = Data(Data(:,1)==times(u) & Data(:,10) == 0 & Data(:,11) == 0,6);
%     A = Vol(Vol(:,1)==times(u),8);
    UQ(u) = quantile(A,0.75);
    LQ(u) = quantile(A,0.25);
    M(u) = median(A);
    N(u) = numel(A);
end
CI = 1.57*(UQ - LQ)./sqrt(N);

figure
hold on
yyaxis left
errorbar(1:numel(N),M(:),CI(:),'.b');
plot(1:numel(N),M(:),'--b');
xticks([1:numel(N)]);
xticklabels(strsplit(num2str(times)));
% axis([0.5 9.5 10.5 13]); ylabel('Branch Length (uM)');
% axis([0.5 7.5 5.5 10]); ylabel('Branch Length (uM)');
% axis([0.5 7.5 5200 7400]); ylabel('Cell Volume (uM^3)');
% axis([0.5 7.5 0.15 0.18]); ylabel('Sinusoid Volume Percentage');

for u = 1:numel(times)
    A = DataBile1(DataBile1(:,1)==times(u) & DataBile1(:,2)==0 & DataBile1(:,3)==0 & DataBile1(:,4)==0 & DataBile1(:,5)==0,6);
%     A = Data2ndb(Data2ndb(:,1)==times(u),DataCol);
%     A = Data(Data(:,1)==times(u) & Data(:,10) == 0 & Data(:,11) == 0,6);
%     A = Vol(Vol(:,1)==times(u),8);
    UQ(u) = quantile(A,0.75);
    LQ(u) = quantile(A,0.25);
    M(u) = median(A);
    N(u) = numel(A);
end

yyaxis right
CI = 1.57*(UQ - LQ)./sqrt(N);
errorbar(1:numel(N),M(:),CI(:),'.r');
plot(1:numel(N),M(:),'--r');
xticks([1:numel(N)]);
xticklabels(strsplit(num2str(times)));
% axis([0.5 9.5 0.24 0.32]); title('Sinusoid Branch Length and Cell Contact Percentage'); ylabel('Cell Contact Percentage')
% axis([0.5 7.5 0.11 0.18]); title('Bile Branch Length and Cell Contact Percentage'); ylabel('Cell Contact Percentage')
% axis([0.5 7.5 0.5 0.64]); ylabel('Cell-to-cell Contact Percentage'); title('Cell Volume and Cell-to-Cell Contact Percentage')
% axis([0.5 7.5 0.02 0.05]); ylabel('Bile Volume Percentage'); title('Sinusoid and Bile Percentage of Total Volume')
xlabel('Time Post PhX (hr)');
