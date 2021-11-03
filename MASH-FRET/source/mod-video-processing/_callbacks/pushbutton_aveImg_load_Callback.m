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
viddim = p.proj{p.curr_proj}.movie_dim;

% get destination image file
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
        '*.*','All File Format(*.*)'},'Select an image file');
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
setContPan(['Import average image from file: ',pname,fname,' ...'],...
    'process',h_fig);

% get image data
[data,ok] = getFrames([pname,fname], 1, [], h_fig, true);
if ~ok
    return
end

% control image size
if ~isequal(viddim,[data.pixelX,data.pixelY])
    setActPan(['Image dimensions (',num2str(data.pixelX),',',...
        num2str(data.pixelY),') are inconsistent with video dimensions (',...
        num2str(viddim(1)),',',num2str(viddim(2)),').'],'error',h_fig);
    return
end

% save modifications
p.proj{p.curr_proj}.VP.curr.res_plot{2} = data.frameCur;
p.proj{p.curr_proj}.VP.prm.res_plot{2} = data.frameCur;
h.param = p;
guidata(h_fig, h);

% bring tab forefront
h.uitabgroup_VP_plot.SelectedTab = h.uitab_VP_plot_avimg;

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig, 'imgAxes');

% display success
setContPan('Average image successfully imported!','success',h_fig);
