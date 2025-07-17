function fig_pbStats_CloseRequestFcn(fig,evd,fig0)

% remove handle to Photobleaching/blinking figure from main structure
h = guidata(fig0);
if isfield(h,'figure_pbStats')
    h = rmfield(h,'figure_pbStats');
end
guidata(fig0,h);

% delete Photobleaching/blinking figure
if ishandle(fig)
    delete(fig)
end