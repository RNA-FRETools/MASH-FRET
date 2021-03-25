function [spots,pname,fname,avImg,p] = saveSpots(p,h_fig,varargin)
% [spots,pname,fname,avImg,p] = saveSpots(p,h_fig)
% [spots,pname,fname,avImg,p] = saveSpots(p,h_fig,pname,fname)
%
% Save spots coordinates to *.spots file and image of spots to *.png file.
%
% p: structure to update with SF results
% h_fig: handle to main figure
% spots: exported coordinates
% pname: destination folder
% fname: destination file
% avImg: average image

% Last update by MH, 23.4.2019: correct typos in exported file

% initialize output
spots = [];
pname = [];
fname = [];
avImg = [];

% collect interface parameters
h = guidata(h_fig);

if ~(isfield(p,'SFres') && isfield(h,'movie'))
    return
end

if isfield(h.movie,'avImg')
    avImg = h.movie.avImg;
end

% get destination file name
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
else
    [o, nameMov, o] = fileparts(h.movie.file);
    defName = [setCorrectPath('spotfinder', h_fig) nameMov '.spots'];
    [fname,pname,o] = uiputfile({ ...
        '*.spots', 'Coordinates file(*.spots)'; ...
        '*.*', 'All files(*.*)'}, 'Export coordinates', defName);
end
if ~sum(fname)
    return
end
[o,fname,o] = fileparts(fname);
fname_spots = getCorrName([fname '.spots'], pname, h_fig);
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname_spots);
fname_spots = [pname fname '.spots'];

% collect video parameters
videoFile = [h.movie.path h.movie.file];
L = h.movie.framesTot;
l0 = h.movie.frameCurNb;
fcurs = h.movie.speCursor;
resX = h.movie.pixelX;
resY = h.movie.pixelY;
expT = h.movie.cyctime;

% get video frames on which SF is peformed
all = p.SF_all;
if all
    frames = 1:L;
else
    frames = l0;
end

% open loading bar
if loading_bar('init', h_fig, numel(frames), ...
        'Targetting molecules on all movie frames...');
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);


spots = [];
for l = frames
    % reset previous results if all frames are being processed
    if numel(frames)>1
        p.SFres = {};
        p.SFprm{1}(3) = l;
    end
    
    % get video frame
    [dat,ok] = getFrames(videoFile, l, {fcurs, [resX resY],L}, h_fig, true);
    if ~ok
        return
    end
    
    % filter image
    img = dat.frameCur;
    [img,avImg] = updateBgCorr(img, p, h.movie, h_fig);
    
    % save average image
    if ~isfield(h.movie,'avImg')
        h.movie.avImg = avImg;
        guidata(h_fig, h);
    end
    
    % run spot finder
    p = updateSF(img, true, p, h_fig);
    
    % build tracks
    for c = 1:p.nChan
        nspots = size(p.SFres{2,c},1);
        if nspots>0
            spots = cat(1,spots,[p.SFres{2,c},ones(nspots,1)*l]);
        end
    end
    
    if numel(frames)>1 && l==l0
        currRes = p.SFres;
    end
    
    % update loading bar
    if loading_bar('update', h_fig);
        return
    end
end

% recover results for current frame only
if numel(frames)>1
    p.SFres = currRes;
    p.SFprm{1}(3) = l0;
end

% close loading bar
loading_bar('close', h_fig);

% convert intensities to proper units
if p.perSec
    spots(:,3) = spots(:,3)/expT;
    if size(spots,2)>4
        spots(:,8) = spots(:,8)/expT;
    end
    un = '(a.u./s)';
else
    un = '(a.u.)';
end

% export spots
if size(spots,2)<=4 % no gaussian fit
    str_header = 'x\ty\tI\tframe';
    str_fmt = '%d\t%d\t%d\t%d';
else % gaussian fit
    str_header = ['x\ty\tI',un,'\tasymmetry\twidth\theight\ttheta\t',...
        'z-offset',un,'\tframe'];
    str_fmt = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d';
end
str_header = cat(2,str_header, '\n');
str_fmt = cat(2,str_fmt, '\n');
f = fopen(fname_spots, 'Wt');
fprintf(f, str_header);
fprintf(f, str_fmt, spots');
fclose(f);

% build action
gaussFit = p.SF_gaussFit;
menuStr = get(h.popupmenu_SF, 'String');
str_mthd = cat(2,' ',menuStr{p.SF_method});
if gaussFit
    str_mthd = [str_mthd,' + Gaussian fit'];
end
str_intThresh = '';
str_minI = '';
str_maxN = '';
str_minDs = '';
str_minDe = '';
str_darkDim = '';
str_spotDim = '';
str_wLim = '';
str_ass = '';
for c = 1:p.nChan
    if p.SF_method==4
        str_intThresh = cat(2,str_intThresh,num2str(p.SF_intRatio(c)));
    else
        str_intThresh = cat(2,str_intThresh,num2str(p.SF_intThresh(c)));
        str_darkDim = cat(2,str_darkDim,...
            sprintf('%ix%i',p.SF_darkW(c),p.SF_darkH(c)));
    end
    str_minI = cat(2,str_minI,num2str(p.SF_minI(c)));
    str_maxN = cat(2,str_maxN,num2str(p.SF_maxN(c)));
    str_minDs = cat(2,str_minDs,num2str(p.SF_minDspot(c)));
    str_minDe = cat(2,str_minDe,num2str(p.SF_minDedge(c)));
    if gaussFit
        str_spotDim = cat(2,str_spotDim,...
            sprintf('%ix%i',p.SF_w(1),p.SF_h(1)));
        str_wLim = cat(2,str_wLim,...
            sprintf('[%i, %i]',p.SF_minHWHM(1),p.SF_maxHWHM(1)));
        str_ass = cat(2,str_ass,num2str(p.SF_maxAssy(1)));
    end
    if c<p.nChan
        str_intThresh = cat(2,str_intThresh,', ');
        if p.SF_method~=4
            str_darkDim = cat(2,str_darkDim,', ');
        end
        str_minI = cat(2,str_minI,', ');
        str_maxN = cat(2,str_maxN,', ');
        str_minDs = cat(2,str_minDs,', ');
        str_minDe = cat(2,str_minDe,', ');
        if gaussFit
            str_spotDim = cat(2,str_spotDim,', ');
            str_wLim = cat(2,str_wLim,', ');
            str_ass = cat(2,str_ass,', ');
        end
    end
end

if p.SF_method==4
    str_intThresh = cat(2,'detection intensity threshold = ',...
        str_intThresh);
else
    str_intThresh = cat(2,'min. detection intensity(cnt/s) = ',...
        str_intThresh);
    str_darkDim = cat(2,'dark area dimensions(pixels) = ',str_darkDim,...
        '\n');
end
str_gaussPrm = [];
if gaussFit
    str_gaussPrm = cat(2,'spot dimensions(pixels) = ',str_spotDim,'\n', ...
        '\n2D Gaussian width limits(pixels) = ',str_wLim, ...
        '\nmax. 2D Gaussian assymetry(%) = ',str_ass);
end

% show action
updateActPan(cat(2,'Spotfinder parameters:\n', ...
    'method: ', str_mthd, '\n', ...
    str_intThresh, '\n', ...
    str_darkDim, ...
    'min. intensity(cnt/s) = ', str_minI, '\n', ...
    'max. spot number =', str_maxN, '\n', ...
    'min. inter-spot distance(pixels) = ', str_minDs, '\n', ...
    'min. spot-image edges distance(pixels) = ', str_minDe, ...
    str_gaussPrm), h_fig);

