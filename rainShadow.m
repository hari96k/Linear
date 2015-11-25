function [ x, y ] = rainShadow( row, col, baseslope )

x1index = 1;
y1index = 1;

x1 = row(x1index);
y1 = col(y1index);

x2index = x1index + 1;
y2index = y1index + 1;

x2 = row( x2index );
y2 = col( y2index );

deltax = x2-x1;
deltay = y2-y1;

slope = -1*(deltax/deltay);

while ( abs ( baseslope - slope ) > 1.5 )

    x2index = x2index + 1;
    y2index = y2index + 1;

    x2 = row( x2index );
    y2 = col( y2index );

    deltax = x2-x1;
    deltay = y2-y1;

    slope = -1*(deltax/deltay);
end

x = x2index;
y = y2index;
