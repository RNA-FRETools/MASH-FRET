function pushbutton_BA_save_Callback(obj, evd, h_fig)
% pushbutton_BA_save_Callback([],[],h_fig)
% pushbutton_BA_save_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and .bga file to save Background analyzer results

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    saveBgOpt(g.figure_bgopt,pname,fname);
else
    saveBgOpt(g.figure_bgopt);
end
