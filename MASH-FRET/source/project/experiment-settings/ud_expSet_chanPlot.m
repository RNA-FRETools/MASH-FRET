function ud_expSet_chanPlot(h_fig)

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_chan') && ishandle(h.tab_chan))
    return
end

% get project data
proj = h_fig.UserData;
if ~proj.is_movie
    set(h.axes_chan,'visible','off');
    return
end

% plot average image
set(h.axes_chan,'visible','on');
chanlim = ...
    [0,fix(proj.movie_dim{1}(1)*(1:proj.nb_channel)/proj.nb_channel)];
for c = 1:proj.nb_channel
    if h.radio_impFileMulti.Value==1
        splitpos1 = chanlim(c);
        splitpos2 = chanlim(c+1);
        img = proj.aveImg{1}(:,(splitpos1+1):splitpos2);
        imagesc(h.axes_chan(c),'xdata',[splitpos1,splitpos2],'ydata',...
            [0,proj.movie_dim{1}(2)],'cdata',img);

        h.axes_chan(c).XLim = [splitpos1,splitpos2];
        h.axes_chan(c).YLim = [0,proj.movie_dim{1}(2)];
    else
        if isempty(proj.movie_dim{c})
            continue
        end
        splitpos1 = 1;
        splitpos2 = proj.movie_dim{c}(1);
        img = proj.aveImg{c,1}(:,splitpos1:splitpos2);
        imagesc(h.axes_chan(c),'xdata',[splitpos1,splitpos2],'ydata',...
            [0,proj.movie_dim{c}(2)],'cdata',img);

        h.axes_chan(c).XLim = [splitpos1,splitpos2];
        h.axes_chan(c).YLim = [0,proj.movie_dim{c}(2)];
    end
end
