function framePositions = readCSVFile(filename);
% This function reads the CSV-File from the gaze
% tracker and returns the framePositions

    fid = fopen(filename);
    out = textscan(fid,'%f%f%f%f%f','delimiter',';');
    fclose(fid);

    framePositions = [out{4} out{5}];