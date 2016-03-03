function framePositions = readCSVFile(filename);
% This function reads the CSV-File from the gaze
% tracker and returns the framePositions  
    try
        disp('Try reading from beginning on...');
        out = my_csvread(filename,0,0,';');
    catch
        disp('Catch...');
        out = my_csvread(filename,5,0,';');
    end
    
    framePositions = [out(:,4) out(:,5) out(:,3)];