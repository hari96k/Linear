
% Main
%*****************OUTDATED**********************
%**************USE PerfectCell******************

% Input: A croped BW image (or RGB image)
%      Note: This assumes that the copping is correct and there is only one
%            shape per image
% Output: Classifies the shape as a triangle, circle, square, or rectangle
%      Note: The same algorithm could be extended to apply to other
%            polygons


clc;
clear;

img_many = imread('images/test/canny1.jpg');
img_bad = imread('images/test/bad.png');
img_reallybad = imread('images/test/copy.png');
img_croppedt = imread('images/crop2.jpg');

commandwindow;

img = img_many;

% RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
% 
% gray = rgb2gray(RGB2);
% 
% ed = edge(gray, 'canny', .2);
% 
% edcropped = imcrop (ed, [90 90 1850 1850]);
% 
% noNoise = bwareaopen(edcropped, 50);


%Remove later
noNoise = imcrop (im2bw(img, 0.4), [650 400 950 650]);
edcropped = noNoise;
%

figure;
hold on;
imshow(noNoise);
axis on;

% Creates the row/col arrays where the image is white (1)
[row,col] =   find (edcropped==1);

x = 1;
y = 1;

xarray = [];
yarray = [];
slopearray = [];
finalarray = [];
keepGoing = 1;
prevEnd = 1;
repeat = 0;
i = 0;

%   First iteration attempting to go down then up

for b = 0:1

    while keepGoing

        [neighborx,neighbory, slope, keepGoing] = myNeighbor( row(), col(), x, y, b );

        xarray(i+1) = x;
        yarray(i+1) = y;
        slopearray(i+1) = slope;

         line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','r','LineWidth',5);

        x = neighborx;
        y = neighbory;
        i= i+1;
    end
    
    % If going down is successful, then add corner points
    
    if (i-2-prevEnd >3)
        line ([col(yarray(prevEnd)), col(yarray(i-1))], [row(xarray(prevEnd)), row(xarray(i-1))],'Color','b','LineWidth',5);
        finalarray = vertcat(finalarray,[xarray(prevEnd), xarray(i-1)]);
        prevEnd = i-1;
    else
        repeat = 1;
        xarray2 = 0;
        yarray2 = 0;
        slopearray2 = 0;
        keepGoing = 1;
        break;
    end
    keepGoing = 1;
end

if (repeat == 1)                                %If going down on rain fails, go up
    i = 0;
    prevEnd = 1;
    
for b = 1:2

    while keepGoing

        [neighborx,neighbory, slope, keepGoing] = myNeighbor( row(), col(), x, y, b );

        xarray2(i+1) = x;
        yarray2(i+1) = y;
        slopearray2(i+1) = slope;

         line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','y','LineWidth',5);

        x = neighborx;
        y = neighbory;
        i= i+1;
    end
    if (i > 3)
    line ([col(yarray2(prevEnd)), col(yarray2(i-1))], [row(xarray2(prevEnd)), row(xarray2(i-1))],'Color','b','LineWidth',5);
    finalarray = vertcat(finalarray,[xarray(prevEnd), xarray(i-1)]);
    keepGoing = 1;
    else
    keepGoing = 0;
    end
end
end


[x,y] = rainShadow( row, col, slopearray(1), xarray(2), yarray(2));
prevEnd = 1;
keepGoing = 1;
repeat = 0;

i = 0;

% Second iteration, first goes up, then goes down

for b=2:3
    while keepGoing

        [neighborx,neighbory, slope, keepGoing] = myNeighbor( row(), col(), x, y, b );

        xarray2(i+1) = x;
        yarray2(i+1) = y;
        slopearray2(i+1) = slope;


         line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','g','LineWidth',5);

        x = neighborx;
        y = neighbory;
        i= i+1;
    end
    if (i-2-prevEnd >3)
        line ([col(yarray2(prevEnd)), col(yarray2(i-1))], [row(xarray2(prevEnd)), row(xarray2(i-1))],'Color','b','LineWidth',5);
        finalarray = vertcat(finalarray,[xarray(prevEnd), xarray(i-1)]);
        prevEnd = i-1;
    else
        repeat = 1;
        xarray2 = 0;
        yarray2 = 0;
        slopearray2 = 0;
        keepGoing = 1;
        break;
    end
    keepGoing = 1;
end

[limit,~] = size(xarray2);

if (repeat == 1)                                %If going down on rain showdow fails, go up
    i = 0;
    prevEnd = 1;
    for b = 1:2

    while keepGoing

        [neighborx,neighbory, slope, keepGoing] = myNeighbor( row(), col(), x, y, b );
   
        xarray2(i+1) = x;
        yarray2(i+1) = y;
        slopearray2(i+1) = slope;

         line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','g','LineWidth',5);

        x = neighborx;
        y = neighbory;
        i= i+1;
    end
    if (i > 3)
        line ([col(yarray2(prevEnd)), col(yarray2(i-1))], [row(xarray2(prevEnd)), row(xarray2(i-1))],'Color','b','LineWidth',5);
        finalarray = vertcat(finalarray,[xarray(prevEnd), xarray(i-1)]);
        prevEnd = i-1;
        keepGoing = 1;
    else
        keepGoing = 0;
    end
    end
end

title(discriminate(finalarray));


