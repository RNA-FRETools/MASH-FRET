function pushbutton_expTraces_Callback(obj, evd, h_fig)
% pushbutton_expTraces_Callback([],[],h_fig)
% pushbutton_expTraces_Callback(makeVisible,[],h_fig)
%
% h_fig: handle to main figure
% makeVisible = {1-by-1} (1) make option figure visible, (0) otherwise

% show process
setContPan('Opening export options...','process',h_fig);

openExpTtpr(h_fig);

if ~(iscell(obj) && ~obj{1})
    h = guidata(h_fig);
    q = h.optExpTr;
    set(q.figure_optExpTr,'visible','on');
end

% show success
setContPan('Export options ready!','success',h_fig);