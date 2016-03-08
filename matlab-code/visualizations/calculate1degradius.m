% This script puts a 1° radius on an image that has been shown on full
% screen
% img = im2double(imread('../../data/Dataset8/input-frames/frame_00195.png'));
% img = im2double(imread('../../data/Dataset2/input-frames/frame_00206.png'));
img = im2double(imread('../../data/Dataset7/input-frames/frame_00046.png'));

% These values are taken from http://dev.theeyetribe.com/general/
insecurity = 1; % in degrees
distance_to_screen = 60; % in cm

% These values are screen-specific. With Ubuntu, the values can be found
% using the following command in a terminal:
%
%   xrandr
%
screen_width = 51.8; % in cm
screen_height = 32.4; % in cm


img_height = size(img,1);

radius_on_screen = tan(deg2rad(insecurity)) * distance_to_screen; % in cm


% find relation between full screen size and 1 degree radius
width_relation = screen_width/radius_on_screen;
height_relation = screen_height/radius_on_screen;


middle = flip([size(img,1), size(img,2)])/2;

% if video height matches screen height, use height-relation
% if video width matches screen width, use width-relation
pixel_radius_on_image = img_height/height_relation;


imshow(img,'Border','tight');
viscircles(middle, pixel_radius_on_image,'EnhanceVisibility',false);