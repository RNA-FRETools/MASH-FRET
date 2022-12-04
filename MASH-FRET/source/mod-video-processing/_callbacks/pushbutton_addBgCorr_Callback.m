function pushbutton_addBgCorr_Callback(obj, evd, h_fig)
% pushbutton_addBgCorr_Callback([], [], h_fig)
% pushbutton_addBgCorr_Callback(bgfile, [], h_fig)
%
% h_fig: handle to main figure
% bgfile: source image file used in image subtration

% collect parameters
h = guidata(h_fig);
p = h.param;
l = p.movPr.curr_frame(p.curr_proj);
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
meth = curr.edit{1}{1}(1);
tocurr = curr.edit{1}{1}(2);
filtprm = curr.edit{1}{2};
filtlist = curr.edit{1}{4};

% control filter index
if meth<=1
    return
end

% add filter to project
if meth==17 % image subtraction
    if iscell(obj)
        dat = getFile2sub('Pick an image to subtract', h_fig, obj{1});
    else
        dat = getFile2sub('Pick an image to subtract', h_fig);
    end
    if isempty(dat)
        return
    end
    filt = cell(1,nChan+1);
    filt{1} = meth;
    filt{2} = dat;
    curr.edit{1}{4} = cat(1,filtlist,filt);

else
    if sum(meth==[2 5:10]) && exist('FilterArray','file')~=3
        setContPan(cat(2,'This filter can not be used: problem with mex ',...
            'compilation.'),'error',h_fig);
        return
    end
    curr.edit{1}{4} = cat(1,filtlist,cell(1,nChan+1));
    curr.edit{1}{4}{end,1} = meth;
    for c = 1:nChan
        curr.edit{1}{4}{end,c+1} = filtprm{meth,c};
    end
end

% save current frame index
if tocurr
    curr.edit{1}{1}(2) = l;
end

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% display progress
filtstr = h.popupmenu_bgCorr.String;
filtname = filtstr{meth};
setContPan(['Adding background filter "',filtname,'"...'],'process',h_fig);

% bring video plot tab front
bringPlotTabFront('VPvid',h_fig);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');

% display success
setContPan(['Background filter "',filtname,'" successfully added!'],...
    'success',h_fig);
