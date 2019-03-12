function corrImg = updateBgCorr(img, h_fig)
% Apply background correction to input image and return the corrected
% image.
% "img" >> input raw image
% "h_fig" >> MASH figure handle
% "corrImg" >> corrected image

% Requires external functions: applyBg
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
corrImg = img;

if ~isempty(h.param.movPr.bgCorr)
    nCorr = size(h.param.movPr.bgCorr, 1);
    for i = 1:nCorr
        bgType = h.param.movPr.bgCorr{i,1};
        corrImg = applyBg(bgType, i, corrImg, h);
    end
end


function img = applyBg(bgType, n, img, h)
% Determine and subtract background to input image.

% Requires external functions: FilterArray, determine_bg, createAveIm,
%                              BgCorr_ha32, bpass, getFrames.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

nChan = h.param.movPr.nChan;
sub_w = floor(h.movie.pixelX/nChan);
lim = [1 (1:nChan-1)*sub_w h.movie.pixelX];
bgCorr = h.param.movPr.bgCorr;
movBg_p = h.param.movPr.movBg_p;

for i = 1:nChan
    int = img(:,lim(i):lim(i+1));
    
    % image filters: gaussian, outlier, ggf, lwf, gwf, 
    % histotresh, simpletresh
    if sum(double(bgType == [2 5:10])) 
        myfilter(1).filter = h.param.movPr.movBg_myfilter{bgType};
        myfilter(1).P1 = bgCorr{n,i+1}(1);
        myfilter(1).P2 = bgCorr{n,i+1}(2);
        int = FilterArray(int, myfilter);
        img(:,lim(i):lim(i+1)) = int;
        
    elseif bgType == 3 % mean filter
        img(:,lim(i):lim(i+1)) = filter2(ones(bgCorr{n,i+1}(1))/ ...
            (bgCorr{n,i+1}(1)^2),int);
        
    elseif bgType == 4 % median filter
        img(:,lim(i):lim(i+1)) = medfilt2(int, [bgCorr{n,i+1}(1) ...
            bgCorr{n,i+1}(1)]);
    
    % mean, most frequent or histotresh
    elseif sum(double(bgType == [11 12 13])) 

        [Max,Bg_HWHM] = determine_bg(bgType, int, bgCorr{n,i+1});
        tol = bgCorr{n,i+1}(1);
        bg = Max + tol * Bg_HWHM;
        
        if sum(double(bgType == [11 12]))
            int(int<bg) = bg;
        end
        img(:,lim(i):lim(i+1)) = int - bg;


    elseif bgType == 14 % Ha-all
        if ~isfield(h.movie, 'avImg')
            param.start = 1; % start data
            param.stop = h.movie.framesTot; % stop data
            param.iv = 1; % interval averaged
            param.file = [h.movie.path h.movie.file]; % path + file
            % {file cursor, dimension WxH, movie length}
            param.extra{1} = h.movie.speCursor; 
            param.extra{2} = [h.movie.pixelX h.movie.pixelY]; 
            param.extra{3} = h.movie.framesTot;
            [h.movie.avImg ok] = createAveIm(param, 0, h.figure_MASH);
            if ~ok
                return;
            end
            guidata(h.figure_MASH, h);
        end
        bg = BgCorr_ha32([h.movie.pixelX h.movie.pixelY],h.movie.avImg)-10;
        img(:,lim(i):lim(i+1)) = img(:,lim(i):lim(i+1))- ...
            bg(:,lim(i):lim(i+1));
        
    elseif bgType == 15 % Ha-each
        bg = BgCorr_ha32([h.movie.pixelX h.movie.pixelY],img)-10;
        img(:,lim(i):lim(i+1)) = img(:,lim(i):lim(i+1))- ...
            bg(:,lim(i):lim(i+1));
    
    elseif bgType == 16 % empty function 1: Twotone
        tol = bgCorr{n,i+1}(1);
        noise = bgCorr{n,i+1}(2);
        int = bpass(int, noise, tol);
        int([1:tol size(int,1)-tol+1:size(int,1)],:) = 0;
        int(:,[1:tol size(int,2)-tol+1:size(int,2)]) = 0;
        img(:,lim(i):lim(i+1)) = int;
        
    elseif bgType == 17 % empty function 2: subtract image
        dat2sub = movBg_p{bgType,1};
        if h.movie.frameCurNb < dat2sub.frameLen
            [data ok] = getFrames(dat2sub.file, h.movie.frameCurNb, ...
                {dat2sub.fCurs, [dat2sub.pixelX dat2sub.pixelY], ...
                dat2sub.frameLen}, h.figure_MASH);
            int = data.frameCur(:,lim(i):lim(i+1));
            img(:,lim(i):lim(i+1)) = img(:,lim(i):lim(i+1)) - int;
        elseif dat2sub.frameLen == 1
            [data ok] = getFrames(dat2sub.file, 1, {dat2sub.fCurs, ...
                [dat2sub.pixelX dat2sub.pixelY], dat2sub.frameLen}, ...
                h.figure_MASH);
            int = data.frameCur(:,lim(i):lim(i+1));
            img(:,lim(i):lim(i+1)) = img(:,lim(i):lim(i+1)) - int;
        end
        
    elseif bgType == 18 % multiplication
        fact = bgCorr{n,i+1}(1);
        img(:,lim(i):lim(i+1)) = int*fact;
        
    elseif bgType == 19 % addition
        os = bgCorr{n,i+1}(1);
        img(:,lim(i):lim(i+1)) = int + os;
        
    end
end

