function dispDarkTr(h_fig,varargin)
% dispDarkTr(h_fig)
% dispDarkTr(h_fig,file_out)
% 
% h_fig: handle to main figure
% file_out: destination image file to export dark trace figure to

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
expT = p.proj{proj}.frame_rate;
aDim = p.proj{proj}.pix_intgr(1);
nPix = p.proj{proj}.pix_intgr(2);
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
selected_chan = p.proj{proj}.TP.fix{3}(6);
methods = p.proj{proj}.TP.curr{mol}{3}{2};
bgprm = p.proj{proj}.TP.curr{mol}{3}{3};
res_y = p.proj{proj}.movie_dim(2);
res_x = p.proj{proj}.movie_dim(1);
vidfile = p.proj{proj}.movie_file;
viddat = p.proj{proj}.movie_dat;

% get channel and laser corresponding to selected data
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

% control method
method = methods(l,c);
if method~=6
    return
end

% control dark coordinates
coord_dark = bgprm{l,c}(method,4:5);
min_xy = aDim/2;
max_y = res_y - aDim/2;
max_x = res_x - aDim/2;
coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
coord_dark(coord_dark(:,2)>=max_y)=max_y-1;

% save modifications
p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(method,4:5) = coord_dark;

h.param = p;
guidata(h_fig, h);

% build background intensity-time trace
fDat{1} = vidfile;
fDat{2}{1} = viddat{1};
if isFullLengthVideo(p.proj{proj}.movie_file,h_fig)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = [res_y res_x];
fDat{4} = viddat{3};

[o,I_bg] = create_trace(coord_dark, aDim, nPix, fDat, h.mute_actions);

nFrames = viddat{3};
fact = bgprm{l,c}(method,1);
I_bg = slideAve(I_bg(l:nExc:nFrames,:), fact);

% plot trace
y_lab = 'counts';
if perSec
    I_bg = I_bg/expT;
    y_lab = [y_lab 'per s.'];
end
x_axis = l:nExc:nFrames;
if inSec
    x_axis = x_axis*expT;
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
h_axes = axes('Parent', h_fig2, 'Units', 'pixels', ...
    'OuterPosition', [0,0,pos_top(3:4)]);
set(h_axes, 'Units', 'normalized');
plot(h_axes, x_axis, I_bg, '-k');
xlim(h_axes, get(h.axes_top, 'XLim'));
ylim(h_axes, 'auto');
ylabel(h_axes, y_lab);
xlabel(h_axes, x_lab);

% save plot to file
if ~isempty(varargin)
    file_out = varargin{1};
    print(h_fig2,file_out,'-dpng');
    close(h_fig2);
else
    set(h_fig2, 'Visible', 'on');
end
