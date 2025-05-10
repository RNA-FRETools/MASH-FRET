function pushbutton_aveImg_load_Callback(obj, evd, h_fig)
% pushbutton_aveImg_load_Callback([],[],h_fig)
% pushbutton_aveImg_load_Callback(aveimgfile,[],h_fig)
%
% h_fig: handle to main figure
% aveimgfile: {1-by-2} source folder and file for average image

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};

% collect parameters
h = guidata(h_fig);
p = h.param;
lbl = p.proj{p.curr_proj}.labels;
viddim = p.proj{p.curr_proj}.movie_dim;
nMov = numel(p.proj{p.curr_proj}.movie_file);
multichanvid = nMov==1;

% get destination image file
if ~iscell(obj)
    [~,pth] = getCorrectPath('average_images', h_fig);

    str0 = ['*',vidfmt{1}];
    str1 = ['(*',vidfmt{1}];
    for fmt = 2:numel(vidfmt)
        str0 = cat(2,str0,';*',vidfmt{fmt});
        str1 = cat(2,str1,',*',vidfmt{fmt});
    end
    str1 = [str1,')'];
    if multichanvid
        mltslct = 'off';
    else
        mltslct = 'on';
    end
    [fname,pname,o] = uigetfile({str0,...
        ['Supported Graphic File Format',str1]; ...
        '*.*','All File Format(*.*)'},'Select an image file',pth,...
        'multiselect',mltslct);
else
    pname = obj{1}; % ex: C:\Users\MASH\Documents\MATLAB\
    fname = obj{2}; % ex: movie.sif
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
end
if ~iscell(fname) && ~sum(fname)
    return
end
if ~iscell(fname)
    fname = {fname};
end
cd(pname);
if ~multichanvid
    if numel(fname)~=nMov
        setContPan(['The number of image files must be equal to the ',...
            'number of single-channel videos.'],'error',h_fig);
        return
    end
    
    suffx = cell(1,nMov);
    for mov = 1:nMov
        [~,rname,~] = fileparts(fname{mov});
        strprt = split(rname,'_');
        if numel(strprt)==1
            suffx{mov} = '';
        else
            suffx{mov} = strprt{end};
        end
    end
    idfle = [];
    for chan = 1:nMov
        id = find(contains(suffx,lbl{chan}));
        if isempty(id)
            setContPan([lbl{chan},'-channel average image file name must ',...
                'be appended with the suffixe "_',lbl{chan},'".'],'error',...
                h_fig);
            return
        else
            idfle = cat(2,idfle,id);
        end
    end
    fname = fname(idfle);
end

% display progress
if multichanvid
    strfle = ['image from file: ',pname,fname{1}];
else
    strfle = 'images from files: ';
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
setContPan(['Import average ',strfle,' ...'],'process',h_fig);

avimg = cell(1,nMov);
for mov = 1:nMov
    % get image data
    [data,ok] = getFrames([pname,fname{mov}], 1, [], h_fig, true);
    if ~ok
        return
    end

    % control image size
    if ~isequal(viddim{mov},[data.pixelX,data.pixelY])
        setActPan(['Image dimensions (',num2str(data.pixelX),',',...
            num2str(data.pixelY),') are inconsistent with video ',...
            'dimensions (',num2str(viddim{mov}(1)),',',...
            num2str(viddim{mov}(2)),').'],'error',h_fig);
        return
    end
    
    avimg{mov} = data.frameCur;
end

% save modifications
p.proj{p.curr_proj}.VP.curr.res_plot{2} = avimg;
p.proj{p.curr_proj}.VP.prm.res_plot{2} = avimg;
h.param = p;
guidata(h_fig, h);

% bring average image plot tab front
bringPlotTabFront('VPave',h_fig);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig, 'imgAxes');

% display success
setContPan('Average image successfully imported!','success',h_fig);
