close all;
figure;
c_1= distances(training_set.labels == 1);
c_2= distances(training_set.labels == -1);
C = [c_1; c_2];
grp = [zeros(length(c_1),1);ones(length(c_2),1)];
boxplot(C,grp,'labels',{'positives','negatives'});


figure;
x = 0:300;
plot(x,exp(-x)); hold on;
plot(x,exp(-x/10)); hold on;
plot(x,exp(-x/20)); hold on;
plot(x,exp(-x/50));
legend('-x','-x/10','-x/20','-x/50');