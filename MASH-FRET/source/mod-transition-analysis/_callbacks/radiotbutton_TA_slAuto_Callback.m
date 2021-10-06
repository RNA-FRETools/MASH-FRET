function radiotbutton_TA_slAuto_Callback(obj,evd,h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

v = curr.lft_start{2}(2);

p.proj{proj}.TA.curr{tag,tpe}.lft_start{1}{v,1}(1) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h)

ud_fitSettings(h_fig);