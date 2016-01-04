function [ string , xcenter, ycenter] = discriminate( corners, x, y, index, traversal )


xcenter = 0;
ycenter = 0;

scale = 20;

[realsize,~] = size(corners);

string = 'Unknown' ;

if realsize == 0 || realsize == 1
    return
end

%% FINDING LENGTHS OF SIDES AND DETERMINING TRAVERSAL

length = zeros([realsize 1]);

for b = 1:realsize
    deltax = x(corners(b,2)) - x(corners(b,1)) ;
    deltay = y(corners(b,2)) - y(corners(b,1)) ;
    length(b) = sqrt(  deltax^2  + deltay^2 ) ;
end

if min(length) < 25;
    return;
end

% scale = min(length)/4;

if realsize == 3
    deltax = x(corners(b,2)) - x(corners(b,1)) ;
    deltay = y(corners(b,2)) - y(corners(b,1)) ;
    length(b) = sqrt(  deltax^2  + deltay^2 ) ;
    
end

if realsize == 2 && max(length) - min(length) < min(length)/3
    string = 'KAMEHAMEHA';      %Might be a star
    return
else if realsize == 2
        return
    end
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
if traversal == 1
    
    if abs(sideSlopes(1) - sideSlopes(3)) < abs(sideSlopes(3)*.30)
        numPar = numPar + 1;
    end

    if abs(-1/sideSlopes(1) - sideSlopes(2)) < abs(sideSlopes(2)*.30)
        numPerp = numPerp + 1;
    end

    if abs(-1/sideSlopes(2) - sideSlopes(3)) < abs(sideSlopes(3)*.30)
        numPerp = numPerp + 1;
    end
    
    if numPar == 1 && numPerp == 1
        numPerp = 2;                        % If perp to one, perp to the other
    end



% 2-1 Traversal
else if traversal == 2 && realsize == 3
    
        if abs(sideSlopes(2) - sideSlopes(3)) < abs(sideSlopes(3)*.30)
            numPar = numPar + 1;
        end

        if abs(-1/sideSlopes(1) - sideSlopes(2)) < abs(sideSlopes(2)*.30)
            numPerp = numPerp + 1;
        end

        if abs(-1/sideSlopes(2) - sideSlopes(3)) < abs(sideSlopes(3)*.30)
            numPerp = numPerp + 1;
        end

        if numPar == 1 && numPerp == 1
            numPerp = 2;                        % If perp to one, perp to the other
        end
        
    else
        
        %4 sided shapes
        if abs(sideSlopes(1) - sideSlopes(4)) < abs(sideSlopes(4)*.30)
            numPar = numPar + 1;
        end
        
        if abs(sideSlopes(2) - sideSlopes(3)) < abs(sideSlopes(3)*.30)
            numPar = numPar + 1;
        end
    end
end


%% FINDING CENTERS

xEdges = x(index(index ~= 0));
yEdges = y(index(index ~= 0));

[numNeigh,~] = size(xEdges);


for e = 1:numNeigh
    xcenter = xcenter + x(index(e));
    ycenter = ycenter + y(index(e));
end

xcenter = xcenter/numNeigh;
ycenter = ycenter/numNeigh;

[numTotal, ~] = size(x);


t_xcenter = 0;
t_ycenter = 0;
for f = 1:numTotal
    t_xcenter = t_xcenter + x(f);
    t_ycenter = t_ycenter + y(f);
end

t_xcenter = t_xcenter/numTotal;
t_ycenter = t_ycenter/numTotal;

%% THREE-SIDED SHAPES

condition = 0;


if realsize == 3
    
    if corners(1,2) == corners(2,2)
        string = 'KAMEHAMEHA';
        return
    end
       
    
    % Checking if mid-points of sides are not alone
    for a = 1:3
        xmid = ( ( x(corners(a,2)) ) + x(corners(a,1)) ) / 2;
        ymid = ( ( y(corners(a,2)) ) + y(corners(a,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges, scale );    
    end
    
%     % Create a length array for the 3-sided shape
%     % Lasted this far? Give yourself a treat: https://www.youtube.com/watch?v=uEiDBFu8FIw&list=PLRBp0Fe2GpgmsW46rJyudVFlY6IYjFBIK&index=18
%     length = zeros([3 1]);
% 
%     for b = 1:3
%         deltax = x(corners(b,2)) - x(corners(b,1)) ;
%         deltay = y(corners(b,2)) - y(corners(b,1)) ;
%         length(b) = sqrt(  deltax^2  + deltay^2 ) ;
%     end
    
    if condition == 2           % Catches Trapezoids and Stars
        % 2-1 Traversal
        if traversal == 2
            if length(1)<length(2)
                trapSide = 2;
            else
                trapSide = 1;
            end
            xmid = ( x(corners(trapSide,1)) + x(corners(trapSide,2)) )/2 ;
            ymid = ( y(corners(trapSide,1)) + y(corners(trapSide,2)) )/2 ;     
            deltax = xmid - t_xcenter ;
            deltay = ymid - t_ycenter ;
            if sqrt(deltax^2 + deltay^2) < min(length)/2 && ~notAlone( xcenter , ycenter , xEdges, yEdges, scale )
                    string = 'Trapezoid';
                    return;
            end
            xmid = ( x(corners(2,2)) + x(corners(3,2)) )/2 ;
            ymid = ( y(corners(2,2)) + y(corners(3,2)) )/2 ;     
            deltax = xmid - t_xcenter ;
            deltay = ymid - t_ycenter ;
            if sqrt(deltax^2 + deltay^2) < min(length)/3 && notAlone( xcenter , ycenter , xEdges, yEdges, scale )
                    string = 'Star';
                    return;
            end            
            
        else
        % 1-2 Traversal    
            if traversal == 1
                if length(2)<length(3)
                    trapSide = 3;
                else
                    trapSide = 2;
                end
                xmid = ( x(corners(trapSide,1)) + x(corners(trapSide,2)) )/2 ;
                ymid = ( y(corners(trapSide,1)) + y(corners(trapSide,2)) )/2 ;     
                deltax = xmid - t_xcenter ;
                deltay = ymid - t_ycenter ;
                if sqrt(deltax^2 + deltay^2) < min(length)/2 && ~notAlone( xcenter , ycenter , xEdges, yEdges, scale )
                    string = 'Trapezoid';
                    return;
                end
                xmid = ( x(corners(1,2)) + x(corners(3,2)) )/2 ;
                ymid = ( y(corners(1,2)) + y(corners(3,2)) )/2 ;     
                deltax = xmid - t_xcenter ;
                deltay = ymid - t_ycenter ;
                if sqrt(deltax^2 + deltay^2) < min(length)/3 && notAlone( xcenter , ycenter , xEdges, yEdges, scale )
                        string = 'Star';
                        return;
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
        
        if ( traversal == 2 && distance < min(length)/2 )
            string = 'Tringle';
            return
        end
        
        % If 1-2 traversal
        
        deltax = x(corners(3,2)) - x(corners(1,2)) ;
        deltay = y(corners(3,2)) - y(corners(1,2)) ;
        distance = sqrt(deltax^2 + deltay^2) ;
        
        if ( traversal == 1 && distance < min(length)/2 )
            string = 'Tringle';
            return
        end
    
        if  numPar == 1 && numPerp == 2
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
%Anything beyond this point must be a square, rectangle, circle, trapezoid or unknown
    
    centersAllign = 0;
    deltax = xcenter - t_xcenter;
    deltay = ycenter - t_ycenter;
    distance = sqrt(  deltax^2  + deltay^2 ) ;
    
    if distance < min(length)/2
        centersAllign = 1;
    end

    endGreetings = 0;
    deltax = x(corners(2,2)) - x(corners(4,2)) ;
    deltay = y(corners(2,2)) - y(corners(4,2)) ;
    distance = sqrt(  deltax^2  + deltay^2 ) ;
    
    if distance < min(length)/2
        endGreetings = 1;
    end
    
    for b = 1:4
        xmid = ( ( x(corners(b,2)) ) + x(corners(b,1)) ) / 2;
        ymid = ( ( y(corners(b,2)) ) + y(corners(b,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges, scale );    
    end

if condition < 2 && centersAllign     %Catches circles  
    string = 'Circle';  %***All regular n-sided shapes with n > 4 are likely to be caught here as circles
    return
end

% length = zeros([4 1]);
% 
% 
% for c = 1:4
%     deltax = x(corners(c,2)) - x(corners(c,1)) ;
%     deltay = y(corners(c,2)) - y(corners(c,1)) ;
%     length(c) = sqrt(  deltax^2  + deltay^2 ) ;
% end

if condition >= 3 && endGreetings == 1 && numPar == 2
    if (( max(length) - min(length)) < .25* mean(length) )
        string = 'Square';
    else
        string = 'Rectangle';
    end

else if condition >= 3 && endGreetings == 1 && numPar == 1
        string = 'Trapezoid';
    end
     
end

