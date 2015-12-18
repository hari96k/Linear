function [ string ] = discriminate( corners, x, y, index )

[realsize,~] = size(corners);

string = 'Unknown';

if realsize < 3
    return
end

condition = 0;
xEdges = x(index(index ~= 0));
yEdges = y(index(index ~= 0));

if realsize == 3

    for a = 1:3
        xmid = ( ( x(corners(a,2)) ) + x(corners(a,1)) ) / 2;
        ymid = ( ( y(corners(a,2)) ) + y(corners(a,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end
    
    if(condition >= 2)
        string = 'Tringle';
        return
    else
        return
    end
end

if realsize > 4
    return
end

% radius = (x(corners(4,2)) - x(corners(1,1)))/2;

    for b = 1:4
        xmid = ( ( x(corners(b,2)) ) + x(corners(b,1)) ) / 2;
        ymid = ( ( y(corners(b,2)) ) + y(corners(b,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end

if (condition < 2)
    string = 'Circle';
    return
end




