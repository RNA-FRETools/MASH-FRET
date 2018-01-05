function peaks = isScreen(img, nbMax, thresh, darkArea)
% Target bright spots by "in-serie" screening of the image and return their
% coordinates.
% "img" >> image
% "nbMax" >> maximum number of spot to find
% "thresh" >> minimum intensity of spots
% "darkArea" >> dimension of the zone around the bright spot to set to
% zero
% "peaks" >> [n-by-2] matrix, contains x,y coordinates of targetted spots

% Requires external functions: isScreen, loading_bar, spotGaussFit
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

ok = 0;
n = 0;
peaks = [];

if nbMax
    while ~ok
        n = n + 1;
        if n == nbMax
            ok = 1;
        end
        [r, c, o] = find(img == max(max(img)));
        if img(r(1,1),c(1,1)) > thresh
            peaks((size(peaks,1) + 1),1) = c(1,1) - 0.5; %x
            peaks((size(peaks,1)),2) = r(1,1) - 0.5; %y
            peaks((size(peaks,1)),3) = img(r(1,1),c(1,1)); %I
            if r(1,1)-(darkArea(2)-1)/2 > 0
                yInf = r(1,1)-(darkArea(2)-1)/2;
            else
                yInf = 1;
            end
            if r(1,1)+(darkArea(2)-1)/2 <= size(img,1)
                ySup = r(1,1)+(darkArea(2)-1)/2;
            else
                ySup = size(img,1);
            end
            if c(1,1)-(darkArea(1)-1)/2 >= 1
                xInf = c(1,1)-(darkArea(1)-1)/2;
            else
                xInf = 1;
            end
            if c(1,1)+(darkArea(1)-1)/2 <= size(img,2)
                xSup = c(1,1)+(darkArea(1)-1)/2;
            else
                xSup = size(img,2);
            end
            img(yInf:ySup, xInf:xSup) = 0;
        else
            ok = 1;
        end
    end
end
