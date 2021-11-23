function exportAxes(obj, evd, h_fig)
% exportAxes([],[],h_fig)
% exportAxes(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: destination file for graph image

curr_a = get(h_fig, 'CurrentAxes');
a_units = get(curr_a, 'Units');
set(curr_a, 'Units', 'pixels');
p_a = get(curr_a, 'Position');

wFig = p_a(3); hFig = p_a(4);

f_units = get(h_fig, 'Units');
set(h_fig, 'Units', 'pixels');
p_f = get(h_fig, 'Position');
set(h_fig, 'Units', f_units);

xFig = (p_f(3)-wFig)/2; yFig = (p_f(4)-hFig)/2;

h_f2save = figure('Units', 'pixels', 'Name', 'Export axes', ...
    'NumberTitle', 'off', 'MenuBar', 'figure', 'Color', [1 1 1], ...
    'Position', [xFig yFig wFig hFig], 'Visible', 'off');

h_a = copyobj(curr_a, h_f2save);
set(curr_a, 'Units', a_units);
p_a = getRealPosAxes([0 0 p_a(3:4)], get(h_a,'TightInset'), ...
    'traces');
set(h_a, 'Position', p_a);

set(h_f2save, 'ResizeFcn', {@f2save_ResizeFcn, h_a});

if iscell(obj) % from routine
    fileout = '';
    if numel(obj)==2
        pname = obj{1};
        fname = obj{2};
        if pname(end)~=filesep
            pname = [pname,filesep];
        end
        fileout = [pname,fname];
    elseif numel(obj)==1
        fileout = obj{1};
    end
    if ~isempty(fileout)
        print(h_f2save,fileout,'-dpng');
    end
    close(h_f2save);
else
    set(h_f2save,'visible','on');
end


function f2save_ResizeFcn(obj, evd, h_a)
set(obj, 'Units', 'pixels');
set(h_a, 'Units', 'pixels');
p_f = get(obj, 'Position');
set(h_a, 'Position', p_f);
p_a = getRealPosAxes([0 0 p_f(3:4)], get(h_a,'TightInset'), ...
    'traces');
set(h_a, 'Position', p_a);


