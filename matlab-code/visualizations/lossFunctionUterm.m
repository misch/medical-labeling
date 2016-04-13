% Plots different versions of the U-term of the suggeted PU-loss function
[Z,P] = meshgrid(-2:0.1:2, 0:0.1:1);
L = P .* exp(-Z) + (1-P).*exp(Z);

surf(Z,P,L)
xlabel('margin')
ylabel('p(correct label)')
zlabel('U-term')
colormap winter

%%
z = -5:0.001:5;
probabilities = [0,0.5,0.6,0.7,0.8,0.9,1];
f = figure;

% for p = probabilities
%     hold on; plot(z,p.*exp(-z) + (1-p).*exp(z));
% end
hold on; plot(z,probabilities(1).*exp(-z) + (1-probabilities(1)).*exp(z),'Color',[0 0 0.6], 'LineWidth',2);
hold on; plot(z,probabilities(2).*exp(-z) + (1-probabilities(2)).*exp(z),'Color',[0.4 0.4 1.0],'LineWidth',2);
hold on; plot(z,probabilities(3).*exp(-z) + (1-probabilities(3)).*exp(z),'Color',[0.6980 0.4 1], 'LineWidth',2);
hold on; plot(z,probabilities(4).*exp(-z) + (1-probabilities(4)).*exp(z),'Color',[1 0.2 0.2],'LineWidth',2);
hold on; plot(z,probabilities(5).*exp(-z) + (1-probabilities(5)).*exp(z),'Color',[1 0.502 0],'LineWidth',2);
hold on; plot(z,probabilities(6).*exp(-z) + (1-probabilities(6)).*exp(z),'Color',[0.8 0.8 0],'LineWidth',2);
hold on; plot(z,probabilities(7).*exp(-z) + (1-probabilities(7)).*exp(z),'Color',[0 0.47 0],'LineWidth',2);
grid on;
xlabel('margin','FontSize',14); ylabel('U-term','FontSize',14);
axis([-5 5 0 25]);

lh = legend( sprintf('p = %0.2f',probabilities(1)),...
        sprintf('p = %0.2f',probabilities(2)),...
        sprintf('p = %0.2f',probabilities(3)),...
        sprintf('p = %0.2f',probabilities(4)),...
        sprintf('p = %0.2f',probabilities(5)),...
        sprintf('p = %0.2f',probabilities(6)),...
        sprintf('p = %0.2f',probabilities(7)),...
        'Location','north');
lh.FontSize = 14;
saveToPDFWithoutMargins(f,'loss_function_different_p.pdf');