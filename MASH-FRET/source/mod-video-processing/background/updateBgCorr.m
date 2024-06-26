function img = updateBgCorr(img, p, h_fig, varargin)
% img = updateBgCorr(img, p, h_fig)
% img = updateBgCorr(img, p, h_fig, chan)
%
% Apply image filters to input video frame.
%
% img: video frame
% p: structure containg processing parameters
% h_fig: handle to main figure
% chan: channel corresponding to of input image

% Last update: 5th of February 2014 by M�lodie C.A.S Hadzic

% collect video processing parameters
t = p.movPr.curr_frame(p.curr_proj);
curr = p.proj{p.curr_proj}.VP.curr;
bgfilt = curr.edit{1}{4};

if ~isempty(varargin)
    chan = varargin{1};
else
    chan = 0;
end

if ~isempty(bgfilt)
    nCorr = size(bgfilt, 1);
    for i = 1:nCorr
        img = applyBg(bgfilt(i,:),img,p.proj{p.curr_proj},t,h_fig,chan);
    end
end


function img = applyBg(prmBg, img, p_proj, l, h_fig, chan)
% img = applyBg(prm, img, p_proj, l, h_fig, chan)
%
% Apply input image filter to input image.
%
% prm: {1-by-nChan} channel-specific filter configuration
% img: video frame
% p: structure conatining processing parameters
% p_proj: structure containing experiment settings
% l: current frame index
% h_fig: handle to main figure
% chan: channel to be processed (0 if all channels must be processed)
%
% Last update: 5th of February 2014 by M�lodie C.A.S Hadzic

% get video parameters
nChan = p_proj.nb_channel;

% get processing parameters
meth = prmBg{1};

if chan==0
    channels = 1:nChan;
else
    channels = chan;
end

for i = channels
    
    if numel(channels)==1
        resX = p_proj.movie_dat{i}{2}(1);
        resY = p_proj.movie_dat{i}{2}(2);
        aveImg = p_proj.aveImg{i,1};
        lim = [1 resX];
    else
        resX = p_proj.movie_dat{1}{2}(1);
        resY = p_proj.movie_dat{1}{2}(2);
        aveImg = p_proj.aveImg{1,1};
        sub_w = floor(resX/nChan);
        lim = [(i-1)*sub_w+1 i*sub_w];
    end
    
    x = lim(1):lim(2);
    int = img(:,x);
    
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
        img(:,x) = filter2(ones(prmBg{i+1}(1))/(prmBg{i+1}(1)^2),int);
        
    elseif meth==4 % median filter
        img(:,x) = medfilt2(int, [prmBg{i+1}(1) prmBg{i+1}(1)]);

    elseif sum(meth==[11 12 13]) % mean, most frequent or histotresh

        [Max,Bg_HWHM] = determine_bg(meth, int, prmBg{i+1});
        tol = prmBg{i+1}(1);
        bg = Max + tol * Bg_HWHM;
        
        if sum(double(meth == [11 12]))
            int(int<bg) = bg;
        end
        img(:,x) = int - bg;


    elseif meth==14 % Ha-all
        bg = BgCorr_ha32([resX resY],aveImg)-10;
        img(:,x) = img(:,x)-bg(:,x);
        
    elseif meth==15 % Ha-each
        bg = BgCorr_ha32([resX resY],img)-10;
        img(:,x) = img(:,x)-bg(:,x);
    
    elseif meth == 16 % empty function 1: Twotone
        tol = prmBg{i+1}(1);
        noise = prmBg{i+1}(2);
        int = bpass(int, noise, tol);
        int([1:tol size(int,1)-tol+1:size(int,1)],:) = 0;
        int(:,[1:tol size(int,2)-tol+1:size(int,2)]) = 0;
        img(:,x) = int;
        
    elseif meth == 17 % empty function 2: subtract image
        dat2sub = prmBg{2};
        if l<dat2sub.frameLen
            [data,ok] = getFrames(dat2sub.file, l, ...
                {dat2sub.fCurs, [dat2sub.pixelX dat2sub.pixelY], ...
                dat2sub.frameLen}, h_fig);
            if ~ok
                return
            end
            int = data.frameCur(:,x);
            img(:,x) = img(:,x) - int;
            
        elseif dat2sub.frameLen==1
            [data,ok] = getFrames(dat2sub.file, 1, {dat2sub.fCurs, ...
                [dat2sub.pixelX dat2sub.pixelY], dat2sub.frameLen}, h_fig);
            if ~ok
                return
            end
            int = data.frameCur(:,x);
            img(:,x) = img(:,x) - int;
        end
        
    elseif meth == 18 % multiplication
        fact = prmBg{i+1}(1);
        img(:,x) = int*fact;
        
    elseif meth == 19 % addition
        os = prmBg{i+1}(1);
        img(:,x) = int + os;
        
    end
end

