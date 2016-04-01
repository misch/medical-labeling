clc;
dataset = 8;

[dataset_folder,~, ~, frame_height, frame_width] = getDatasetDetails(dataset);

gt_folder = [dataset_folder,'ground_truth-frames/'];

file_names = dir([gt_folder, '*.png']);
area = zeros(1,length(file_names));
%%
for ii = 1:length(file_names);
    filename = [gt_folder,file_names(ii).name];
    test = getGrayScaleImage(filename);
    area(ii) = sum(sum(test>0.1));
end

avg_area = mean(area(area>0))
relative_avg_area = avg_area / (frame_width*frame_height)
%%

% subplot(2,1,1);
f = figure; hold on;
% plot(area/(frame_width*frame_height),'k','LineWidth',3); axis([1 1125 0 0.2]);
plot(area,'b','LineWidth',3); xlim([1 length(file_names)]);
hold on; plot(1:length(file_names),avg_area*ones(1,length(file_names)),'b--','LineWidth',2);
% title('eye tumor size','FontSize',18,'FontWeight','bold');
xlabel('frame','FontSize',18,'FontWeight','bold');
ylabel('object size [#px]','FontSize',18,'FontWeight','bold');
box off;

saveToPDFWithoutMargins(f,'test.pdf');
% legendies(1) = plot(NaN,NaN,'b','LineWidth',3);
% legendies(2) = plot(NaN,NaN,'r','LineWidth',3);
% legendies(3) = plot(NaN,NaN,'k','LineWidth',3); % black --> not on object
% le = legend(legendies,'instrument','eye tumor', 'cochlea','Location','north');
% le.FontSize = 18;
% saveToPDFWithoutMargins(f,'size_instrument.pdf');
% subplot(2,1,2);
% 
% title('% positives of frame');

%%
f2 = figure; hold on;
% plot(area/(frame_width*frame_height),'k','LineWidth',3); axis([1 1125 0 0.2]);
plot(gradient(area),'b','LineWidth',3); xlim([1 length(file_names)]);
% title('eye tumor size','FontSize',18,'FontWeight','bold');
xlabel('frame','FontSize',18,'FontWeight','bold');
ylabel('object size [#px]','FontSize',18,'FontWeight','bold');
box off;

saveToPDFWithoutMargins(f,'test.pdf');
