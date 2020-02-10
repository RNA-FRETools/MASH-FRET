function pushbutton_aveImg_go_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if ~isfield(h,'movie')
    updateActPan('No graphic file loaded!', h_fig, 'error');
    return
end

% collect video parameters
vidfold = h.movie.path;
vidfile = h.movie.file;
fcurs = h.movie.speCursor;
resX = h.movie.pixelX;
resY = h.movie.pixelY;
L = h.movie.framesTot;
expT = h.movie.cyctime;

% get destination image file
[o,nameMov,o] = fileparts(vidfile);
defName = [setCorrectPath('average_images', h_fig) nameMov '_ave'];
[fname,pname,o] = uiputfile({ ...
    '*.png', 'Portable Network Graphics(*.png)'; ...
    '*.sira', 'SIRA Graphic File Format(*.sira)'; ...
    '*.tif', 'Tagged Image File Format(*.tif)'; ...
    '*.*', 'All files(*.*)'}, ...
    'Export average image', defName);
if ~sum(fname)
    return
end
cd(pname);
[o,name,fext] = fileparts(fname);
if ~sum(double(strcmp(fext, {'.png' '.tif' '.sira'})))
    fname = [name '.png'];
end
fname = getCorrName(fname, pname, h_fig);

% build average image
param.start = p.ave_start;
param.stop = p.ave_stop;
param.iv = p.ave_iv;
param.file = [vidfold,vidfile];
param.extra{1} = fcurs;
param.extra{2} = [resX resY]; 
param.extra{3} = L;
[img_ave,ok] = createAveIm(param,true,true,h_fig);
if ~ok
    return;
end

% save image to file
if strcmp(fext, '.png')
    imwrite(uint16(65535*(img_ave-min(min(img_ave)))/ ...
        (max(max(img_ave))-min(min(img_ave)))), [pname fname], ...
        'png', 'BitDepth', 16, 'Description', ...
        [num2str(h.movie.cyctime) ' ' num2str(max(max(img_ave)))...
        ' ' num2str(min(min(img_ave)))]);

elseif strcmp(fext, '.tif')
    min_img = min(min(round(img_ave)));
    if min_img >= 0
        min_img = 0;
    end
    img_16 = uint16(round(img_ave)+abs(min_img));
    imwrite(img_16, [pname fname], 'tif', 'WriteMode', ...
        'overwrite', 'Description', ...
        sprintf('%d\t%d', h.movie.cyctime, min_img));

elseif strcmp(fext, '.sira')
    figname = get(h_fig, 'Name');
    vers = figname(length('MASH-FRET '):end);
    f = writeSiraFile('init', [pname,fname], vers, [1/expT,[resX,resY],L]);
    if f==-1
        setContPan(['Enable to open file ',fname],'error',h_fig);
        return
    end
    writeSiraFile('append', f, img_ave, resX*resY);
    fclose(f);
end

updateActPan(['The average image (' num2str(param.start) ':' ...
    num2str(param.iv) ':' num2str(param.stop) ') has been saved to file: ' ...
    fname '\nin folder: ' pname], h_fig, 'success');

