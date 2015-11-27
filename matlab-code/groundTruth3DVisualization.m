
gt_dir = uigetdir('../data')

files = dir([gt_dir,'/*.png']);

new_size = 1;
image = imresize(im2double(imread([gt_dir,'/',files(1).name])),new_size);
volume = zeros(size(image,1),size(image,2),length(files));
grad_vol = volume;

for i = 1:length(files)
    image = imresize(im2double(imread([gt_dir,'/',files(i).name])),new_size);
    if size(image,3) == 3
        image = image(:,:,1);
    end
    volume(:,:,i) = image;
    [grad1, grad2] = gradient(image);
    grad_vol(:,:,i) = sqrt(grad1.^2 + grad2.^2);
    clear grad1; clear grad2;
end


[r,c,v] = ind2sub(size(volume),find(volume > 0));
% [r, c, v] = ind2sub(size(grad_vol),find(grad_vol > 0));

skip = 1;
scatter3(r(1:skip:end),c(1:skip:end),v(1:skip:end),5,c(1:skip:end),'filled');