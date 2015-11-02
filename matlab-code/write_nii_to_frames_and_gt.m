% Write .nii file to frames
addpath('../NIfTI_20140122/');

dataset = 7;
[dataset_folder, frames_dir] = getDatasetDetails(dataset);

patient_file = [dataset_folder,'Sub04R/Patient_T2.nii'];
data = load_untouch_nii(patient_file);
img = im2double(data.img);
img = img./max(img(:));

ground_truth_file = [dataset_folder,'Sub04R/GTVT2.nii'];
gt_data = load_untouch_nii(ground_truth_file);
mask = double(gt_data.img);


mkdir(frames_dir);

start_frame = 12;

for i = start_frame:size(img,3)
    frameNr = sprintf('%05d', i-start_frame+1);
    filename = [frames_dir,'frame_',frameNr,'.png'];
    imwrite(imresize(img(:,:,i),4,'nearest'),filename);
end

gt_folder = [dataset_folder,'ground-truth-frames/'];
mkdir(gt_folder);
for i = 1:size(mask,3)
    frameNr = sprintf('%05d', i-start_frame+1);
    filename = [gt_folder,'frame_',frameNr,'.png'];
    imwrite(imresize(mask(:,:,i),4,'nearest'),filename);
end
