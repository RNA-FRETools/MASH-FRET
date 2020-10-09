function figure_traceMngr_CloseRequestFcn(obj, evd, h_fig)
    
if ishandle(h_fig)
    h = guidata(h_fig);
    h = rmfield(h, 'tm');
    guidata(h_fig, h);
end

% delete pointer manager
iptPointerManager(obj,'disable');

delete(obj);
