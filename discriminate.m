function [ string ] = discriminate( corners, x, y, index )

[realsize,~] = size(corners);

if realsize == 2 || realsize == 1 ;
    string = 'Line';
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


    for b = 1:4
        xmid = ( ( x(corners(b,2)) ) + x(corners(b,1)) ) / 2;
        ymid = ( ( y(corners(b,2)) ) + y(corners(b,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end

if (condition < 2)
    
    xrad = (x(corners(4,2)) - x(corners(1,1)))/2 ;
    if ( y(corners(2,1) < y(corners(4,1))) )
        yrad = (y(corners(2,1)) - y(corners(4,1)))/2 ;
    else
        yrad = (y(corners(4,1)) - y(corners(2,1)))/2 ;
    end
    r = (xrad + yrad )/2;

    xc = (x(corners(4,2)) + x(corners(1,1)))/2;

    yc = (y(corners(4,2)) + y(corners(1,1)))/2;

    theta = linspace(0,2*pi);
    x = r*cos(theta) + xc;
    y = r*sin(theta) + yc;
    hold on;
    plot(x,y, 'g', 'LineStyle','- -')

    string = 'Circle';
    return
end




