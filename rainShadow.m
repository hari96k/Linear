function [ x, y ] = rainShadow( row, col, baseslope, x1index, y1index )

if baseslope > 0
    selection = 0;
end

if baseslope <0
    selection = 1;
end
x1 = row(x1index);
y1 = col(y1index);

x2index = x1index + 1;
y2index = y1index + 1;

x2 = row( x2index );
y2 = col( y2index );

deltax = x2-x1;
deltay = y2-y1;

slope = -1*(deltax/deltay);

if selection == 0
    while ((slope > 0 ) || (deltay < 5) )

        x2index = x2index + 1;
        y2index = y2index + 1;

        x2 = row( x2index );
        y2 = col( y2index );

        deltax = x2-x1;
        deltay = y2-y1;

        slope = -1*(deltax/deltay);
    end

else 
    while (( slope < 0 ) || ( (deltay) < 5) )

        x2index = x2index + 1;
        y2index = y2index + 1;

        x2 = row( x2index );
        y2 = col( y2index );

        deltax = x2-x1;
        deltay = y2-y1;

        slope = -1*(deltax/deltay);
    end
end
    
    
x = x2index;
y = y2index;
