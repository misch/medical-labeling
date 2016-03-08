function writeNiiToFrames(input_filename,frames_dir,scale)
    % Write .nii file to frames
    nifti_path = '../NIfTI_20140122/';

    addpath(nifti_path);

    if (exist(frames_dir,'dir') == 0)
       mkdir(frames_dir) ;
    end
    
    data = load_untouch_nii(input_filename);

    img = double(data.img);
    img = img - min(img(:));
    img = img./max(img(:));

    start_frame = 1;

    for i = start_frame:size(img,3)
        frameNr = sprintf('%05d', i-start_frame+1);
        filename = [frames_dir,'frame_',frameNr,'.png'];
        current_img = img(:,:,i);
        current_img = imresize(current_img,scale,'nearest');
        imwrite(current_img,filename);
    end

    rmpath(nifti_path);