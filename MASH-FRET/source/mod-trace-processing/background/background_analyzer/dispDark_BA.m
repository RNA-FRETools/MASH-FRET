function dispDark_BA(h_fig,varargin)
% dispDark_BA(h_fig)
% dispDark_BA(h_fig,file_out)
%
% h_fig = handle to Background analyzer figure
% file_out: destination PNG file for dark trace figure

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;

proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
rate = p.proj{proj}.frame_rate;
clr = p.proj{proj}.colours;
nFrames = size(p.proj{proj}.intensities,1)*p.proj{proj}.nb_excitations;
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
meth = g.param{1}{m}(l,c,1);
methprm = g.param{1}{m}(l,c,[2,3,7,4:6]);
dynbg = g.param{1}{m}(l,c,8);

% calculates background trace
[I_bg,~] = calcbgint(m,l,c,dynbg,meth,methprm,p.proj{proj},g.figure_MASH);

% plot background trace
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

h_fig2 = figure('Name','Background trajectory','Visible','off','Color', ...
    [1 1 1],'Units','pixels');
units = get(h.axes_top, 'Units');
set(h.axes_top, 'Units', 'pixels');
pos_top = get(h.axes_top, 'OuterPosition');
set(h.axes_top, 'Units', units);
pos_fig = get(h_fig2, 'Position');
set(h_fig2, 'Position', [pos_fig(1:2) pos_top(3:4)]);
h_axes = axes('Parent', h_fig2, 'Units', 'pixels', 'OuterPosition', ...
    [0,0,pos_top(3:4)]);
set(h_axes, 'Units', 'normalized');
plot(h_axes, x_axis, I_bg, 'color',clr{1}{l,c});
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


