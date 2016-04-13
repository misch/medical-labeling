function [pos] = mouseMove (object, eventdata)
% MOUSEMOVE get the current mouse position (used in prepareData/simulateEyeTracking)
C = get (gca, 'CurrentPoint');
pos = [C(1,1), C(1,2)];
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);