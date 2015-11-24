function [ string ] = discriminate( finalarray )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[~,realsize] = size(finalarray);

if realsize == 3
    string = 'tringle';
end

end

