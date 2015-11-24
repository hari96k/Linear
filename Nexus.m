
clc;
clear;

img_many = imread('images/test/canny1.jpg');
img_bad = imread('images/test/bad.png');
img_reallybad = imread('images/test/copy.png');
img_croppedt = imread('images/crop2.jpg');

commandwindow;

img = img_many;

RGB2 = imadjust(img,[.1 .1 .1; .9 .9 .9]);



gray = rgb2gray(RGB2);

ed = edge(gray, 'canny', .15);

%edcropped = imcrop (ed, [600 600 1200 1850]);

edcropped = imcrop (ed, [650 400 1650 1650]);

noNoise = bwareaopen(edcropped, 50);

c = corner(noNoise);

figure;
hold on;
imshow(noNoise);
axis on;

%mserRegions = detectMSERFeatures(bw);
[row,col] =   find (edcropped==1);

% p = polyfit(row, col, 1);
% plot(p,'Color','b','LineWidth',5 );
%figure; hold on; imshow(edcropped); axis on;


%line([col(1),col(50)],[row(1),row(50)],'Color','r','LineWidth',5);
%  for ii = 1:5
%     line([col((ii-1)*50+1),col((ii)*50)],[row((ii-1)*50+1),row((ii)*50)],'Color','r','LineWidth',5);
%  end

countermax = floor(size(row));

x = 1;
y = 1;

xarray = [];
yarray = [];
slopearray = [];
keepGoing = 1;
i = 0;

while keepGoing;
        
    [neighborx,neighbory, slope, keepGoing] = myNeighbor( row(), col(), x, y);
    
    xarray(i+1) = x;
    yarray(i+1) = y;
    slopearray(i+1) = slope;
    
    
     line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','r','LineWidth',5);
    
    x = neighborx;
    y = neighbory;
    i= i+1;
end

[x,y] = rainShadow( row, col, slopearray(1));

for i = 0:countermax
    [neighborx,neighbory, slope] = myNeighbor( row(), col(), x, y );
    
    xarray2(i+1) = x;
    yarray2(i+1) = y;
    slopearray2(i+1) = slope;
    
    
     line ([col(y), col(neighbory)], [row(x), row(neighborx)],'Color','g','LineWidth',5);
    
    x = neighborx;
    y = neighbory;

end



[startxarray, startyarray, endxarray, endyarray] = damnStraight(xarray, yarray, slopearray);

finalarray = [startxarray' endxarray' startyarray' endyarray'];

realsize = size(startxarray');

for i=1:realsize

    line ([col(startyarray(i)), col(endyarray(i))], [row(startxarray(i)), row(endxarray(i))],'Color','b','LineWidth',5);

   % line ([col(startyarray(2)), col(endyarray(2))], [row(startxarray(2)), row(endxarray(2))],'Color','b','LineWidth',5);

end

[startxarray, startyarray, endxarray, endyarray] = damnStraight(xarray2, yarray2, slopearray2);

[~, realsize] = size(startxarray);

for i=1:realsize

    line ([col(startyarray(i)), col(endyarray(i))], [row(startxarray(i)), row(endxarray(i))],'Color','b','LineWidth',5);

end
    
finalarray2 = [startxarray' endxarray' startyarray' endyarray'];

send = vertcat(finalarray, finalarray2);

title(discriminate(send));


