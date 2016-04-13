%% Given some patches, show them without big margins around them.

addpath('../subtightplot/');
subplottight = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.01 0.01], [0.01 0.01]);
figure;
for ii = 1:72
   subplottight(8,9,ii);
   imshow(patches(:,:,:,ii));
end