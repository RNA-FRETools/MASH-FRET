function pushbutton_TTgen_create_Callback(obj,evd,h_fig)

% retrieve parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.proj}.VP.curr;
coordsm = curr.res_crd{4};

% control single molecule coordinates
if isempty(coordsm)
    setContPan(['No single molecule coordinates detected. Please ',...
        'transform spots coordinates or import single molecule ',...
        'coordinates.'],'error',h_fig);
    return
end

% apply current parameters to project
prm = curr;

% generate traces and save to project
if ~TTgenGo(h_fig)
    return
end

% save modifications
p.proj{p.proj}.VP.prm = prm;
h.param = p;
guidata(h_fig,h);

% display success
setContPan(['Single molecule intensity-time traces successfully ',...
    'calculated!'],'success',h_fig);
