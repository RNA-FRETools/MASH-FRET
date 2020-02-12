function pushbutton_addBgCorr_Callback(obj, evd, h_fig)
% pushbutton_addBgCorr_Callback([], [], h_fig)
% pushbutton_addBgCorr_Callback(bgfile, [], h_fig)
%
% h_fig: handle to main figure
% bgfile: source image file used in image subtration

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if ~isfield(h,'movie')
    updateActPan('No graphic file loaded!', h_fig, 'error');
    return
end

% collect video parameters
l = h.movie.frameCurNb;

% collect processing parameters
meth = p.movBg_method;
if meth<=1
    return
end

if meth==17 % image subtraction
    if iscell(obj)
        dat = getFile2sub('Pick an image to subtract', h_fig, obj{1});
    else
        dat = getFile2sub('Pick an image to subtract', h_fig);
    end
    if isempty(dat)
        return
    end
    p.bgCorr{size(h.param.movPr.bgCorr,1)+1,1} = meth;
    p.movBg_p{meth,1} = dat;

else
    if sum(meth==[2 5:10]) && exist('FilterArray','file')~=3
        setContPan(cat(2,'This filter can not be used: problem with mex ',...
            'compilation.'),'error',h_fig);
        return
    end
    p.bgCorr{size(p.bgCorr,1)+1,1} = meth;
    for c = 1:p.nChan
        p.bgCorr{end,c+1} = p.movBg_p{meth,c};
    end
end

if p.movBg_one
    p.movBg_one = l;
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
