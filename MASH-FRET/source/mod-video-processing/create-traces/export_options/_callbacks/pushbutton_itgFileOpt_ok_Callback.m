function pushbutton_itgFileOpt_ok_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.gen_int{4} = [ ...
    get(h.itgFileOpt.checkbox_ASCII, 'Value') ...
    get(h.itgFileOpt.checkbox_allMol, 'Value') ...
    get(h.itgFileOpt.checkbox_oneMol, 'Value') ...
    get(h.itgFileOpt.checkbox_HaMMy, 'Value') ...
    get(h.itgFileOpt.checkbox_vbFRET, 'Value') ...
    get(h.itgFileOpt.checkbox_QUB, 'Value') ...
    get(h.itgFileOpt.checkbox_SMART, 'Value') ...
    get(h.itgFileOpt.checkbox_ebFRET, 'Value')];

h.param = p;
guidata(h_fig, h);

close(h.figure_itgFileOpt);

% display process
setContPan('Export time traces to files...','process',h_fig);

if ~iscell(obj)
    expTraces(h_fig);
else
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname,filesep)
        pname = [pname,filesep];
    end
    expTraces(h_fig,pname,fname);
end

setContPan('Time traces were successfully exported!','success',h_fig);

