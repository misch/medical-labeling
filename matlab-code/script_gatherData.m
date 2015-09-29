
%% Define dataset and folders where to find them.
dataset = 2;

dataset_folder = ['../data/Training/Dataset',num2str(dataset),'/'];

video_filename = [dataset_folder,'Video.avi'];
frames_dir = [dataset_folder,'input-frames/'];

%% Store video frames to .png images
% videoToFrames(video_filename, frames_dir);

%% Get Eye-Tracking information
new_eye_tracking_positions = false;

if (new_eye_tracking_positions)
    framePositions = simulateEyeTracking(video_filename);
    save([dataset_folder,'framePositions.mat'],'framePositions');
else
    filename = [dataset_folder, 'framePositions.mat'];
    load(filename); % framePositions.mat contains a variable 'framePositions'
end

%% Show images with recorded mouse positions
showImagesAndEyeTrackingData(video_filename, framePositions);

%% Extract Regions of Interest (ROI's)
extract_new_ROIs = false;

if (extract_new_ROIs)
    file_names = dir([frames_dir, '\*.png']);
    num_frames = length(file_names);

    positive_ROIs = zeros(128,128,3,num_frames);
    negative_ROIs = zeros(128,128,3,num_frames*2); % for each frame, define 2 negative ROIs

    h = waitbar(0,'Extracting ROIs...');
    for i = 1:num_frames
        image_file = [frames_dir, file_names(i).name];
        image = im2double(imread(image_file));

        positive_ROIs(:,:,:,i) = getPositiveROI(image, framePositions(i,:));
        negative_ROIs(:,:,:,2*i:2*i+1) = getNegativeROIs(image,framePositions(i,:));
        waitbar(i/num_frames);
        
        % discard zero-ROIs
        positive_ROIs = positive_ROIs(:,:,:,any(any(any(positive_ROIs))));
        negative_ROIs = negative_ROIs(:,:,:,any(any(any(negative_ROIs))));

        % save ROIs to variable
        save([dataset_folder,'raw_ROIs.mat'],'positive_ROIs', 'negative_ROIs');
    end
    close(h);
else
    filename = [dataset_folder, 'raw_ROIs.mat'];
    load(filename); % raw_ROIs.mat contains a variables 'positive_ROIs' and 'negative_ROIs'
end



%% Show ROIs
show_ROIs = false;

if (show_ROIs)
    figure(1);
    for i = 201:300
        subplot(10,10,i-200);
        imshow(positive_ROIs(:,:,:,i));
    end

    figure(2);
    for i = 201:300
        subplot(10,10,i-200);
        imshow(negative_ROIs(:,:,:,i));
    end
end

