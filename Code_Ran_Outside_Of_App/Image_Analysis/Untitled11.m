n = 200;
Bins = zeros(size(Data1st,1),1);
Bin_avg_sd = zeros(n,1);
for i = 1:1:n; Bins(Data1st(:,7) < i & Data1st(:,7) >= i - 1 & Data1st(:,7) > 20) = i; end
figure
hold on
times = [0 12 24 48 96 168 2160];
mee = [];
for j = times
    for i = 1:1:n 
        Bin_avg_sd(i) = mean(Data1st(Bins == i & Data1st(:,1) == j,5)); 
    end
    x = 1:1:n;
    nan_list = find(~isnan(Bin_avg_sd));
    mee = [mee {[num2str(j) 'hr  corr = ' num2str(corr(Bin_avg_sd(nan_list),x(nan_list)'))]}];
    plot(Bin_avg_sd)
end
legend(mee)