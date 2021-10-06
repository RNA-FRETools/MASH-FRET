function popupmenu_TA_slStates_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);

p.proj{proj}.TA.curr{tag,tpe}.lft_start{2}(2) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

% set transition menu to 'all'
set(h.popupmenu_TA_slTrans,'value',1);

ud_kinFit(h_fig);
updateTAplots(h_fig,'kin');