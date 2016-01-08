function [] = plotskinlayers(imgpath)
% Given path to an image, performs skin thickness analysis and plots skin
% layer points over original image

% original_img = imread(imgpath);
original_img = dicomread(imgpath);

% Resizing 
resized_img = imresize(original_img, 1000/size(original_img,2));

% Processing
skin_info = skin(resized_img);

% Extract breast boundary points
edge_col = skin_info(:,1);
edge_row = skin_info(:,2);

% Extract normal vectors
newdirs = skin_info(:,3:4);

% Extract thickness
thickness = skin_info(:,5);

figure;
imshow(resized_img,[]);
hold on;

% % Plot thickness prior outlier truncation
% new_skin_x = edge_col + thickness.*newdirs(:,1);
% new_skin_y = edge_row + thickness.*newdirs(:,2);
% scatter(new_skin_x, new_skin_y,'.');

% Plot thickness after Outlier truncation
% Repeated outlier truncation
for ii = 1:4
   [thickness, outliers] = thickness_smoothing(thickness);
end
new_skin_x = edge_col + thickness.*newdirs(:,1);
new_skin_y = edge_row + thickness.*newdirs(:,2);

% Plot breast boundary points
plot(edge_col,edge_row,'.');

% Plot internal skin layer points
scatter(new_skin_x(outliers == 1), new_skin_y(outliers == 1),'.');
scatter(new_skin_x(outliers == 0), new_skin_y(outliers == 0),'.');

% quiver(edge_col,edge_row,newdirs(:,1),newdirs(:,2));
% legend('Internal w/o outlier truncation', 'External','Internal w/ outlier truncation');
% savefig([imgpath '_labeled.fig']);
% figure;
% plot(abs(thickness));
% xlabel('Along breast boundary');
% ylabel('Skin Thickness (in pixels)');
title(['Average Skin Thickness = ' num2str(mean(abs(thickness)))]);
% savefig([imgpath '_thickness.fig']);
% pause;
% close all;
end