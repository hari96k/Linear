function [ startxarray, startyarray, endxarray, endyarray ] = damnStraight( xarray, yarray, slopearray )

i = 2;

startxarray(1) = xarray(2);
startyarray(1) = yarray(2);

while ( abs ( slopearray(2) - slopearray(i+1) ) < 1.5 )
    i = i + 1;
end

endxarray(1) = xarray(i);
endyarray(1) = yarray(i);


% for n = 1:i
%    modearray(n) = slopearray(n);
% end
% 
% slopearray(1) = mode(modearray);



m = i;

startxarray(2) = endxarray(1);
startyarray(2) = endyarray(1);


% while ( abs ( slopearray(m) - slopearray(i+1) ) < 1.5 )
%     i = i + 1;
% end

endxarray(2) = xarray(19);
endyarray(2) = yarray(19);

%  for n = m:19
%     modearray(n) = slopearray(n);
%  end
% 
% slopearray(1) = mode(modearray);



end

