function [bgI,bgStd] = determine_bg(method, img, p)
% Determine and return constant background intensity and the standard
% deviation
% "method" >> background calculation method
% "img" >> input image
% "p" >> parameters for background calculation
% "bgI" >> Background intensity
% "bgStd" >> background standard deviation

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

img = double(img);

switch method
    case 11 % mean
        tol = p(1);
        I = double(img);
        Binom = mean(I(:)) + tol*std(I(:));
        BinomFilter = I;
        BinomFilter(I>Binom)=0;
        NZBinom = nonzeros(BinomFilter);
        StdBinom = std(NZBinom);
        bgI = mean(NZBinom(:));  
%         bgStd = StdBinom*2.3548/2;
        bgStd = StdBinom*sqrt(2*log(2)); % HWHM
        
    case 12 % most frequent
        n_bin = p(2);
        img = reshape(img,1,numel(img));
        [maxVal,o] = max(img);
        [minVal,o] = min(img);
        iv = linspace(minVal, maxVal, n_bin);
        P = hist(img,iv);
        [MAXHIST,Max_index] = max(P);
        bgI = iv(Max_index);  
        i = 1;
        while P(i) <= MAXHIST/2
            i = i + 1;
        end
        bgStd = iv(Max_index) - iv(i);
        
    case 13 % histothresh

        thresh = p(2);
        N = numel(img);
        
        img = reshape(img,1,N);
        img = sort(img);
        [P,pixval] = histcounts(img,[0:max(img)+1]);
        cumP = cumsum(P);
        cumP = cumP/max(cumP);
        
%         cumP = (1:N)/N;
%         [img,id,o] = unique(img);
%         cumP = cumP(id);
% 
%         [o,i,o] = find(cumP>=thresh);
%         i = i(1);
%         if i==1
%             i = 2;
%         end
%         
%         cumP_lower = thresh - cumP(i-1);
%         cumP_length = cumP(i) - cumP(i-1);
%         bgI = img(i-1) + (img(i)-img(i-1))*cumP_lower/cumP_length;

%         cumP = 1/(N*2):(1/N):1; % DK
        
        if sum(cumP==thresh)==1 % DK
%            bgI = img(cumP==thresh); % DK
           bgI = pixval(cumP==thresh); % DK

        else
            i = find(diff(cumP>thresh)==1); % DK
            perc = (thresh-cumP(i))/(cumP(i+1)-cumP(i)); % DK
%             bgI = (1-perc)*img(i)+(perc)*img(i+1); % DK
            bgI = (1-perc)*pixval(i)+(perc)*pixval(i+1); % DK
        end
        
        [o,j,o] = find(cumP>=(thresh*(1-0.6827))); % thresh - 1 sigma
        j = j(1);
        if j==1
            j = 2;
        end
        
        cumP30_lower = thresh*(1-0.6827) - cumP(j-1);
        cumP30_length = cumP(j) - cumP(j-1);
%         sig = img(j-1) + ...
%             (img(j)-img(j-1))*cumP30_lower/cumP30_length;
        sig = pixval(j-1) + ...
            (pixval(j)-pixval(j-1))*cumP30_lower/cumP30_length;
%         bgStd = (bgI-sig)*2.3548/2;
        bgStd = (bgI-sig)*sqrt(2*log(2)); % HWHM
        
    case 14 % N most probable
        vals = median(img,1);
        bgI = mean(vals);
        bgStd = std(vals);
        
    case 15 % median value
        switch p(1)
            case 1
                bgI = median(median(img,1),2);
            case 2
                bgI = mean([median(median(img,1),2) ...
                    median(median(img,2),1)]);
        end
        
        bgStd = std(double(min(img(:,:))));
        
end

