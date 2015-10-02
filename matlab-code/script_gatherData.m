%% Define data paths and actions
dataset = 2;
dataset_folder = ['../data/Dataset',num2str(dataset),'/'];
video_filename = [dataset_folder,'Video.avi'];
frames_dir = [dataset_folder,'input-frames/'];

store_video_frames          =   false;
new_eye_tracking_positions  =   false;
show_eye_tracking_data      =   false;
extract_new_ROIs            =   false;
show_ROIs                   =   false;
preprocessing_ROIs          =   false;

%% Store video frames to .png images
if (store_video_frames)
    videoToFrames(video_filename, frames_dir);
end

%% Get Eye-Tracking information
if (new_eye_tracking_positions)
    framePositions = simulateEyeTracking(video_filename);
    save([dataset_folder,'framePositions.mat'],'framePositions');
else
    filename = [dataset_folder, 'framePositions.mat'];
    load(filename); % framePositions.mat contains a variable 'framePositions'
end

%% Show images with recorded mouse positions
if (show_eye_tracking_data)
    showImagesAndEyeTrackingData(video_filename, framePositions);
end

%% Get Regions of Interest (ROI's)
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
    if not(exist('negative_ROIs','var') & exist('positive_ROIs','var'))
        filename = [dataset_folder, 'raw_ROIs.mat'];
        load(filename); % raw_ROIs.mat contains a variables 'positive_ROIs' and 'negative_ROIs'
    end
end

%% Show ROIs
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

%% Preprocessing 
% each ROI is
%   - transformed into gray-scale
%   - resized to 32x32 pixels
%   - normalized in intensity (zero mean)

% each row represents a data point / ROI (1024 pixels)
if (preprocessing_ROIs)
    processed_ROIs = zeros(size(positive_ROIs,4)+size(negative_ROIs,4),32*32);
    labels = [ones(size(positive_ROIs,4),1); -ones(size(negative_ROIs,4),1)];
    
    num_pos_ROIs = size(positive_ROIs,4);
    h = waitbar(0,'Processing positive ROIs...');
    for i = 1:num_pos_ROIs
        ROI = imresize(rgb2gray(positive_ROIs(:,:,:,i)), [32 32]); % bicubic interpolation instead of bilinear that was used in the paper    
        ROI = ROI - mean(ROI(:));
        processed_ROIs(i,:) = ROI(:);
        waitbar(i/num_pos_ROIs);
    end
    close(h)

    h = waitbar(0,'Processing negative ROIs...');
    num_neg_ROIs = size(negative_ROIs,4);
    for i = 1:num_neg_ROIs
        ROI = imresize(rgb2gray(negative_ROIs(:,:,:,i)), [32 32]); % bicubic interpolation instead of bilinear that was used in the paper    
        ROI = ROI - mean(ROI(:));
        processed_ROIs(i+num_pos_ROIs,:) = ROI(:);
        waitbar(i/num_neg_ROIs);
    end
    close(h);

    save([dataset_folder,'processed_ROIs.mat'],'processed_ROIs', 'labels');
    
    % accessing all the positive ROIs:
    % processed_ROIs(labels > 0,:)
end