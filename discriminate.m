function [ string ] = discriminate( corners, x, y, direction )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[realsize,~] = size(corners);

xmid = ( ( x(corners(2,1)) ) + x(corners(1,1)) ) / 2;
ymid = ( ( y(corners(1,2)) ) + y(corners(2,2)) ) / 2;

condition = notAlone( xmid , ymid , x, y, direction );

if realsize == 3
    string = 'Tringle';
else
    string = 'Unknown';
end

end

