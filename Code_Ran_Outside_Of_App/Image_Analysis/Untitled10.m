times = [0 12 24 48 72 96 168 672 2160];
figure
hold on
mee = [];
for i = times
    y = Data2nd(Data2nd(:,1) == i & Data2nd(:,4)==1 ,6);
    mee = [mee {[num2str(i) ' mean = ' num2str(mean(y))]}];
    [f,xi] = ksdensity(y,'Support','positive');
    plot(xi,f)
end

legend(mee)