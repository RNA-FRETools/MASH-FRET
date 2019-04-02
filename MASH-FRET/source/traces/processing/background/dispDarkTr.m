function dispDarkTr(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;

% get channel and laser corresponding to selected data
selected_chan = p.proj{proj}.fix{3}(6);
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break;
        end
    end
    if chan==selected_chan
        break;
    end
end
    
method = p.proj{proj}.curr{mol}{3}{2}(l,c);
if method == 6
    coord_dark = p.proj{proj}.curr{mol}{3}{3}{l,c}(method,4:5);
    res_y = p.proj{proj}.movie_dim(2);
    res_x = p.proj{proj}.movie_dim(1);
    aDim = p.proj{proj}.pix_intgr(1);
    min_xy = aDim/2;
    max_y = res_y - aDim/2;
    max_x = res_x - aDim/2;
    coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
    coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
    coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
    p.proj{proj}.curr{mol}{3}{3}{l,c}(method,4:5) = coord_dark;
    h.param.ttPr = p;
    guidata(h_fig, h);
    nExc = p.proj{proj}.nb_excitations;
    nPix = p.proj{proj}.pix_intgr(2);
    fDat = [p.proj{proj}.movie_file p.proj{proj}.movie_dat(1) [res_y ...
        res_x] p.proj{proj}.movie_dat(3:end)];
    fact = p.proj{proj}.curr{mol}{3}{3}{l,c}(method,1);
    nFrames = size(p.proj{proj}.intensities,1)* ...
        p.proj{proj}.nb_excitations;
    [o I_bg] = create_trace(coord_dark, aDim, nPix, fDat);
    I_bg = slideAve(I_bg(l:nExc:nFrames,:), fact);

    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
    rate = p.proj{proj}.frame_rate;
    y_lab = 'counts';

    if perSec
        I_bg = I_bg/rate;
        y_lab = [y_lab 'per s.'];
    end

    if perPix
        I_bg = I_bg/nPix;
        y_lab = [y_lab ' per pix.'];
    end

    inSec = p.proj{proj}.fix{2}(7);
    x_axis = l:nExc:nFrames;
    if inSec
        x_axis = x_axis*rate;
        x_lab = 'time (s)';
    else
        x_lab = 'frames';
    end


    h_fig = figure('Name', ['Dark trace: (' num2str(coord_dark(1)) ...
        ',' num2str(coord_dark(2)) ')'], 'Visible', 'off', 'Color', ...
        [1 1 1], 'Units', 'pixels');
    units = get(h.axes_top, 'Units');
    set(h.axes_top, 'Units', 'pixels');
    pos_top = get(h.axes_top, 'OuterPosition');
    set(h.axes_top, 'Units', units);
    pos_fig = get(h_fig, 'Position');
    set(h_fig, 'Position', [pos_fig(1:2) pos_top(3:4)]);
    h_axes = axes('Parent', h_fig, 'Units', 'pixels', ...
        'OuterPosition', [0,0,pos_top(3:4)]);
    set(h_axes, 'Units', 'normalized');
    plot(h_axes, x_axis, I_bg, '-k');
    xlim(h_axes, get(h.axes_top, 'XLim'));
    ylim(h_axes, 'auto');
    ylabel(h_axes, y_lab);
    xlabel(h_axes, x_lab);
    set(h_fig, 'Visible', 'on');
end
