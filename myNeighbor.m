function [ x2index, y2index, slope, keepGoing ] = myNeighbor( row, col, x1index, y1index )

x1 = row(x1index);
y1 = col(y1index);

x2index = x1index + 10;
y2index = y1index + 10;


x2 = row( x2index );
y2 = col( y2index );

deltax = x2-x1;
deltay = y2-y1;


%( sqrt((deltax)^2 + (deltay)^2) > 10)

while (( sqrt((deltax)^2 + (deltay)^2) > 8) || (deltax == 0) || (deltay == 0))
%    x1index = x1index - 1;
%    y1index = y1index - 1;
     x2index = x2index + 1;
     y2index = y2index + 1;
     [sizeof,~] = size(row);
     
     if (((x2index - x1index) > 100) || (x2index > sizeof)) 
         keepGoing = 0;
         x2index = x1index;
         y2index = y1index;
         slope = 0;
         break;
     end
    
%    x1 = row ( x1index );
%    y1 = col ( y1index );
     x2 = row ( x2index );
     y2 = col ( y2index );
    
    deltax = x2-x1;
    deltay = y2-y1;
end

keepGoing = 1;
slope = -1*(deltax/deltay);
