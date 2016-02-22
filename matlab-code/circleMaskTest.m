width=400; height=256;
c = [100 50];
r = 20;

tic;
mask = bsxfun(@plus, ((1:width) - c(2)).^2, (transpose(1:height) - c(1)).^2) < r^2;
toc;

figure
imshow((mask));