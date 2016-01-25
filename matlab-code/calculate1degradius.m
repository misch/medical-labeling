% get 1° radius on image

% cm on screen: tan(1°) * distance_to_screen [cm]

% from recorded "display width" and "display height", take the one that is
% unrealistic (i.e. bigger than actual screen size) and figure out how much
% it has been reduced.
%
% e.g. if display height = 1900 and actual display resolution = 1920 x
% 1080:
%
% x = 1900 / 1080 % wished height, if width were full-screen vs. actually possible size
% y = 1920 / x % actual width, given that height is smaller than expected

