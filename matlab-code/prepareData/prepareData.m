% Prepare the data
choice = questdlg(  'Do you wanna store the data to input-frames?',... % question
                    'generate input-frames (.png)',... % title
                    'Yes, generate the .png files', 'No, they already exist',... % answers
                    'Yes, generate the .png files'); % default answer

if (choice(1) == 'Y')
    
    choice = questdlg(  'What kinda data?',... % question
                    'data',... % title
                    'Video (.avi)', 'NIfTI (.nii)','Cancel',... % answers
                    'NIfTI (.nii)'); % default answer
    
    if strcmp(choice(1:5), 'Video')
        disp('Choose input video (.avi)');
        [filename, data_path] = uigetfile('../data/*.avi');
        if(filename ~= 0)
            videoToFrames([data_path,filename], [data_path,'input-frames/']);
        else
            disp('No input file chosen. Aborting script...')
            return
        end

        disp('Choose ground-truth file (.avi)');
        [filename, data_path] = uigetfile('../data/*.avi');
        if(filename ~= 0)
            videoToFrames([data_path,filename], [data_path,'ground_truth-frames/']);
        end

    % nifti input: write 3D slices to frames and create video
    elseif strcmp(choice(1:5), 'NIfTI')
        disp('Choose input file (.nii)');
        [filename, data_path] = uigetfile('../data/*.nii');

        if(filename ~= 0)
            writeNiiToFrames([data_path,filename],[data_path,'input-frames/'],4);
        else
            disp('No input file chosen. Aborting script...')
            return
        end 

        disp('Choose ground truth file (.nii)');
        [filename, data_path] = uigetfile('../data/*.nii');
        if(filename ~= 0)
            writeNiiToFrames([data_path,filename],[data_path,'ground_truth-frames/'],4);
        end
    else
        disp('Aborting script...');
        return
    end
end

choice = questdlg(  'What kind of descriptor do you wanna generate?',... % question
                    'Generate descriptor',... % title
                    'superpixels','patches','cancel',... % answers
                    'superpixels'); % default answer
                    
if strcmp(choice,'superpixels') % superpixel features
    disp('Choose folder with input frames');
    frames_dir = [uigetdir('../data/')];
    if (frames_dir == 0)
        disp('No directory chosen. Aborting script...');
        return
    else
        frames_dir = [frames_dir,'/'];
    end

    disp('Choose folder to store superpixel descriptors');
    superpixel_dir = uigetdir('../data/');
    
    if (superpixel_dir == 0)
        disp('No directory chosen. Aborting script...');
        return
    else
        superpixel_dir = [superpixel_dir, '/'];
    end

    createTestData_superpixels(frames_dir,superpixel_dir,101,300,16.5);
elseif strcmp(choice,'patches')
    disp('Choose folder with input frames');
    frames_dir = [uigetdir('../data/')];
    if (frames_dir == 0)
        disp('No directory chosen. Aborting script...');
        return
    else
        frames_dir = [frames_dir,'/'];
    end

    
    disp('Choose folder with ground truth frames');
    gt_dir = [uigetdir('../data/')];
    if (gt_dir  == 0)
%         disp('No directory chosen. Aborting script...');
%         return
    else
        gt_dir = [gt_dir ,'/'];
    end

    
    
    disp('Choose folder to store patch descriptors');
    descriptor_dir = [uigetdir('../data/'),'/'];
    
    if (descriptor_dir == 0)
        disp('No directory chosen. Aborting script...');
        return
    else
        descriptor_dir = [descriptor_dir, '/'];
    end

    createTestData_patches(frames_dir,descriptor_dir,101,gt_dir);
else
    return
end