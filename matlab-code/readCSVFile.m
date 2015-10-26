%% Test-script for loading eye-tracking data
function framePositions = readCSVFile(filename);

    fid = fopen(filename);
    out = textscan(fid,'%f%f%f%f%f','delimiter',';');
    fclose(fid);

    framePositions = [out{4} out{5}];