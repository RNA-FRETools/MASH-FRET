function avesResized = BgCorr_ha32(dimMov, int)
% Calculate the background image from input image according to Ha's
% IDL script.
% "int" >> raw image
% "dimMov" >> [1-by-2] vector, contains x and y image dimension
% "avesResized" >> background image

% Requires external function: smoothn, inImgLimits, resizemBilinear
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

temp1 = int;
temp1 = smoothn(temp1, 3);
film_x = dimMov(1);
film_y = dimMov(2);
ay = round(sqrt(film_y));
by = round(round(sqrt(film_y))/2);
ax = round(sqrt(film_x));
bx = round(round(sqrt(film_x))/2);
aves = zeros(ay, ax);
for i = by:ay:film_y
    for j = ax:bx:film_x
        if inImgLimits(i, j, ay, ax, by, bx, film_x, film_y)
            aves(fix((i - by)/ay) + 1, fix((j - bx)/ax) + 1) = min(min(temp1((i - by + 1):(i + by), (j - bx + 1):(j + bx))));
        end
    end
end

squaresAves = resizemBilinear(aves, [ax ay]);
sizeX_cube = size(squaresAves{1,1}, 2);
sizeY_cube = size(squaresAves{1,1}, 1);
nbsquaresX = size(squaresAves, 2);
nbsquaresY = size(squaresAves, 1);
for ii = 0:(nbsquaresX - 1)
    for jj = 0:(nbsquaresY - 1)
        avesResized1(((sizeY_cube - 1)*jj + 1):((sizeY_cube - 1)*jj + sizeY_cube), ((sizeX_cube - 1)*ii + 1):((sizeX_cube - 1)*ii + sizeX_cube)) = squaresAves{(jj + 1),(ii + 1)};
    end
end

avesResized = avesResized1(1:film_y, 1:film_x);
avesResized = smoothn(avesResized,7);


function squares = resizemBilinear(mat2Resize, factors)
% sample the input image in regular squares of average intensity
% "factors" >> [1-by-2] vector, contains number of squares in x and y
% directions
% "mat2Resize" >> image to sample
% "squares" >> sampled image

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

if size(factors,2) > 1
    factorX = factors(1);
    factorY = factors(2);
elseif size(factors,2) == 1
    factorX = factors;
    factorY = factors;
else
    disp('Wrong size of the factors input variable.')
end

nbIntervalsX = factorX - 1;
nbIntervalsY = factorY - 1;
sizeX_Ini = size(mat2Resize, 2);
sizeY_Ini = size(mat2Resize, 1);
sizeX_Final = factorX*sizeX_Ini;
sizeY_Final = factorY*sizeY_Ini;
sizeX_Cube = (sizeX_Final - sizeX_Ini)/nbIntervalsX + 2;
sizeY_Cube = (sizeY_Final - sizeY_Ini)/nbIntervalsY + 2;
for jCube = 1:nbIntervalsX
    for iCube = 1:nbIntervalsY
        for xC = 0:(sizeX_Cube - 1)
            for yC = 0:(sizeY_Cube - 1)
                squares{iCube, jCube}((yC + 1), (xC + 1)) = mat2Resize(iCube,jCube)*(1-xC/(sizeX_Cube - 1))*(1-yC/(sizeY_Cube - 1)) + mat2Resize(iCube,jCube+1)*(xC/(sizeX_Cube - 1))*(1-yC/(sizeY_Cube - 1)) + mat2Resize(iCube+1,jCube)*(yC/(sizeY_Cube - 1))*(1-xC/(sizeX_Cube - 1)) + mat2Resize(iCube+1,jCube+1)*(xC/(sizeX_Cube - 1))*(yC/(sizeY_Cube - 1));
            end
        end
    end
end



function inLimits = inImgLimits(i, j, ay, ax, by, bx, film_x, film_y)
% Check for correct image limits

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

inLimits = 0;
if ((fix((i - by)/ay) + 1) > 0 && ...
   (fix((i - by)/ay) + 1) <= ay && ...
   (fix((j - bx)/ax) + 1) > 0 && ...
   (fix((j - bx)/ax) + 1) <= ax && ...
   (i - by + 1) > 0 && ...
   (i - by + 1) <= film_y && ...
   (i + by) > 0 && ...
   (i + by) <= film_y && ...
   (j - bx + 1) > 0 && ...
   (j - bx + 1) <= film_x && ...
   (j + bx) > 0 && ...
   (j + bx) <= film_x)

    inLimits = 1;
end
