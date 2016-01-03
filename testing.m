clc;
clear;
close all;

img = imread('images/test/cross2.jpg');

RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
gray = rgb2gray(RGB2);
a_gray = imadjust(gray);
s_gray = imsharpen(a_gray);
c_image = edge(a_gray, 'canny', .15);
noiseLVL = 2;


c_image = bwareaopen(c_image, 100*noiseLVL);

imshow(c_image);axis on;

 
measurements = regionprops(c_image, 'BoundingBox');

while length(measurements) > 50;
    c_image = bwareaopen(c_image, 100*noiseLVL);
    noiseLVL = noiseLVL + 1;
    measurements = regionprops(c_image, 'BoundingBox');
end

imshow(c_image);

for blob = 1 : length(measurements)
	% Get the bounding box.
	thisBoundingBox = measurements(blob).BoundingBox;
	% Crop it out of the original gray scale image.
	thisWord = imcrop(c_image, thisBoundingBox);
	% Display the cropped image
    figure; hold on;
	imshow(thisWord); % Display it.
end

