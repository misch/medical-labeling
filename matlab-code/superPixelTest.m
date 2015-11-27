% load 'test_img';
test_img = img;
lab_img = img;
if (size(lab_img,3) == 3)
    lab_img = rgb2lab(lab_img);
end

superpixel_size = round(min([size(lab_img,1), size(lab_img,2)]) / 11.5);
regularizer = 0.05;

super = double(getSuperPixels(single(lab_img), superpixel_size, regularizer));
grad_lab = repmat(imgradient(super),1,1,size(test_img,3));

segmented_lab = grad_lab + test_img;
figure;
imshow([segmented_lab; grad_lab]);


% Extract only 1 superpixel
% mask = repmat((super_lab == 55),1,1,size(test_img,3)); imshow(test_img.*mask);

% get patch at specific position

% position = [100 201]; % [vertical, horizontal] (starting from top left)
% mask = repmat((super_lab == super_lab(position(1),position(2))),1,1,size(test_img,3)); imshow(test_img.*mask);

