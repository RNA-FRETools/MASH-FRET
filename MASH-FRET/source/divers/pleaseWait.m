function pleaseWait(action, h_fig)
% Open a window displaying a waiting message.
% "action" >> window action string: "start" or "close"
% "h_fig" >> MASH figure handle

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

switch action
    case 'start'
        h.wait.prevFig = h_fig;
        h.wait.figWait = figure('Name', 'Figwait', 'Visible', 'off', 'MenuBar', 'none', 'Resize', 'off', 'Name', 'Process is running, please wait...', 'NumberTitle', 'off', 'Units', 'pixels', 'Color', [0.949 0.949 0.949]);

        % adjust dimensions of the new window
        set(0, 'CurrentFigure', h.wait.figWait);
        pos = get(h.wait.figWait, 'Position');
        pos(3) = pos(3) * 2/3;
        pos(4) = pos(4) / 4;
        set(h.wait.figWait, 'Position', pos);
        text_pleaseWait = 'Please Wait...';
        h_text = uicontrol('Style', 'text', 'FontName', 'Freestyle Script', 'FontSize', 48, 'String', text_pleaseWait, 'HorizontalAlignment', 'center', 'BackgroundColor', [0.949 0.949 0.949], 'Units', 'pixels');

        % set text dimension and position
        pos_text = get(h_text, 'Position');
        pos_text(3) = pos(3);
        pos_text(4) = 2*pos(4)/3;
        set(h_text, 'Position', pos_text);

        % make the figure visible
        set(h.wait.figWait, 'Visible', 'on');
        drawnow;
        
    case 'close'
        if (isfield(h, 'wait') && isfield(h.wait, 'figWait') && ishandle(h.wait.figWait))
            close(h.wait.figWait);
            h = rmfield(h, 'wait');
        end
end

guidata(h_fig, h);
