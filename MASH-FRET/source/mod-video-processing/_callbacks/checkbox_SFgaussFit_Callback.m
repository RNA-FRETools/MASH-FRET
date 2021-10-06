function checkbox_SFgaussFit_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

proj = p.curr_proj;

p.proj{proj}.VP.SF_gaussFit = get(obj, 'Value');

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
