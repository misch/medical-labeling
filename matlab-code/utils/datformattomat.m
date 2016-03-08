[dataset_folder] = getDatasetDetails(8);
for frame = 1:349
    frame_no = frame;
    frame_name = sprintf('%05d', frame);
    data_id = fopen([dataset_folder,'patch-descriptors_old/','test_data_frame_',frame_name,'.dat']);
    test_data = fread(data_id,'double');
    fclose(data_id);

    labels_id = fopen([dataset_folder,'patch-descriptors_old/','test_labels_frame_',frame_name,'.dat']);
    test_labels = fread(labels_id,'double');
    fclose(labels_id);

    test_data = reshape(test_data,size(test_labels,1),[]);


    disp('Creating frame descriptor...');
    frameDescriptor = struct('features',test_data,'groundTruthLabels', test_labels);
    disp('created frame descriptor');
    save([dataset_folder,'patch-descriptors/','frame_',sprintf('%05d', frame_no),'.mat'], 'frameDescriptor','-v7.3')

    disp(sprintf('%02d/%02d',frame,349));
end