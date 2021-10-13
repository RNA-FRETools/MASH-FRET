function ud_expSet_chanPlot(h_fig)

% get interface content
h = guidata(h_fig);

% get project data
proj = h_fig.UserData;
if ~proj.is_movie
    set(h.axes_chan,'visible','off');
    return
end

% plot average image
set(h.axes_chan,'visible','on');
imagesc(h.axes_chan,'xdata',[0,proj.movie_dim(1)],'ydata',...
    [0,proj.movie_dim(2)],'cdata',proj.aveImg{1});

h.axes_chan.NextPlot = 'add';

% plot channel borders
for c = 1:(proj.nb_channel-1)
    splitpos = c*round(proj.movie_dim(1)/proj.nb_channel);
    plot(h.axes_chan,[splitpos,splitpos],[0,proj.movie_dim(2)],'--w',...
        'linewidth',2);
end

h.axes_chan.NextPlot = 'replacechildren';

h.axes_chan.XLim = [0,proj.movie_dim(1)];
h.axes_chan.YLim = [0,proj.movie_dim(2)];
