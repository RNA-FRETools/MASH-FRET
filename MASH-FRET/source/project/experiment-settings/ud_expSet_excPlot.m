function ud_expSet_excPlot(h_fig)

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_exc') && ishandle(h.tab_exc))
    return
end

% get project data
proj = h_fig.UserData;

if ~proj.is_movie
    return
end

% plot average images
for l = 1:proj.nb_excitations
    if ~(isfield(h,'axes_exc') && numel(h.axes_exc)>=l && ...
            ishandle(h.axes_exc(l)))
        continue
    end

    imagesc(h.axes_exc(l),'xdata',[0,proj.movie_dim(1)],'ydata',...
        [0,proj.movie_dim(2)],'cdata',proj.aveImg{1+l});
    
    h.axes_exc(l).XLim = [0,proj.movie_dim(1)];
    h.axes_exc(l).YLim = [0,proj.movie_dim(2)];
end
