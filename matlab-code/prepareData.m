% Prepare the data

% todo: GUI
video = 0;
nifti = 1;

input_type = 1; % 0 = video, 1 = .nii

% video input: write video frames
if (input_type == video)
    disp('Choose input file');
    [filename, path] = uigetfile('../data/*.avi');
    if(filename ~= 0)
        videoToFrames([path,filename], [path,'input-frames/']);
    end
    
    disp('Choose ground-truth file');
    [filename, path] = uigetfile('../data/*.avi');
    if(filename ~= 0)
        videoToFrames([path,filename], [path,'ground_truth-frames/']);
    end
end

% nifti input: write 3D slices to frames and create video
if (input_type == nifti)
    disp('Choose input file');
    [filename, path] = uigetfile('../data/*.nii');
    if(filename ~= 0)
        writeNiiToFrames([path,filename],[path,'input-frames/'],4);
    end 
   
    video_filename = [path,'video.avi'];
    writeFramesToVideo([path,'input-frames/'], video_filename, 10);
    
    disp('Choose ground truth file');
    [filename, path] = uigetfile('../data/*.nii');
    if(filename ~= 0)
        writeNiiToFrames([path,filename],[path,'ground_truth-frames/'],4);
    end 
end


% todo: If the eye-tracking file is not yet there, tell the user to create it.

% 3. Save the image descriptors to folders
%   - preprocessed patches, maybe
%   - superpixel features
% 0 - patches
% 1 - superpixels

representations = [0 1];




% 4. Rewrite training and classification script to work on these data.