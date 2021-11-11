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

% get image file to map
if ~iscell(obj)
    cd(setCorrectPath('average_images', h_fig));

    str0 = ['*',vidfmt{1}];
    str1 = ['(*',vidfmt{1}];
    for fmt = 2:numel(vidfmt)
        str0 = cat(2,str0,';*',vidfmt{fmt});
        str1 = cat(2,str1,',*',vidfmt{fmt});
    end
    str1 = [str1,')'];
    [fname,pname,o] = uigetfile({str0,...
        ['Supported Graphic File Format',str1]; ...
        '*.*','All File Format(*.*)'},'Select a reference video file');
else
    pname = obj{1}; % ex: C:\Users\MASH\Documents\MATLAB\
    fname = obj{2}; % ex: movie.sif
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
end
if ~sum(fname)
    return
end
cd(pname);

% display progress
setContPan(['Import reference image from file: ',pname,fname,' ...'],...
    'process',h_fig);

% get image data
[data,ok] = getFrames([pname,fname], 1, [], h_fig, false);
if ~ok
    return
end

% control image size
if ~isequal(viddim,[data.pixelX,data.pixelY])
    setContPan(['Image dimensions (',num2str(data.pixelX),',',...
        num2str(data.pixelY),') are inconsistent with video dimensions (',...
        num2str(viddim(1)),',',num2str(viddim(2)),').'],'error',h_fig);
    return
end

if data.frameLen>1
    % display progress
    setContPan(['Calculate average image ',pname,fname],'process',h_fig);

    % calculate average image if necessary
    img = calcAveImg(0,[pname,fname],{data.fCurs,viddim,data.frameLen},1,...
        h_fig);
else
    img = data.frameCur;
end

% store reference image file
p.proj{p.curr_proj}.VP.curr.gen_crd{3}{2}{6} = [pname,fname];

% save modifications
h.param = p;
guidata(h_fig,h);

% open mapping tool
setContPan('Opening mapping tool...','process',h_fig);
lim_x = [0 (1:nChan-1)*round(viddim(1)/nChan) viddim(1)];
openMapping(img, lim_x, h_fig, fname);

% display success
setContPan('Mapping tool is ready!','success',h_fig);
