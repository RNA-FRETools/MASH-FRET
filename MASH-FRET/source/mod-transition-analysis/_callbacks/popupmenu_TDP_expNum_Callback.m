function popupmenu_TDP_expNum_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

v = curr.lft_start{2}(2);

p.proj{proj}.TA.curr{tag,tpe}.lft_start{1}{v,1}(4) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

ud_fitSettings(h_fig);
