% Main ----- Refined Nexus


% Input: A croped BW image (or RGB image)
%      Note: This assumes that the copping is correct and there is only one
%            shape per image
% Output: Classifies the shape as a triangle, circle, square, rectangle,
%         trapezoid, star, or cross
%        Note: Detects squares, rectangles, and circles with high accuracy
%              The rest need further refinement
%
% Known Errors: Squares and Rectangles with a rotation of 0 degress (ie. img_square4)
%               Very little safegaurds atm, false alarm might be high
%               Large patches of discontinuity leads to unpredictable output
%               There is no implementation of scale atm, zoomed out / small images
%                   might not be recognized
%               Regular n-sided polygons with n > 5 might be falsely
%               detected as circles or trapezoids

clc;
clear;
close all;

img_many = imread('images/test/canny1.jpg');
img_bad = imread('images/test/bad.png');
img_r1 = imread('images/test/1_square.jpg');
% img_test = imread('images/test/test2.jpg');
% img_reallybad = imread('images/test/copy.png');
% img_croppedt = imread('images/crop2.jpg');
 img_square = imread('images/test/square.jpg');
% img_square2 = imread('images/test/square2.jpg');
 img_square4 = imread('images/test/square4.jpg');
% img_rectangle = imread('images/test/rectangle.jpg');
% img_rectangle2 = imread('images/test/rectangle2.jpg');
% img_rectangle3 = imread('images/test/rectangle3.jpg');
% img_barelyRectangle = imread('images/test/barelyRectangle.jpg');
 img_star = imread('images/test/star2.jpg');
 img_cross = imread('images/test/cross.jpg');
 img_trap = imread('images/test/trap.png');
 img_nothing = imread('images/test/nothing2.jpg');

% Change the img and c_image assignment to debug with another image


img = img_star;

%Small Triangle (img_bad)
% RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
% gray = rgb2gray(RGB2);
% ed = edge(gray, 'canny', .2);
% c_image = imcrop (ed, [90 90 1850 1850]);


%Circle
% c_image = imcrop (im2bw(img, 0.4), [650 400 950 650]);

%Triangle (img_many)
% c_image = imcrop (im2bw(img, 0.4), [200 300 400 400]);

%Standard (no crop)
 RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
 gray = rgb2gray(RGB2);
 c_image = edge(gray, 'canny', .2);
%  c_image = imrotate(c_image, 10);
%  c_image = flip(c_image, 1);
 
repeat = 1;
noiseLVL = 0;
tryToFlip = 0;
tryToRotate = 0;
flipped = 0;
rotated = 0;
nothing = 0;


% Global error handle, catches all exceptions

try
    
while  repeat && noiseLVL < 50

cbw_image = bwareaopen(c_image, 100*noiseLVL);

if tryToFlip == 1 && flipped == 0
     cbw_image = fliplr(cbw_image);
     tryToFlip = 0;
     flipped = 1;
else if tryToRotate == 1 && rotated == 0
         cbw_image = imrotate(cbw_image, 10);
         tryToRotate = 0;
         rotated = 1;
     end
end


    
% Creates the row/col arrays where the image is white (1)
[yArray, xArray] =   find (cbw_image==1);

if isempty(xArray)
    nothing = 1;
end

% Initializations
index = zeros([1000 1]);
slopeArray = zeros([1000 1]);
cornersArray = [];
xyIndex = 1;
prevEnd = 1;
i = 1;
j = 1;


% figure;
imshow(cbw_image);
axis on;
title('Approximations');

    % Determines which direction of traversal (up/down) should be first
    sum = 0;
    
    for k = 2:50
        sum = sum + yArray(k);
    end
    
    if ( sum/49 < yArray(1) )
        start = 1;                      %go up
        firstDirection = 'up';
    else 
        start = 0;                      %go down
        firstDirection = 'down';
    end


    for a = 1:2
        for b = start:start+1
            keepGoing = 1;
            while keepGoing
                %n_xyIndex is the index of the neighbor
                [~, n_xyIndex, slope, keepGoing] = myNeighbor( yArray(), xArray(), xyIndex, xyIndex, b );

                index(i) = xyIndex;
                slopeArray(i) = slope;
                
                line ([xArray(xyIndex), xArray(n_xyIndex)], [yArray(xyIndex), yArray(n_xyIndex)],'Color','r','LineWidth',2);
                
                xyIndex = n_xyIndex;
                i= i+1;
                j= j+1;
            end
            % Determines if the traversal is long enough to be a side
            if b == start && (abs(j-prevEnd) > .15*j + 5)
                test = 1;
            else if b == start + 1 && (abs(i-prevEnd) > .15*j + 5)
                    test = 1;
                else
                    test = 0;
                end
            end
            
            if test
                line ([xArray(index(prevEnd)), xArray(index(i-2))], [yArray(index(prevEnd)), yArray(index(i-2))],'Color','b','LineWidth',4);
                cornersArray = vertcat(cornersArray,[index(prevEnd), index(i-1)]);
                prevEnd = i;
            end
            test = 0;
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
    end


 
    [shape, xcenter, ycenter] = discriminate( cornersArray, xArray, yArray, index );
    
    if strcmp(shape, 'Trap Queen') && flipped == 0
       tryToFlip = 1;
       close all;
        
    else if strcmp(shape, 'Cross') && rotated == 0
            tryToRotate = 1;
            close all;
            
        else if ( ~strcmp(shape, 'Unknown') && (~strcmp(shape, 'Line')) )
                repeat = 0;
             else  
                noiseLVL = noiseLVL + 1;
                close all;
             end
         end
    end
 

end


catch
    if nothing == 1
        shape = 'Empty';
    else
        shape = 'Something went wrong =/';
    end
end

hold on;

if (xcenter ~= 0 && ycenter ~= 0 )
    scatter (xcenter, ycenter, 'y*');
end

figure; imshow(c_image);axis on;hold on;



[count, ~] = size(cornersArray);

if ( (count ~= 0) && ~strcmp(shape,'Circle') && ~strcmp(shape, 'Trapezoid') && flipped == 0 && rotated == 0)
    for c = 1:count
        line ([xArray(cornersArray(c,1)), xArray((cornersArray(c,2)))], [yArray(cornersArray(c,1)), yArray(cornersArray(c,2))],'Color','b','LineWidth',4);
    end
end

if strcmp(shape, 'Circle')
    xrad = (xArray(cornersArray(4,2)) - xArray(cornersArray(1,1)))/2 ;
    if ( yArray(cornersArray(2,1) < yArray(cornersArray(4,1))) )
        yrad = (yArray(cornersArray(2,1)) - yArray(cornersArray(4,1)))/2 ;
    else
        yrad = (yArray(cornersArray(4,1)) - yArray(cornersArray(2,1)))/2 ;
    end
    r = (xrad + yrad )/2;

    xc = (xArray(cornersArray(4,2)) + xArray(cornersArray(1,1)))/2;

    yc = (yArray(cornersArray(4,2)) + yArray(cornersArray(1,1)))/2;

    theta = linspace(0,2*pi);
    x = r*cos(theta) + xc;
    y = r*sin(theta) + yc;
    plot(x,y, 'g', 'LineStyle','- -')
end

title(shape);
