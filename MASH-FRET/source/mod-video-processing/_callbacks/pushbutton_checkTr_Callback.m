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
curr = p.proj{p.curr_proj}.VP.curr;
tr = curr.res_crd{2};

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
    [fname,pname,o] = uigetfile({str0,...
        ['Supported Graphic File Format',str1]; ...
        '*.*','All File Format(*.*)'},'Select an image to transform');
    fromRoutine = false;
end
if ~sum(fname)
    return
end
cd(pname);

% display progress
setContPan(['Import image from file: ',pname,fname],'process',h_fig);

% get image data
[data,ok] = getFrames([pname,fname], 1, [], h_fig, true);
if ~ok
    return
end
img = data.frameCur;


% display progress
setContPan('Transform image...','process',h_fig);

% transform image
[imgtrsf,ok] = constrTrafoImage(tr,img,h_fig);
if ~ok || isempty(imgtrsf)
    return
end

% show transformed image
if ~(isfield(h,'axes_VP_tr') && ishandle(h.axes_VP_tr))
    h.uitab_VP_plot_tr = uitab('parent',h.uitabgroup_VP_plot,'units',...
        h.dimprm.posun,'title',tabttl);
    h = buildVPtabPlotTr(h,h.dimprm);
    setProp([h.uitab_VP_plot_tr,h.uitab_VP_plot_tr.Children],'Units',...
        h.uitabgroup_VP_plot.Units);
    guidata(h_fig,h);
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
