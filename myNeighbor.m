function [ x2index, y2index, slope, keepGoing ] = myNeighbor( row, col, x1index, y1index, selection )

if (selection == 2)
    selection = 0;                          %going down
elseif (selection == 3)
    selection = 1;                          %going up
end

[limit,~] = size(row);

x1 = row(x1index);
y1 = col(y1index);

if (x1index + 10 <= limit)
    x2index = x1index + 5;
    y2index = y1index + 5;
else
    keepGoing = 0;
    x2index = x1index;
    y2index = y1index;
    slope = 0;
    return;
end

x2 = row( x2index );
y2 = col( y2index );

deltax = x2-x1;
deltay = y2-y1;

slope = -1*(deltax/deltay);

keepGoing = 1;

%( sqrt((deltax)^2 + (deltay)^2) > 10)

if selection == 1                   %going up
   while (( sqrt((deltax)^2 + (deltay)^2) > 20) || (deltax > 0) || ((deltax == 0) && ( sqrt((deltax)^2 + (deltay)^2) < 5)) )
%    x1index = x1index - 1;
%    y1index = y1index - 1;
     x2index = x2index + 1;
     y2index = y2index + 1;
     
     if (((x2index - x1index) > 300) || (x2index > limit)) 
         keepGoing = 0;
         x2index = x1index;
         y2index = y1index;
         slope = 0;
         return;
     end
    
%    x1 = row ( x1index );
%    y1 = col ( y1index );
     x2 = row ( x2index );
     y2 = col ( y2index );
    
    deltax = x2-x1;
    deltay = y2-y1;

    slope = -1*(deltax/deltay);
   end

else                            %going down
   while (( sqrt((deltax)^2 + (deltay)^2) > 20) || (deltax < 0) || ((deltax == 0) && ( sqrt((deltax)^2 + (deltay)^2) < 5)))
%    x1index = x1index - 1;
%    y1index = y1index - 1;
     x2index = x2index + 1;
     y2index = y2index + 1;
     
     if (((x2index - x1index) > 300) || (x2index > limit)) 
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

    slope = -1*(deltax/deltay);
    end
    
end

