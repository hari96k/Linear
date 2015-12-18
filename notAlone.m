function [ TorF ] = notAlone( midx, midy, xarray, yarray, direction )

[limit,~] = size(xarray);

TorF = 0;
    if (strcmp(direction,'up'))
        for g = 1:limit
            if (( sqrt((xarray(g) - midx)^2 + (yarray(g) - midy)^2) < 10))
                TorF = 1;
            end
        end
    end
