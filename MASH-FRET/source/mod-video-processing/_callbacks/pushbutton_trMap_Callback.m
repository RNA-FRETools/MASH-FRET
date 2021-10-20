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
        '*.*','All File Format(*.*)'},'Select a reference image file');
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
setContPan(['Loading file ',pname,fname],'process',h_fig);

% get image data
[data,ok] = getFrames([pname,fname], 1, [], h_fig, true);
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

% open mapping tool
lim_x = [0 (1:nChan-1)*round(viddim(1)/nChan) viddim(1)];
openMapping(data.frameCur, lim_x, h_fig, fname);
