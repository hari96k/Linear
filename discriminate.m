function [ string , xcenter, ycenter] = discriminate( corners, x, y, index )

xcenter = 0;
ycenter = 0;



[realsize,~] = size(corners);

string = 'Unknown' ;

if realsize == 1 || realsize == 2
    string = 'Line';
    return
end

%% SLOPE COMPARING
% Finding Perpendicular and Parallel lines

sideSlopes = zeros([realsize 1]);

numPerp = 0;
numPar = 0;

for g = 1:realsize
%     startx = x(corners(g,1));
%     starty = y(corners(g,1));
%     endy = y(corners(g,2));
    deltax = x(corners(g,2)) - x(corners(g,1));
    deltay = y(corners(g,1)) - y(corners(g,2));
    sideSlopes(g) = (deltay/deltax);
end

% 1-2 Traversal
if corners(2,2) == corners(3,1)
    
    if abs(sideSlopes(1) - sideSlopes(3)) < .5
        numPar = numPar + 1;
    end

%     if abs(-1/sideSlopes(1) - sideSlopes(2)) < .2
%         numPerp = numPerp + 1;
%     end
% 
%     if abs(-1/sideSlopes(2) - sideSlopes(3)) < .2
%         numPerp = numPerp + 1;
%     end



% 2-1 Traversal
else if corners(1,2) == corners(2,1)
    
        if abs(sideSlopes(2) - sideSlopes(3)) < .5
            numPar = numPar + 1;
        end

%     if abs(-1/sideSlopes(1) - sideSlopes(2)) < .2
%         numPerp = numPerp + 1;
%     end
% 
%     if abs(-1/sideSlopes(2) - sideSlopes(3)) < .2
%         numPerp = numPerp + 1;
%     end
    else
        %4 sided shapes
        if abs(sideSlopes(1) - sideSlopes(3)) < .5
            numPar = numPar + 1;
        end
        
        if abs(sideSlopes(2) - sideSlopes(4)) < .5
            numPar = numPar + 1;
        end
    end
end

%% FINDING CENTER


[numNeigh,~] = size(x);


for e = 1:numNeigh
    xcenter = xcenter + x(e);
    ycenter = ycenter + y(e);
end

xcenter = xcenter/numNeigh;
ycenter = ycenter/numNeigh;

%% THREE-SIDED SHAPES

condition = 0;
xEdges = x(index(index ~= 0));
yEdges = y(index(index ~= 0));

if realsize == 3
    
    if corners(1,2) == corners(2,2)
        string = 'Trap Queen';
        return
    end
       
    
    % Checking if mid-points of sides are not alone
    for a = 1:3
        xmid = ( ( x(corners(a,2)) ) + x(corners(a,1)) ) / 2;
        ymid = ( ( y(corners(a,2)) ) + y(corners(a,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end
    
    % Create a length array for the 3-sided shape
    length = zeros([3 1]);

    for b = 1:3
        deltax = x(corners(b,2)) - x(corners(b,1)) ;
        deltay = y(corners(b,2)) - y(corners(b,1)) ;
        length(b) = sqrt(  deltax^2  + deltay^2 ) ;
    end
    
    if condition == 2           % Catches Trapezoids
        % 2-1 Traversal
        if corners(1,2) == corners(2,1)
            xmid = ( x(corners(1,1)) + x(corners(1,2)) )/2 ;
            ymid = ( y(corners(1,1)) + y(corners(1,2)) )/2 ;     
            deltax = xmid - xcenter ;
            deltay = ymid - ycenter ;
            if sqrt(deltax^2 + deltay^2) < min(length)/2
                string = 'Trapezoid';
            end
        else
        % 1-2 Traversal    
            if corners(2,2) == corners(3,1)
                xmid = ( x(corners(3,1)) + x(corners(3,2)) )/2 ;
                ymid = ( y(corners(3,1)) + y(corners(3,2)) )/2 ;     
                deltax = xmid - xcenter ;
                deltay = ymid - ycenter ;
                if sqrt(deltax^2 + deltay^2) < min(length)/2
                    string = 'Trapezoid';
                end
            end
        end
    end
    
    if condition <= 2       %Only tringles pass
        return
    end
    

    
    if condition == 3 
        
        % If 2-1 traversal
        deltax = x(corners(3,2)) - x(corners(2,2)) ;
        deltay = y(corners(3,2)) - y(corners(2,2)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if ( corners(1,2) == corners(2,1) && distance < min(length)/2 )
            string = 'Tringle';
            return
        end
        
        % If 1-2 traversal
        
        deltax = x(corners(3,2)) - x(corners(1,2)) ;
        deltay = y(corners(3,2)) - y(corners(1,2)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if ( corners(2,2) == corners(3,1) && distance < min(length)/2 )
            string = 'Tringle';
            return
        end
    
        if  numPar == 1
            string = 'Cross';
        end
        
        return
        
    end
      
    return;
    
end

if realsize > 4
    return
end

%% FOUR SIDED SHAPES 
%Anything beyond this point must be a square, rectangle, circle, or unknown

    for b = 1:4
        xmid = ( ( x(corners(b,2)) ) + x(corners(b,1)) ) / 2;
        ymid = ( ( y(corners(b,2)) ) + y(corners(b,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end

if (condition < 2)      %Catches circles  
    string = 'Circle';  %***All regular n-sided shapes with n > 4 are likely to be caught here as circles
    return
end

length = zeros([4 1]);


for c = 1:4
    deltax = x(corners(c,2)) - x(corners(c,1)) ;
    deltay = y(corners(c,2)) - y(corners(c,1)) ;
    length(c) = sqrt(  deltax^2  + deltay^2 ) ;
end

if condition >= 3 && numPar == 2
    if (( max(length) - min(length)) < .25* mean(length) )
        string = 'Square';
    else
        string = 'Rectangle';
    end

else
    string = 'Box Box';
end




