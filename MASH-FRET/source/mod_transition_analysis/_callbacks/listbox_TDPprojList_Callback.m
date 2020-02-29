function listbox_TDPprojList_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = get(obj, 'Value');
if ~(numel(val)==1 && val~=p.curr_proj)
    return
end

p.curr_proj = val;
h.param.TDP = p;
guidata(h_fig, h);

proj_name = get(obj,'string');
str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
    p.proj{val}.proj_file,')');

setContPan(str_proj,'none',h_fig);

% update TDP and plot
pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig);

