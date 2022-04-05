function coord_dark = dispDark_BA(h_fig,varargin)
% coord_dark = dispDark_BA(h_fig)
% coord_dark = dispDark_BA(h_fig,file_out)
%
% h_fig = handle to Background analyzer figure
% file_out: destination PNG file for dark trace figure

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;

proj = p.curr_proj;
aDim = p.proj{proj}.pix_intgr(1);
nExc = p.proj{proj}.nb_excitations;
nPix = p.proj{proj}.pix_intgr(2);
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
rate = p.proj{proj}.frame_rate;

nFrames = size(p.proj{proj}.intensities,1)*p.proj{proj}.nb_excitations;

m = g.curr_m;
l = g.curr_l;
c = g.curr_c;

multichanvid = numel(p.proj{proj}.movie_file)==1;
if multichanvid
    mov = 1;
else
    mov = c;
end
res_y = p.proj{proj}.movie_dim{mov}(2);
res_x = p.proj{proj}.movie_dim{mov}(1);
fDat{1} = p.proj{proj}.movie_file{mov};
fDat{2}{1} = p.proj{proj}.movie_dat{mov}{1};
fDat{2}{2} = [];
fDat{3} = [res_y res_x];
fDat{4} = p.proj{proj}.movie_dat{mov}{3};

meth = g.param{1}{m}(l,c,1);
if meth == 6
    autoDark = g.param{1}{m}(l,c,6);
    if autoDark
        subw = g.param{1}{m}(l,c,3);
        coord_dark = getDarkCoord(l, m, c, p, subw);
    else
        coord_dark = [g.param{1}{m}(l,c,4) g.param{1}{m}(l,c,5)];

        min_xy = aDim/2;
        max_y = res_y - aDim/2;
        max_x = res_x - aDim/2;
        coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
        coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
        coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
    end
    
    p1 = g.param{1}{m}(l,c,2);

    [o,I_bg] = create_trace(coord_dark, aDim, nPix, fDat, h.mute_actions);
    I_bg = slideAve(I_bg(l:nExc:end,:), p1);

    y_lab = 'a.u.';

    if perSec
        I_bg = I_bg/rate;
        y_lab = [y_lab '/s'];
    end

    x_axis = l:nExc:nFrames;
    if inSec
        x_axis = x_axis*rate;
        x_lab = 'time (s)';
    else
        x_lab = 'frames';
    end


    h_fig2 = figure('Name', ['Dark trace: (' num2str(coord_dark(1)) ...
        ',' num2str(coord_dark(2)) ')'], 'Visible', 'off', 'Color', ...
        [1 1 1], 'Units', 'pixels');
    units = get(h.axes_top, 'Units');
    set(h.axes_top, 'Units', 'pixels');
    pos_top = get(h.axes_top, 'OuterPosition');
    set(h.axes_top, 'Units', units);
    pos_fig = get(h_fig2, 'Position');
    set(h_fig2, 'Position', [pos_fig(1:2) pos_top(3:4)]);
    h_axes = axes('Parent', h_fig2, 'Units', 'pixels', 'OuterPosition', ...
        [0,0,pos_top(3:4)]);
    set(h_axes, 'Units', 'normalized');
    plot(h_axes, x_axis, I_bg, '-k');
    xlim(h_axes, get(h.axes_top, 'XLim'));
    ylim(h_axes, 'auto');
    ylabel(h_axes, y_lab);
    xlabel(h_axes, x_lab);
    
    if ~isempty(varargin)
        file_out = varargin{1};
        print(h_fig2,file_out,'-dpng');
        close(h_fig2);
    else
        set(h_fig2, 'Visible', 'on');
    end
end


