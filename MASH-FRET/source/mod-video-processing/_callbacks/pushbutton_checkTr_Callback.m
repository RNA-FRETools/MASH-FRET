function pushbutton_checkTr_Callback(obj, evd, h_fig)
% pushbutton_checkTr_Callback([],[],h_fig)
% pushbutton_checkTr_Callback(imgfiles,[],h_fig)
%
% h_fig: handle to main figure
% imgfiles: {2-by-2} source and destination files with:
%  imgfiles(1,:): source folder and file for reference image
%  imgfiles(2,:): destination folder and file for transformed image

% default
vidfmt = {'.sif','.vsi','.ets','.sira','.tif','.gif','.png','.spe','.pma',...
    '.avi'};
tabttl = 'Transformed image';

% collect parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
lbl = p.proj{p.curr_proj}.labels;
viddim = p.proj{p.curr_proj}.movie_dim;
curr = p.proj{p.curr_proj}.VP.curr;
tr = curr.res_crd{2};
nMov = numel(p.proj{p.curr_proj}.movie_file);
multichanvid = nMov==1;

% control number of channels
if nChan<=1 || nChan>3
    setContPan('This functionality is available for 2 or 3 channels only.',...
        'error',h_fig);
    return
end

% control tranformation
if isempty(tr)
    setContPan(['No Transformation detected. Please calculate or load a ',...
        'transformation'],'error',h_fig);
    return
end

if iscell(obj)
    pname = obj{1,1};
    fname = obj{1,2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    fromRoutine = true;
else
    % ask user for image to transform
    cd(setCorrectPath('average_images', h_fig));

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
        '*.*','All File Format(*.*)'},'Select an image to transform',...
        'multiselect',mltslct);
    fromRoutine = false;
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
setContPan(['Import ',strfle,' ...'],'process',h_fig);

% get image data
img = cell(1,nMov);
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
    
    img{mov} = data.frameCur;
end


% display progress
setContPan('Transform image...','process',h_fig);

% transform image
[imgtrsf,ok] = constrTrafoImage(tr,img,h_fig);
if ~ok
    return
end

% bring transformed image plot tab front
bringPlotTabFront('VPtr',h_fig);

% save modifications
curr.res_plot{3} = imgtrsf;

p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig,h);

% save image if from routine call
if fromRoutine
    set(h_fig,'currentaxes',h.axes_VP_tr);
    exportAxes(obj(2,:),[],h_fig);
end

% refresh plot
updateFields(h_fig,'imgAxes');

% display success
setContPan('Image sucessfully transformed!','success',h_fig);
