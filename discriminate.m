function [ string ] = discriminate( corners, x, y, index )



[realsize,~] = size(corners);

string = 'Unknown' ;

if realsize == 1 || realsize == 2
    string = 'Line';
    return
end


% if realsize == 2 ;
%     string = 'Trap Queen';
%     return
% end

condition = 0;
xEdges = x(index(index ~= 0));
yEdges = y(index(index ~= 0));

if realsize == 3
    
    if corners(1,2) == corners(2,2)
        string = 'Trap Queen';
        return
    end
       
    
    % Checking if mid-points are not alone
    for a = 1:3
        xmid = ( ( x(corners(a,2)) ) + x(corners(a,1)) ) / 2;
        ymid = ( ( y(corners(a,2)) ) + y(corners(a,1)) ) / 2;

        condition = condition + notAlone( xmid , ymid , xEdges, yEdges );    
    end
    
    if condition < 2
        return
    end
    
    if condition == 2
        string = 'Trapezoid';
    end
    
    % Create a length array for the 3-sided shape
    length = zeros([3 1]);

    for b = 1:3
        deltax = x(corners(b,2)) - x(corners(b,1)) ;
        deltay = y(corners(b,2)) - y(corners(b,1)) ;
        length(b) = sqrt(  deltax^2  + deltay^2 ) ;
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
    
        string = 'Box Box';
        return
        
    end
      
    return;
    
end

if realsize > 4
    return
end

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

if condition >= 3
    if (( max(length) - min(length)) < .25* mean(length) )
        string = 'Square';
    else
        string = 'Rectangle';
    end

else
    string = 'Box Box';
end




