% Main ----- Refined Nexus


% Input: A croped BW image (or RGB image)
%      Note: This assumes that the copping is correct and there is only one
%            shape per image
% Output: Classifies the shape as a triangle, circle, square, rectangle,
%         trapezoid, star, or cross
%        Note: Detects squares, rectangles, triangles, and circles with high
%              accuracy, the rest need further refinement
%
% Known Errors: Squares and Rectangles with a rotation of 0 degress (ie. img_square4)
%               Few safegaurds atm, false alarm might be high
%               Large patches of discontinuity leads to unpredictable output (ie. circle.png)
%               There is not a consistent implementation for scale atm,
%                   very small shapes with alot of noise might not be
%                   recognized through blob filtering
%               Regular n-sided polygons with n > 5 might be falsely
%                   detected as circles or trapezoids; They do not have an
%                   implementation atm

clc;
clear;
close all;

% img_many = imread('images/test/canny1.jpg');
 img_bad = imread('images/test/bad.png');
 img_bad2 = imread('images/test/bad2.jpg');
% img_r1 = imread('images/test/1_square.jpg');
% img_test = imread('images/test/test2.jpg');
% img_reallybad = imread('images/test/copy.png');
% img_croppedt = imread('images/crop2.jpg');
% img_square = imread('images/test/square.jpg');
% img_square2 = imread('images/test/square2.jpg');
% img_square4 = imread('images/test/square4.jpg');
% img_rectangle = imread('images/test/rectangle2.jpg');
% img_rectangle2 = imread('images/test/rectangle2.jpg');
% img_rectangle3 = imread('images/test/rectangle3.jpg');
% img_barelyRectangle = imread('images/test/barelyRectangle.jpg');
% img_star = imread('images/test/star2.jpg');
 img_cross = imread('images/test/cross2.jpg');
% img_trap = imread('images/test/trap.png');
 img_nothing = imread('images/test/nothing2.jpg');
 img_circle = imread('images/test/circle3.jpg');

% Change the img and c_image assignment to debug with another image

img = img_bad2;

%Standard (no initial crop)
 RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
 gray = rgb2gray(RGB2);
 a_gray = imadjust(gray);
 c_image = edge(a_gray, 'canny', .30);
 
%  c_image = fliplr(c_image);
%  c_image = bwmorph(c_image, 'thin', Inf);
%  tform = affine2d([1 0 0; .5 1 0; 0 0 1]);
%  c_image = imwarp(c_image, tform);
%  c_image = imrotate(c_image, 10);
%  c_image = flip(c_image, 1);

% imshow(c_image);
% figure; hold on;


noiseLVL = 1;


blobs = regionprops(c_image, 'BoundingBox');

while length(blobs) > 25;
    c_image = bwareaopen(c_image, 10*noiseLVL);
    noiseLVL = noiseLVL + 1;
    blobs = regionprops(c_image, 'BoundingBox');
end

% imshow(c_image);
% axis on;

repeat = 1;
noiseLVL = 1;
tryToFlip = 0;
tryToRotate = 0;
flipped = 0;
rotated = 0;
nothing = 0;
crossConfirm = 0;

% Global error handle, catches all exceptions   
try  

while  repeat && noiseLVL < 50

blobs = regionprops(c_image, 'BoundingBox');

if isempty(blobs)
    nothing = 1;
    error('Empty');
end

% imshow(c_image);

z = 1;
    
 while z <= length(blobs)
  
 
if tryToFlip == 1 && flipped == 0
     thisBlob = fliplr(thisBlob);
     tryToFlip = 0;
     flipped = 1;
% else if tryToRotate == 1 && rotated == 0
%          thisBlob = imrotate(thisBlob, 10);
%          tryToRotate = 0;
%          rotated = 1;
%      end

else
boundary = blobs(z).BoundingBox;
% Crop it out of the original gray scale image.
thisBlob = imcrop(c_image, boundary);    

numberOfWhite = sum(thisBlob(:));

if numberOfWhite < 100
    tryToFlip = 0;
    tryToRotate = 0;
    flipped = 0;
    rotated = 0;
    nothing = 0;
    crossConfirm = 0;
    z = z+1;
    continue
end

thisBlob = imresize(thisBlob, [300 300], 'Method', 'nearest') ;

end

thisBlob = bwmorph(thisBlob, 'thin', Inf);

% imshow(thisBlob);
% hold on; axis on;
% title('Approximations');


xyIndex = 1;    
% Creates the row/col arrays where the image is white (1)
[yArray, xArray] =   find (thisBlob==1);

[total,~] = size(yArray);

    
    if isempty(xArray)
        nothing = 1;
    end

    % Initializations
    index = zeros([1000 1]);
    slopeArray = zeros([1000 1]);
    cornersArray = [];
    prevEnd = 1;
    i = 1;
    j = 1;


        % Determines which direction of traversal (up/down) should be first
        yolo = 0;
        
        if total >= 50
            goUntil = 50;
        else
            goUntil = total;
        end
        
        for k = 2:goUntil
            yolo = yolo + yArray(k);
        end

        if ( yolo/(goUntil-1) < yArray(1) )
            start = 1;                      %go up
            firstDirection = 'up';
        else 
            start = 0;                      %go down
            firstDirection = 'down';
        end

traversal = 0;
        for a = 1:2
            for b = start:start+1
                keepGoing = 1;
                while keepGoing
                    %n_xyIndex is the index of the neighbor
                    [~, n_xyIndex, slope, keepGoing] = myNeighbor( yArray(), xArray(), xyIndex, xyIndex, b );

                    index(i) = xyIndex;
                    slopeArray(i) = slope;

                    %line ([xArray(xyIndex), xArray(n_xyIndex)], [yArray(xyIndex), yArray(n_xyIndex)],'Color','r','LineWidth',2);

                    xyIndex = n_xyIndex;
                    i= i+1;
                    j= j+1;
                    if j == 3
                        prevEnd = xyIndex;
                    end
                end
                
                if j > 10
                    %line ([xArray(prevEnd), xArray(index(i-3))], [yArray(prevEnd), yArray(index(i-3))],'Color','b','LineWidth',4);
                    cornersArray = vertcat(cornersArray,[prevEnd, index(i-3)]);
  
                    if a == 1
                        traversal = traversal + 1;
                    end
                end

                j = 1;
            end

            %Reversing traversal direction after first iteration
            if (start == 1)
                start = 0;
            else
                start = 1;
            end
            
            prevEnd = 1;
            j = 1;
            [xyIndex,~] = mimicShadow( yArray, xArray, yArray(index(2)), xArray(index(2)));
%             prevEnd = xyIndex;
            if (xyIndex == 0)
                break;
            end
        end



        [shape, xcenter, ycenter] = discriminate( cornersArray, xArray, yArray, index, traversal );

        if (strcmp(shape, 'Trap Queen') || strcmp(shape, 'Cross')) && flipped == 0
           tryToFlip = 1;
           continue
%            close all;

           else if ( ~strcmp(shape, 'Unknown') && (~strcmp(shape, 'Trap Queen')) )
                    repeat = 0;
                else  
                    tryToFlip = 0;
                    tryToRotate = 0;
                    flipped = 0;
                    rotated = 0;
                    nothing = 0;
                    crossConfirm = 0;
%                    close all;
               end
        end
         
        if repeat == 0
            break
        end
        
        z = z + 1;
 end

if repeat == 0
    break
end
 
noiseLVL = noiseLVL + 1;

c_image = bwareaopen(c_image, 100*noiseLVL);

end

catch
    if nothing == 1
        shape = 'Empty';
    else
        shape = 'Something went wrong =/';
    end
end

if ~strcmp(shape, 'Empty')
    figure;
    imshow(thisBlob);
    title('Approximations');
    axis on;
    hold on;


if exist('xcenter', 'var')
    if (xcenter ~= 0 && ycenter ~= 0 )
        scatter (xcenter, ycenter, 'y*');
    end
end

end



[count, ~] = size(cornersArray);

if ( (count ~= 0) && (strcmp(shape,'Square') || strcmp(shape, 'Rectangle') || strcmp(shape, 'Tringle') ) && flipped == 0 && rotated == 0)
    for c = 1:count
        line ([xArray(cornersArray(c,1)), xArray((cornersArray(c,2)))], [yArray(cornersArray(c,1)), yArray(cornersArray(c,2))],'Color','b','LineWidth',4);
    end
end

if strcmp(shape, 'Circle')
    xrad = (xArray(cornersArray(4,2)) - xArray(cornersArray(1,1)))/2 ;
%     if ( yArray(cornersArray(2,1) < yArray(cornersArray(4,1))) )
    yrad = abs((yArray(cornersArray(2,1)) - yArray(cornersArray(4,1)))/2);
%     else
%         yrad = (yArray(cornersArray(4,1)) - yArray(cornersArray(2,1)))/2 ;
%     end
    r = (xrad + yrad)/2;

    xc = (xArray(cornersArray(4,2)) + xArray(cornersArray(1,1)))/2;

    yc = (yArray(cornersArray(4,2)) + yArray(cornersArray(1,1)))/2;

    theta = linspace(0,2*pi);
    x = r*cos(theta) + xc;
    y = r*sin(theta) + yc;
    plot(x,y, 'g', 'LineStyle','- -')
end


if strcmp(shape, 'Empty')
    output = img;
else 
    output = imcrop(img, boundary);
end

figure;
imshow(output);


title(shape);
why;
