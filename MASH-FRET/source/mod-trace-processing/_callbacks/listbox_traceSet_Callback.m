function listbox_traceSet_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj_name = get(obj,'string');
    if numel(val)==1 && val ~= p.curr_proj
        p.curr_proj = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
            
        str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
            p.proj{val}.proj_file,')');
        setContPan(str_proj,'none',h.figure_MASH);

        ud_TTprojPrm(h.figure_MASH);
        ud_trSetTbl(h.figure_MASH);

        updateFields(h.figure_MASH, 'ttPr');
    end       
end