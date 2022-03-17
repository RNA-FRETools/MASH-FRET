function pushbutton_aveImg_save_Callback(obj, evd, h_fig)
% pushbutton_aveImg_save_Callback([],[],h_fig)
% pushbutton_aveImg_save_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file for average image

% default
defbfname = 'frame_t_0';

% collect parameters
h = guidata(h_fig);
p = h.param;
projfile = p.proj{p.curr_proj}.proj_file;
projtle = p.proj{p.curr_proj}.exp_parameters{1,2};
vidfile = p.proj{p.curr_proj}.movie_file;
viddim = p.proj{p.curr_proj}.movie_dim;
expT = p.proj{p.curr_proj}.frame_rate;
lbl = p.proj{p.curr_proj}.labels;
curr = p.proj{p.curr_proj}.VP.curr;
img_ave = curr.res_plot{2};
nMov = numel(vidfile);
multichanvid = nMov==1;

% get destination image file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    if ~isempty(projfile)
        [o,name,o] = fileparts(projfile);
    else
        [o,name,o] = fileparts(vidfile{1});
    end
    if strcmp(name,defbfname)
        name = projtle;
    end
    defName = [setCorrectPath('average_images', h_fig) name];
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
    fext = '.png';
end

if multichanvid
    fname = {getCorrName([name,fext], pname, h_fig)};
else
    fname = cell(1,nMov);
    for mov = 1:nMov
        fname{mov} = getCorrName([name,'_',lbl{mov},fext], pname, h_fig);
    end
end

% display process
setContPan('Write average image to file...','process',h_fig);

% save image to file
for mov = 1:nMov
    if strcmp(fext, '.png')
        imwrite(uint16(65535*(img_ave{mov}-min(min(img_ave{mov})))/ ...
            (max(max(img_ave{mov}))-min(min(img_ave{mov})))),...
            [pname fname{mov}],'png','BitDepth',16,'Description', ...
            [num2str(expT) ' ' num2str(max(max(img_ave{mov})))...
            ' ' num2str(min(min(img_ave{mov})))]);

    elseif strcmp(fext, '.tif')
        min_img = min(min(round(img_ave{mov})));
        if min_img >= 0
            min_img = 0;
        end
        img_16 = uint16(round(img_ave{mov})+abs(min_img));
        imwrite(img_16, [pname fname{mov}], 'tif', 'WriteMode', ...
            'overwrite', 'Description', ...
            sprintf('%d\t%d', expT, min_img));

    elseif strcmp(fext, '.sira')
        figname = get(h_fig, 'Name');
        vers = figname(length('MASH-FRET '):end);
        f = writeSiraFile('init',[pname,fname{mov}],vers,...
            [1/expT,viddim{mov},1]);
        if f==-1
            setContPan(['Enable to open file ',fname{mov}],'error',h_fig);
            return
        end
        writeSiraFile('append',f,img_ave{mov},prod(viddim{mov}));
        fclose(f);
    end
end

% display success
if multichanvid
    strfle = ['file: ',pname,fname{1}];
else
    strfle = 'files: ';
    for mov = 1:nMov
        if mov==nMov
            strfle = cat(2,strfle,' and ',pname,fname{mov});
        elseif mov>1
            strfle = cat(2,strfle,', ',pname,fname{mov});
        elseif mov==1
            strfle = cat(2,strfle,pname,fname{mov});
        end
    end
end
setContPan(['Average image successfully written to ',strfle],'success',...
    h_fig);
