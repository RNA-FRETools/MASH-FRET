function [img,avImg] = updateBgCorr(img, p, h_mov, h_fig)
% [img,avImg] = updateBgCorr(img, p, h_mov)
%
% Apply image filters to input video frame.
% When using "Ha-all" filter, the actual average image is returned
%
% img: video frame
% p: structure containg processing parameters
% h_mov: structure containing video parameters
% avImg: average image

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

if ~isempty(p.bgCorr)
    nCorr = size(p.bgCorr, 1);
    for i = 1:nCorr
        [img,avImg] = applyBg(p.bgCorr(i,:), img, p, h_mov, h_fig);
    end
end


function [img,avImg] = applyBg(prm, img, p, h_mov, h_fig)
% [img,avImg] = applyBg(meth, n, img, h_mov)
%
% Apply input image filter to input image.
% When using "Ha-all" filter, the actual average image is returned
%
% prm: {1-by-nChan} channel-specific filter configuration
% img: video frame
% p: structure conatining processing parameters
% h_mov: structure containing video parameters
% h_fig: handle to main figure
% avImg: averaged image
%
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% get video parameters
resX = h_mov.pixelX;
resY = h_mov.pixelY;
L = h_mov.framesTot;
l = h_mov.frameCurNb;
videoFile = [h_mov.path h_mov.file];
fcurs = h_mov.speCursor;
if isfield(h_mov, 'avImg')
    avImg = h_mov.avImg;
else
    avImg = [];
end

% get processing parameters
meth = prm{1};
nChan = p.nChan;
movBg_p = p.movBg_p;

% get channel limits
sub_w = floor(resX/nChan);
lim = [0 (1:nChan-1)*sub_w resX];

for i = 1:nChan
    frames = (lim(i)+1):lim(i+1);
    int = img(:,frames);
    
    if sum(meth==[2 5:10]) % gaussian, outlier, ggf, lwf, gwf, histotresh, simpletresh
        myfilter(1).filter = p.movBg_myfilter{meth};
        myfilter(1).P1 = prm{i+1}(1);
        myfilter(1).P2 = prm{i+1}(2);
        int = FilterArray(int, myfilter);
        img(:,frames) = int;
        
    elseif meth==3 % mean filter
        img(:,frames) = filter2(ones(prm{i+1}(1))/(prm{i+1}(1)^2),int);
        
    elseif meth==4 % median filter
        img(:,frames) = medfilt2(int, [prm{i+1}(1) prm{i+1}(1)]);

    elseif sum(meth==[11 12 13]) % mean, most frequent or histotresh

        [Max,Bg_HWHM] = determine_bg(meth, int, prm{i+1});
        tol = prm{i+1}(1);
        bg = Max + tol * Bg_HWHM;
        
        if sum(double(meth == [11 12]))
            int(int<bg) = bg;
        end
        img(:,frames) = int - bg;


    elseif meth==14 % Ha-all
        if isempty(avImg)
            param.start = 1; % start data
            param.stop = L; % stop data
            param.iv = 1; % interval averaged
            param.file = videoFile; % path + file
            % {file cursor, dimension WxH, movie length}
            param.extra{1} = fcurs; 
            param.extra{2} = [resX resY]; 
            param.extra{3} = L;
            [avImg,ok] = createAveIm(param, 0, h_fig);
            if ~ok
                return
            end
        end
        bg = BgCorr_ha32([resX resY],avImg)-10;
        img(:,frames) = img(:,frames)-bg(:,frames);
        
    elseif meth==15 % Ha-each
        bg = BgCorr_ha32([resX resY],img)-10;
        img(:,frames) = img(:,frames)-bg(:,frames);
    
    elseif meth == 16 % empty function 1: Twotone
        tol = prm{i+1}(1);
        noise = prm{i+1}(2);
        int = bpass(int, noise, tol);
        int([1:tol size(int,1)-tol+1:size(int,1)],:) = 0;
        int(:,[1:tol size(int,2)-tol+1:size(int,2)]) = 0;
        img(:,frames) = int;
        
    elseif meth == 17 % empty function 2: subtract image
        dat2sub = movBg_p{meth,1};
        if l<dat2sub.frameLen
            [data,ok] = getFrames(dat2sub.file, l, ...
                {dat2sub.fCurs, [dat2sub.pixelX dat2sub.pixelY], ...
                dat2sub.frameLen}, h_fig);
            if ~ok
                return
            end
            int = data.frameCur(:,frames);
            img(:,frames) = img(:,frames) - int;
        elseif dat2sub.frameLen == 1
            [data,ok] = getFrames(dat2sub.file, 1, {dat2sub.fCurs, ...
                [dat2sub.pixelX dat2sub.pixelY], dat2sub.frameLen}, h_fig);
            if ~ok
                return
            end
            int = data.frameCur(:,frames);
            img(:,frames) = img(:,frames) - int;
        end
        
    elseif meth == 18 % multiplication
        fact = prm{i+1}(1);
        img(:,frames) = int*fact;
        
    elseif meth == 19 % addition
        os = prm{i+1}(1);
        img(:,frames) = int + os;
        
    end
end

