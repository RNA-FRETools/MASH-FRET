function pushbutton_showDark_Callback(obj, evd, h_fig)
% pushbutton_showDark_Callback(obj, evd, h_fig)
% pushbutton_showDark_Callback(obj, evd, h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-1} destination image file to export dark trace to

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    if iscell(obj)
        file_out = obj{1};
        dispDarkTr(h_fig,file_out);
    else
        dispDarkTr(h_fig);
    end
end