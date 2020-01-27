function popupmenu_TDPtag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end
    
proj = p.curr_proj;
val = get(obj,'Value');

if val==p.curr_tag(proj)
    return
end

if val>1
    str_tag = get(obj,'String');
    setContPan(cat(2,'Select molecule subgroup "',...
        removeHtml(str_tag{val}),'".'),'success',h_fig);
else
    setContPan('Select all molecule.','success',h_fig);
end

p.curr_tag(proj) = val;
h.param.TDP = p;
guidata(h_fig, h);

% update TDP and plot
pushbutton_TDPupdatePlot_Callback(obj, evd, h_fig);
