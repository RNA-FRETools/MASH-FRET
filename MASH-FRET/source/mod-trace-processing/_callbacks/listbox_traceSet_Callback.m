function listbox_traceSet_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end
val = get(obj, 'Value');
proj_name = get(obj,'string');
if ~(numel(val)==1 && val~=p.curr_proj)
    return
end

p.curr_proj = val;
h.param.ttPr = p;
guidata(h_fig, h);

str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
    p.proj{val}.proj_file,')');
setContPan(str_proj,'none',h_fig);

ud_TTprojPrm(h_fig);
ud_trSetTbl(h_fig);

updateFields(h_fig, 'ttPr');
    