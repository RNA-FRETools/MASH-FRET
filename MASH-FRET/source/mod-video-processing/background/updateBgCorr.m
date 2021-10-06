function [img,avImg] = updateBgCorr(img, p, h_fig)
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

% initialize output
proj = p.curr_proj;
avImg = p.proj{proj}.aveImg{1};
prm = p.proj{proj}.VP;

if ~isempty(prm.bgCorr)
    nCorr = size(prm.bgCorr, 1);
    for i = 1:nCorr
        [img,avImg] = applyBg(prm.bgCorr(i,:), img, p.proj{proj}, ...
            p.VP.curr_frame(proj), h_fig);
    end
end


function [img,aveImg] = applyBg(prmBg, img, p_proj, l, h_fig)
% [img,aveImg] = applyBg(prm, img, p_proj, l, h_fig)
%
% Apply input image filter to input image.
% When using "Ha-all" filter, the actual average image is returned
%
% prm: {1-by-nChan} channel-specific filter configuration
% img: video frame
% p: structure conatining processing parameters
% p_proj: structure containing experiment settings
% l: current frame index
% h_fig: handle to main figure
% aveImg: averaged image
%
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% get video parameters
nChan = p_proj.nb_channel;
resX = p_proj.movie_dat{2}(1);
resY = p_proj.movie_dat{2}(2);
L = p_proj.movie_dat{3};
videoFile = p_proj.movie_file;
fcurs = p_proj.movie_dat{1};
aveImg = p_proj.aveImg{1};
prm = p_proj.VP;

% get processing parameters
meth = prmBg{1};
movBg_p = prm.movBg_p;

% get channel limits
sub_w = floor(resX/nChan);
lim = [0 (1:nChan-1)*sub_w resX];

for i = 1:nChan
    frames = (lim(i)+1):lim(i+1);
    int = img(:,frames);
    
    if sum(meth==[2 5:10]) % gaussian, outlier, ggf, lwf, gwf, histotresh, simpletresh
        disp(['This filter is not available because of library issues: ',...
            'the applied filter has no effect']);
%         % check for correct compilation of mex file 
%         if exist('FilterArray','file')~=3
%             pnameC = fileparts(which('FilterArray.c'));
%             if strcmp(computer,'PCWIN') || strcmp(computer,'GLNX86') % 32bit OS
%                 pnameMex = [pnameC,filesep,'..',filesep,'runtime32'];
%                 cd(pnameMex);
%                 mex('-R2018a',[pnameC,filesep,'FilterArray.c'],...
%                     ['-L',pnameC,filesep,'lib'],'-lITASL32');
%             elseif strcmp(computer,'PCWIN64') || strcmp(computer,'GLNX64') % 64bit OS
%                 pnameMex = [pnameC,filesep,'..',filesep,'runtime64'];
%                 cd(pnameMex);
%                 mex('-R2018a',[pnameC,filesep,'FilterArray.c'],...
%                     ['-L',pname,filesep,'lib'],'-lITASL64');
%             end
%         end
%         myfilter.filter = p.movBg_myfilter{meth};
%         myfilter.P1 = prm{i+1}(1);
%         myfilter.P2 = prm{i+1}(2);
%         int = FilterArray(int, myfilter);
%         img(:,frames) = int;
        
    elseif meth==3 % mean filter
        img(:,frames) = filter2(ones(prmBg{i+1}(1))/(prmBg{i+1}(1)^2),int);
        
    elseif meth==4 % median filter
        img(:,frames) = medfilt2(int, [prmBg{i+1}(1) prmBg{i+1}(1)]);

    elseif sum(meth==[11 12 13]) % mean, most frequent or histotresh

        [Max,Bg_HWHM] = determine_bg(meth, int, prmBg{i+1});
        tol = prmBg{i+1}(1);
        bg = Max + tol * Bg_HWHM;
        
        if sum(double(meth == [11 12]))
            int(int<bg) = bg;
        end
        img(:,frames) = int - bg;


    elseif meth==14 % Ha-all
        if isempty(aveImg)
            param.start = 1; % start data
            param.stop = L; % stop data
            param.iv = 1; % interval averaged
            param.file = videoFile; % path + file
            % {file cursor, dimension WxH, movie length}
            param.extra{1} = fcurs; 
            param.extra{2} = [resX resY]; 
            param.extra{3} = L;
            [aveImg,ok] = createAveIm(param,false,true,h_fig);
            if ~ok
                return
            end
        end
        bg = BgCorr_ha32([resX resY],aveImg)-10;
        img(:,frames) = img(:,frames)-bg(:,frames);
        
    elseif meth==15 % Ha-each
        bg = BgCorr_ha32([resX resY],img)-10;
        img(:,frames) = img(:,frames)-bg(:,frames);
    
    elseif meth == 16 % empty function 1: Twotone
        tol = prmBg{i+1}(1);
        noise = prmBg{i+1}(2);
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
        fact = prmBg{i+1}(1);
        img(:,frames) = int*fact;
        
    elseif meth == 19 % addition
        os = prmBg{i+1}(1);
        img(:,frames) = int + os;
        
    end
end

