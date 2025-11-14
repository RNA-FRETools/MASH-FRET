function pushbutton_trMap_Callback(obj, evd, h_fig)
% pushbutton_trMap_Callback([],[],h_fig)
% pushbutton_trMap_Callback(refImgFile,[],h_fig)
%
% h_fig: handle to main figure
% refImageFile: {1-by-2} source folder and file containing reference image

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};

% retrieve parameters
h = guidata(h_fig);
p = h.param;
viddim = p.proj{p.curr_proj}.movie_dim;
nChan = p.proj{p.curr_proj}.nb_channel;
nMov = numel(p.proj{p.curr_proj}.movie_file);
multichanvid = nMov==1;
lbl = p.proj{p.curr_proj}.labels;

% get image file to map
if ~iscell(obj)

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
    [~,pth] = getCorrectPath('average_images',h_fig);
    [fname,pname,o] = uigetfile({...
        str0,['Supported Graphic File Format',str1]; ...
        '*.*','All File Format(*.*)'},'Select a reference video file',pth,...
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
        if isscalar(strprt)
            suffx{mov} = '';
        else
            suffx{mov} = strprt{end};
        end
    end
    idfle = [];
    for chan = 1:nMov
        id = find(contains(suffx,lbl{chan}));
        if isempty(id)
            setContPan([lbl{chan},'-channel reference image file name ',...
                'must be appended with the suffixe "_',lbl{chan},'".'],...
                'error',h_fig);
            return
        else
            idfle = cat(2,idfle,id);
        end
    end
    fname = fname(idfle);
end
if ~iscell(fname)
    fname = {fname};
end
cd(pname);

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
setContPan(['Import reference ',strfle,' ...'],'process',h_fig);

img = cell(1,nMov);
fles = cell(1,nMov);
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

    if data.frameLen>1
        % display progress
        setContPan(['Calculate average image ',pname,fname{mov}],'process',...
            h_fig);

        % calculate average image if necessary
        img{mov} = calcAveImg(0,[pname,fname{mov}],...
            {data.fCurs,viddim{mov},data.frameLen},1,h_fig);
    else
        img{mov} = data.frameCur;
    end
    
    fles{mov} = [pname,fname{mov}];
end

% store reference image files
p.proj{p.curr_proj}.VP.curr.gen_crd{3}{2}{6} = fles;

% save modifications
h.param = p;
guidata(h_fig,h);

% open mapping tool
if multichanvid
    lim_x = [0 (1:nChan-1)*round(viddim{1}(1)/nChan) viddim{1}(1)];
else
    lim_x = [];
end
setContPan('Opening mapping tool...','process',h_fig);
openMapping(img, lim_x, h_fig, fname);

% display success
setContPan('Mapping tool is ready!','success',h_fig);
