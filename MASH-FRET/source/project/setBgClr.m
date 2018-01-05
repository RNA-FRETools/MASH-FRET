function setBgClr(h_fig, clr)
h = guidata(h_fig);
h_2clr = [h.uipanel_simMov h.uipanel_movProc h.uipanel_TTproc ...
    h.uipanel_thm h.uipanel_TDPana h.text_molTot h.text_expTime ...
    h.text_tool h.checkbox_int_ps h.text_frame h.text_frameCurr ...
    h.text_frameEnd h.text_split];

switch clr
    case 'pink'
        clr = [1 0.8 1];
    case 'blue'
        clr = [0.8 1 1];
    case 'yellow'
        clr = [1 1 0.8];
    case 'green'
        clr = [0.8 1 0.8];
    case 'gray'
        clr = [0.941 0.941 0.941];
    case 'danny'
        h_f = figure('Units', 'pixels', 'Name', 'Danny', 'NumberTitle', ...
            'off', 'MenuBar', 'none');
        h_a = axes('Parent', h_f, 'Units', 'pixels', 'Position', ...
            [0 0 220 294]);
        imagesc(imread(['http://www.fechem.uzh.ch/rna/images/thumb/' ...
            '1/10/Members_danny.jpg/220px-Members_danny.jpg']), ...
            'Parent', h_a);
        axis(h_a, 'image');
        p_f = get(h_f, 'Position');
        set(h_f, 'Position', [p_f(1:2) 220 294]);
        set(h_a, 'Position', [1 1 220 294]);
        clr = [0.941 0.941 0.941];
        
    otherwise
        return;
end
set(h.figure_MASH, 'Color', clr);
set(h_2clr, 'BackgroundColor', clr);