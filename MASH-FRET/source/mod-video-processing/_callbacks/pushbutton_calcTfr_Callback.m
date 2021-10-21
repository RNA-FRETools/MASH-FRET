function pushbutton_calcTfr_Callback(obj, evd, h_fig)
% pushbutton_calcTfr_Callback([],[],h_fig)
% pushbutton_calcTfr_Callback(outfile,[],h_fig)
%
% h_fig: handle to main figure
% outfile: {1-by-2} destination folder and file

% default
trtype = 4; % projective

% collect parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
coordref = curr.res_crd{3};

% control number of channels
if nChan<=1 || nChan>3
    setContPan('This functionality is available for 2 or 3 channels only.',...
        'error',h_fig);
    return
end

% control reference coordinates
if isempty(coordref)
    setContPan(['No reference coordinates detected. Please map or import ',...
        'reference coordinates'],'error',h_fig);
    return
end

% calculate transformation
tr = createTrafo(trtype,coordref,h_fig);
if isempty(tr)
    return
end

% save transformation
curr.res_crd{2} = tr;

% reset transformation file
curr.gen_crd{3}{3}{3} = '';

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig,h);

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

% show action
setContPan('Transformation was successfully calculated','success',h_fig);
