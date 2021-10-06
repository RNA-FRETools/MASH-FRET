function checkbox_bgCorrAll_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

proj = p.curr_proj;

p.proj{proj}.VP.movBg_one = ~get(obj, 'Value');
if p.proj{proj}.VP.movBg_one
    p.proj{proj}.VP.movBg_one = p.VP.curr_frame(proj);
end

% save modifications
h.param = p;
guidata(h_fig, h);