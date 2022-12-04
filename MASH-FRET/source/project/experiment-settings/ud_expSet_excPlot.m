function ud_expSet_excPlot(h_fig)

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_exc') && ishandle(h.tab_exc))
    return
end

% get project data
proj = h_fig.UserData;

if ~proj.is_movie
    set(h.axes_exc,'visible','off');
    return
end

% plot average images
set(h.axes_exc,'visible','on');
for l = 1:proj.nb_excitations
    if ~(isfield(h,'axes_exc') && numel(h.axes_exc)>=l && ...
            ishandle(h.axes_exc(l)))
        continue
    end
    img = [];
    for c = 1:numel(proj.movie_file)
        img_c = proj.aveImg{c,1+l};
        [h0,w0] = size(img);
        [hc,wc] = size(img_c);
        if h0<hc
            img = cat(1,img,zeros(hc-h0,w0));
        elseif h0>hc
            img_c = cat(1,img_c,zeros(h0-hc,wc));
        end
        img = cat(2,img,img_c);
    end
    imagesc(h.axes_exc(l),'xdata',[0,size(img,2)],'ydata',...
        [0,size(img,1)],'cdata',img);
    
    [h0,w0] = size(img);
    
    h.axes_exc(l).NextPlot = 'add';
    for c = 1:(proj.nb_channel-1)
        splitpos = c*round(w0/proj.nb_channel);
        plot(h.axes_exc(l),[splitpos,splitpos],[0,h0],'--w');
    end
    h.axes_exc(l).NextPlot = 'replacechildren';
    
    h.axes_exc(l).XLim = [0,w0];
    h.axes_exc(l).YLim = [0,h0];
end
