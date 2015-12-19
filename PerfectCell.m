% Main ----- Refined Nexus


% Input: A croped BW image (or RGB image)
%      Note: This assumes that the copping is correct and there is only one
%            shape per image
% Output: Classifies the shape as a triangle, circle, square, or rectangle
%        Note: The same algorithm could be extended to apply to other
%              polygons

clc;
clear;
commandwindow;

img_many = imread('images/test/canny1.jpg');
img_bad = imread('images/test/bad.png');
img_reallybad = imread('images/test/copy.png');
img_croppedt = imread('images/crop2.jpg');


% Change the img and c_image assignment to debug with another image


img = img_many;

% RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);
% gray = rgb2gray(RGB2);
% ed = edge(gray, 'canny', .2);
% c_image = imcrop (ed, [90 90 1850 1850]);


%Circle
c_image = imcrop (im2bw(img, 0.4), [650 400 950 650]);

%Triangle
% c_image = imcrop (im2bw(img, 0.4), [200 300 400 400]);

repeat = 1;
noiseLVL = 0;

while  repeat && noiseLVL < 6

c_image = bwareaopen(c_image, 500*noiseLVL);

figure;hold on;imshow(c_image);axis on;

% Creates the row/col arrays where the image is white (1)
[yArray, xArray] =   find (c_image==1);


% Initializations
index = zeros([1000 1]);
slopeArray = zeros([1000 1]);
cornersArray = [];
xyIndex = 1;
prevEnd = 1;
i = 1;

% Global error handle, catches all exceptions
 try
    % Determines which direction of traversal (up/down) should be first
    if ( yArray(20) > yArray(1) )
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
            end
            % Determines if the traversal is long enough to be a side
            if (i-prevEnd > .1*i + 5)
                line ([xArray(index(prevEnd)), xArray(index(i-2))], [yArray(index(prevEnd)), yArray(index(i-2))],'Color','b','LineWidth',4);
                cornersArray = vertcat(cornersArray,[index(prevEnd), index(i-1)]);
                prevEnd = i;
            end
        end
        start = start - 1;
        prevEnd = 1;
        [xyIndex,~] = mimicShadow( yArray, xArray, yArray(index(2)), xArray(index(2)));
    end


 
    shape = discriminate( cornersArray, xArray, yArray, index );

    if ( ~strcmp(shape, 'Unknown') && (~strcmp(shape, 'Line')) )
        repeat = 0;
    end

    noiseLVL = noiseLVL + 1;
    title(shape);

catch
    title('Something went wrong')
end

end


