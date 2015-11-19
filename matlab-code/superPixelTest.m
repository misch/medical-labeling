load 'test_img';


test_img = test_img;

lab_img = rgb2lab(test_img);

size = 50;
regularizer = 1000;

super = double(getSuperPixels(single(test_img), size, regularizer));
super_lab = double(getSuperPixels(single(lab_img), size, regularizer));


grad_img = repmat(imgradient(super),1,1,3);
grad_lab = repmat(imgradient(super_lab),1,1,3);

segmented_img = grad_img + test_img;
segmented_lab = grad_lab + test_img;

imshow([segmented_img, segmented_lab; grad_img ,grad_lab]);