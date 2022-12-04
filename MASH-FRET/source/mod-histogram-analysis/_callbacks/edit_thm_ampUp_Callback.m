function edit_thm_ampUp_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};

gauss = get(h.popupmenu_thm_gaussNb, 'Value');
val = str2num(get(obj, 'String'));
minVal = curr.thm_start{3}(gauss,2);
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>minVal)
    setContPan(sprintf(['The upper limit of Gaussian amplitude must be ',...
        'higher than the starting value (%d)'],minVal), 'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

curr.thm_start{3}(gauss,3) = val;
        
p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
