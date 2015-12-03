% Prepare the data


% todo: GUI
video = 0;
nifti = 1;

input_type = 1; % 0 = video, 1 = .nii

% video input: write video frames
if (input_type == video)
    disp('Choose input video (.avi)');
    [filename, path] = uigetfile('../data/*.avi');
    if(filename ~= 0)
        videoToFrames([path,filename], [path,'input-frames/']);
    else
        disp('No input file chosen. Aborting script...')
        return
    end
    
    disp('Choose ground-truth file (.avi)');
    [filename, path] = uigetfile('../data/*.avi');
    if(filename ~= 0)
        videoToFrames([path,filename], [path,'ground_truth-frames/']);
    end
end

% nifti input: write 3D slices to frames and create video
if (input_type == nifti)
    disp('Choose input file (.nii)');
    [filename, path] = uigetfile('../data/*.nii');
    
    if(filename ~= 0)
        writeNiiToFrames([path,filename],[path,'input-frames/'],4);
    else
        disp('No input file chosen. Aborting script...')
        return
    end 
   
    video_filename = [path,'video.avi'];
    writeFramesToVideo([path,'input-frames/'], video_filename, 10);
    
    disp('Choose ground truth file (.nii)');
    [filename, path] = uigetfile('../data/*.nii');
    if(filename ~= 0)
        writeNiiToFrames([path,filename],[path,'ground_truth-frames/'],4);
    end 
end


patches = 0;
superpixels = 1;

representations = [0 1];

if any(representations==superpixels)
    % store superpixels:
    disp('Choose folder with input frames');
    frames_dir = [uigetdir('../data/'),'/'];

    disp('Choose folder to store superpixel descriptors');
    superpixel_dir = [uigetdir('../data/'),'/'];

    createTestData_superpixels(frames_dir,superpixel_dir,5)
end


% Check whether eye-tracking file is there.
filename = [path, 'framePositions.csv'];

if (exist(filename,'file') == 0)
       disp('Please add a file framePositions.csv containing the gaze observations!' );
end

% todo: should I also assemble the training data here?
%   + pro: all in one - if training data is once created, should be re-used
%   with different classifiers etc.
%
%   - con: will be a major part of the project to acquire sensible training
%   data and might therefore change rather often.

% 4. Rewrite training and classification script to work on these data.