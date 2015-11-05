% Write .nii file to frames
addpath('../NIfTI_20140122/');

dataset = 7;
[dataset_folder, frames_dir] = getDatasetDetails(dataset);

patient_file = [dataset_folder,'Sub04R/Patient_T2.nii'];
% patient_file = [dataset_folder, 'Labyrinth.nii'];
data = load_untouch_nii(patient_file);

img = double(data.img);
img = img - min(img(:));
img = img./max(img(:));

ground_truth_file = [dataset_folder,'Sub04R/GTVT2.nii'];
% ground_truth_file = [dataset_folder, 'Labyrinth-mask.nii'];
gt_data = load_untouch_nii(ground_truth_file);
mask = double(gt_data.img);


mkdir(frames_dir);

start_frame = 12;
resize_scale = 4;

for i = start_frame:size(img,3)
    frameNr = sprintf('%05d', i-start_frame+1);
    filename = [frames_dir,'frame_',frameNr,'.png'];
    current_img = img(:,:,i);
    current_img = imresize(current_img,resize_scale,'nearest');
    imwrite(current_img,filename);
end

gt_folder = [dataset_folder,'ground_truth-frames/'];
mkdir(gt_folder);
for i = 1:size(mask,3)
    frameNr = sprintf('%05d', i-start_frame+1);
    filename = [gt_folder,'frame_',frameNr,'.png'];
    current_gt = mask(:,:,i);
    current_gt = imresize(current_gt,resize_scale,'nearest');
    imwrite(current_gt,filename);
end
