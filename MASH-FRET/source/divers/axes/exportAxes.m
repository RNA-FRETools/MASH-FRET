function exportAxes(obj, evd, h_f)

curr_a = get(h_f, 'CurrentAxes');
a_units = get(curr_a, 'Units');
set(curr_a, 'Units', 'pixels');
p_a = get(curr_a, 'Position');

wFig = p_a(3); hFig = p_a(4);

f_units = get(h_f, 'Units');
set(h_f, 'Units', 'pixels');
p_f = get(h_f, 'Position');
set(h_f, 'Units', f_units);

xFig = (p_f(3)-wFig)/2; yFig = (p_f(4)-hFig)/2;

h_f2save = figure('Units', 'pixels', 'Name', 'Export axes', ...
    'NumberTitle', 'off', 'MenuBar', 'figure', 'Color', [1 1 1], ...
    'Position', [xFig yFig wFig hFig]);

h_a = copyobj(curr_a, h_f2save);
set(curr_a, 'Units', a_units);
p_a = getRealPosAxes([0 0 p_a(3:4)], get(h_a,'TightInset'), ...
    'traces');
set(h_a, 'Position', p_a);

set(h_f2save, 'ResizeFcn', {@f2save_ResizeFcn, h_a});


function f2save_ResizeFcn(obj, evd, h_a)
set(obj, 'Units', 'pixels');
set(h_a, 'Units', 'pixels');
p_f = get(obj, 'Position');
set(h_a, 'Position', p_f);
p_a = getRealPosAxes([0 0 p_f(3:4)], get(h_a,'TightInset'), ...
    'traces');
set(h_a, 'Position', p_a);


