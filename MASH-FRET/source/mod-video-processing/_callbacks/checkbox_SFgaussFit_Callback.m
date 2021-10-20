function checkbox_SFgaussFit_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

p.proj{p.curr_proj}.VP.curr.gen_crd{2}{1}(2) = get(obj, 'Value');

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
