function checkbox_bgCorrAll_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'VP')
    return
end

curr = p.proj{p.curr_proj}.VP.curr;

curr.edit{1}{2}(2) = ~get(obj, 'Value');
if curr.edit{1}{2}(2)
    curr.edit{1}{2}(2) = p.VP.curr_frame(proj);
end

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);