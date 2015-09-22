function [pos] = mouseMove (object, eventdata)

C = get (gca, 'CurrentPoint');
pos = [C(1,1), C(1,2)];
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);