 img = imread('images/test/trap.png');
 
 RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
 gray = rgb2gray(RGB2);
 c_image = edge(gray, 'canny', .2);
 
 cbw_image = bwareaopen(c_image, 500);
 
 imshow(cbw_image);axis on;
 
 figure; hold on;
 
 cbw_image = imrotate(cbw_image, 10);
 
 imshow(cbw_image);axis on;
 
 figure; hold on;
 
 cbw_image = fliplr(cbw_image);
 
 imshow(cbw_image);axis on;