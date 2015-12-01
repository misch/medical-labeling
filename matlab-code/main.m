%% gather data

dataset = 8;

store_video_frames          =   false;
new_eye_tracking_positions  =   false;
show_eye_tracking_data      =   true;
create_video_with_dots      =   false;
extract_new_ROIs            =   false;
show_ROIs                   =   false;
preprocessing_ROIs          =   false;

options = [ store_video_frames,new_eye_tracking_positions,...
            show_eye_tracking_data,create_video_with_dots,...
            extract_new_ROIs,show_ROIs,preprocessing_ROIs];

% to just work with new recorded gaze positions, use this configurations:
% options = [false, false, false, false, true, false, true];

% Patches
% gatherData(dataset,store_video_frames,new_eye_tracking_positions,show_eye_tracking_data,create_video_with_dots,extract_new_ROIs,show_ROIs,preprocessing_ROIs)

% Superpixels
gatherDataSuperPixels(dataset, false,false,false)

%% classify
