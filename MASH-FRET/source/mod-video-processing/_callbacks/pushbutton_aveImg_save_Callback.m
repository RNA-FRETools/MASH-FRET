function pushbutton_aveImg_save_Callback(obj, evd, h_fig)
% pushbutton_aveImg_save_Callback([],[],h_fig)
% pushbutton_aveImg_save_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file for average image

% collect parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;
expT = p.proj{p.curr_proj}.frame_rate;
curr = p.proj{p.curr_proj}.curr;
img_ave = curr.res_plot{2};
L = viddat{3};

% get destination image file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [o,nameMov,o] = fileparts(vidfile);
    defName = [setCorrectPath('average_images', h_fig) nameMov '_ave'];
    [fname,pname,o] = uiputfile({ ...
        '*.png', 'Portable Network Graphics(*.png)'; ...
        '*.sira', 'SIRA Graphic File Format(*.sira)'; ...
        '*.tif', 'Tagged Image File Format(*.tif)'; ...
        '*.*', 'All files(*.*)'}, ...
        'Export average image', defName);
end
if ~sum(fname)
    return
end
cd(pname);
[o,name,fext] = fileparts(fname);
if ~sum(double(strcmp(fext, {'.png' '.tif' '.sira'})))
    fname = [name '.png'];
end
fname = getCorrName(fname, pname, h_fig);

% display process
setContPan('Write average image to file...','process',h_fig);

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

% display success
setContPan(['Average image successfully written to file: ',pname,fname],...
    'success',h_fig);
