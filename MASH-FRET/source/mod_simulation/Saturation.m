function [maxSNR, saturation_intensity] = Saturation(bitnr)

% What?
%
% Requires external files: 
%
% Created the dd of mmmm aaaa by Danny Kowerko
% Last update: 7th of March 2018 by Richard Börner
%
% Comments adapted for Boerner et al 2017

% bitnr = 14; default

% sample 1,001 values between 2^(BR-1) and 2^(BR+2)
x1 = 2^(bitnr-1):(2^(bitnr+2)-2^(bitnr-1))/1000:2^(bitnr+2);

% add numbers of values (2^1 to 2^17) representable by Bytes of sizes 1 to 17 bits
x1 = [x1 [2 4 8 16 32 64 128 256 512 1024 2048 4096 8092 8092*2 8092*4 8092*8 8092*16]];

y1 = zeros(size(x1));
for ii = 1:numel(x1)
    
    % generate 10,000 random values from a Normal distribution
    tmp = round(random('Normal',x1(ii),sqrt(x1(ii)),1,10000))';
    
    % cap pixel values to a maximum of 2^(BR-1)
    tmp(tmp>2^bitnr-1,:) = 2^bitnr-1;
    
    % store deviation
    y1(ii) = std(tmp);
end
% loglog(x1,y1,'o');

% the saturation intensity is the pixel value giving the largest
% distribution.
[ maxSNR, maxSNR_idx] = (max(y1));
saturation_intensity = x1(maxSNR_idx);

% controls
% disp('saturation')
% disp(maxSNR); 
% disp('saturation intensity')
% disp(saturation_intensity); 