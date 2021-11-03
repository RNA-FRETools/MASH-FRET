function pushbutton_TTgen_create_Callback(obj,evd,h_fig)

% retrieve parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
coordsm = curr.res_crd{4};

% control single molecule coordinates
if isempty(coordsm)
    setContPan(['No single molecule coordinates detected. Please ',...
        ' import single molecule coordinates in panel "Intensity ',...
        'integration" or calculate them in panel "Molecule coordinates".'],...
        'error',h_fig);
    return
end

% apply current parameters to project
prm = curr;

% display process
setContPan('Calculate single molecule intensity-time traces...','process',...
    h_fig);

% generate traces and save to project
if ~TTgenGo(h_fig)
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.prm = prm;

h.param = p;
guidata(h_fig,h);

% switch to TP
switchPan(h.togglebutton_TP,[],h_fig);

% display success
setContPan(['Single molecule intensity-time traces successfully ',...
    'calculated!'],'success',h_fig);
