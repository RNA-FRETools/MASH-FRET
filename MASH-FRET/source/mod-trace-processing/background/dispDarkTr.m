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
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
clr = p.proj{proj}.colours;
selected_chan = p.proj{proj}.TP.fix{3}(6);
dynbg = p.proj{proj}.TP.curr{mol}{3}{1}(:,:,2);
vidfile = p.proj{proj}.movie_file;
viddat = p.proj{proj}.movie_dat;

nMov = numel(vidfile);
multichanvid = nMov==1;

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

% get video index
if multichanvid
    mov = 1;
else
    mov = c;
end

% control method
if ~dynbg(l,c)
    return
end

% build background intensity-time trace
dynbg = p.proj{proj}.TP.curr{mol}{3}{1}(l,c,2);
meth = p.proj{proj}.TP.curr{mol}{3}{2}(l,c);
methprm = p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(meth,:);
[I_bg,~] = calcbgint(mol,l,c,dynbg,meth,methprm,p.proj{proj},h_fig);

% plot trace
y_lab = 'counts';
if perSec
    I_bg = I_bg/expT;
    y_lab = [y_lab 'per s.'];
end

nFrames = viddat{mov}{3};
x_axis = l:nExc:nFrames;
if inSec
    x_axis = x_axis*expT;
    x_lab = 'time (s)';
else
    x_lab = 'frames';
end
h_fig2 = figure('Name', 'Background trajectory', 'Visible', 'off', 'Color', ...
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
plot(h_axes, x_axis, I_bg, 'color',clr{1}{l,c});
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
