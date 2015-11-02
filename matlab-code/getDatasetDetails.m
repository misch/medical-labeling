function [dataset_folder, frames_dir, file_names, frame_height, frame_width, num_frames] = getDatasetDetails(dataset)
% This functions returns the details of the specified dataset
% Parameters:
%   - dataset:  A scalar to indicate which of the datasets should be chosen.
%               The datasets are assumed to be in ../data/Dataset[dataset].

dataset_folder = ['../data/Dataset',num2str(dataset),'/'];

frames_dir = [dataset_folder,'input-frames/'];
file_names = dir([frames_dir, '*.png']);

num_frames = size(file_names,1);

frame_height = 0;
frame_width = 0;

if length(file_names) > 1
    ref_frame = imread([frames_dir,file_names(1).name]);
    frame_height = size(ref_frame,1);
    frame_width = size(ref_frame,2);
end