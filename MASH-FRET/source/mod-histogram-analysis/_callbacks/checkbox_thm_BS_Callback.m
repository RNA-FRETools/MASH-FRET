function checkbox_thm_BS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
def = p.proj{proj}.HA.def{tag,tpe};

% abort if histogram is imported from files
fromfile = isfield(p.proj{proj},'histdat') && ...
    ~isempty(p.proj{proj}.histdat);
if fromfile
    setContPan('BOBA-FRET is not adapted to uniquely imported histograms.',...
        'error',h_fig);
    ud_HA_statePop(h_fig)
    return
end


p.proj{proj}.HA.curr{tag,tpe}.thm_start{1}(2) = get(obj, 'Value');
p.proj{proj}.HA.curr{tag,tpe}.thm_res(1:2,1:3) = def.thm_res(1:2,1:3);
if isfield(p.proj{proj}.HA.prm{tag,tpe},'thm_res')
    p.proj{proj}.HA.prm{tag,tpe}.thm_res(1:2,1:3) = def.thm_res(1:2,1:3);
end
    
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');