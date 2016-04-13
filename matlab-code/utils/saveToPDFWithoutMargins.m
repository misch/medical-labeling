function [] = saveToPDFWithoutMargins(h,output_file);
% SAVETOPDFWITHOUTMARGIN save a figure to a pdf without big margins around it
%
% input:
%   - h: figure handle
%   - output_file: filename of the output file (e.g. 'test.pdf')
    set(h,'PaperOrientation','landscape');
    set(h,'PaperUnits','normalized');
    set(h,'PaperPosition', [0 0 1 1]);
    
    currentAxes = h.CurrentAxes;
    tightInset = get(currentAxes , 'TightInset');
    position(1) = tightInset(1);
    position(2) = tightInset(2);
    position(3) = 1 - tightInset(1) - tightInset(3);
    position(4) = 1 - tightInset(2) - tightInset(4);
    set(currentAxes , 'Position', position);
    
    saveas(h, output_file);