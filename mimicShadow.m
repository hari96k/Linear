function [ x,y ] = mimicShadow( row, col, avoidx, avoidy )

try

if row(1) < avoidx
    selection = 1;        %find shadow up
end

if row(1) >= avoidx
    selection = 0;        %find shadow down
end

x2index = 5;
y2index = 5;

x2 = row( x2index );
y2 = col( y2index );

deltax = x2-avoidx;
deltay = y2-avoidy;

if selection == 0
     while ((x2 < row(1)) || sqrt((deltax)^2 + (deltay)^2) < 10 )
        x2index = x2index + 1;
        y2index = y2index + 1;

        x2 = row( x2index );
        y2 = col( y2index );

        deltax = x2-avoidx;
        deltay = y2-avoidy;
     end

else if selection == 1
        while (( x2 > row(1) ) || sqrt((deltax)^2 + (deltay)^2) < 10 )
            x2index = x2index + 1;
            y2index = y2index + 1;

            x2 = row( x2index );
            y2 = col( y2index );

            deltax = x2-avoidx;
            deltay = y2-avoidy;
        end
    end
end
     
     
 x = x2index;
 y = y2index;
 
catch
    x = 0;
    y = 0;
end

