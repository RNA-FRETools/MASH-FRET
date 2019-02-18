function stop = loading_bar(varargin)
% Open, update or close a loading bar window
% varagin >> action string : "init", "update" or "close"
%         >> structure containing field "barData"
%         >> total number of slopes (only status "init")

% Last update: 19th of May 2014 by Mélodie C.A.S Hadzic



stop = 0;

h_bar = 24;
w_bar = 255;
img_bar = uint8(zeros(h_bar, w_bar, 3));


if nargin >= 2
    status = varargin{1};
    h_fig = varargin{2};
    
    h = guidata(h_fig);

    switch status
        
        case 'init'
            
            if nargin >= 3

                if ~isfield(h, 'barData')

                    % register parameters in h
                    h.barData.curr_var = 0;
                    h.barData.nb_slopes = varargin{3};

                    % open the figure of the loading bar
                    h.barData.fig_bar = figure('Visible', 'off', ...
                        'MenuBar', 'none', 'Resize', 'off', 'Name', ...
                        'Process is running, please wait...', ...
                        'NumberTitle', 'off', 'Units', 'pixels');

                    % adjust dimensions of the new window
                    pos = get(h.barData.fig_bar, 'Position');
                    pos(3) = pos(3) * 2/3;
                    pos(4) = pos(4) / 4;
                    set(h.barData.fig_bar, 'Position', pos);
                    
                    if nargin == 4
                        % create informative text
                        textInfo_bar = sprintf(varargin{4});
                        h.barData.textInfo_bar = uicontrol('Style', ...
                            'text', 'Parent', h.barData.fig_bar, ...
                            'String', textInfo_bar, ...
                            'HorizontalAlignment', 'center', ...
                            'BackgroundColor', ...
                            get(h.barData.fig_bar, 'Color'), ...
                            'ForegroundColor', 'black', 'Units', ...
                            'pixels', 'FontSize', 10);
                        disp(textInfo_bar);
                    else
                        disp('Processing ...');
                    end
                    
                    % create progress text
                    text_bar = sprintf('Progress: ');
                    h.barData.text_bar = uicontrol('Style', 'text', ...
                        'Parent', h.barData.fig_bar, 'String', ...
                        text_bar, 'HorizontalAlignment', 'center', ...
                        'BackgroundColor', get(h.barData.fig_bar, ...
                        'Color'), 'Units', 'pixels');

                    % create image axes and show image bar
                    h.barData.axes_bar = axes('Parent', h.barData.fig_bar);
                    h.barData.img_bar = image(img_bar, 'Parent', ...
                        h.barData.axes_bar);
                    set(h.barData.axes_bar, 'visible', 'off');
                    axis(h.barData.axes_bar, 'image');
                    
                    if nargin == 4
                        % set info text dimension and position
                        pos_textInfo = get(h.barData.textInfo_bar, ...
                            'Position');
                        pos_textInfo(1) = 0;
                        pos_textInfo(2) = pos(4) - 1.3*pos_textInfo(4);
                        pos_textInfo(3) = pos(3);
                        set(h.barData.textInfo_bar, 'Position', ...
                            pos_textInfo);
                    end

                    % set progress text dimension and position
                    pos_text = get(h.barData.text_bar, 'Position');
                    pos_text(3) = pos(3);
                    pos_text(1) = pos(3)/2 - pos_text(3)/2;
                    set(h.barData.text_bar, 'Position', pos_text);

                    % make the figure visible
                    set(h.barData.fig_bar, 'Visible', 'on', ...
                        'CloseRequestFcn', {@fig_bar_CloseRequestFcn, ...
                        h_fig});
                
                else
                    h = rmfield(h, 'barData');
                    guidata(h_fig, h);
                    if nargin == 3
                        loading_bar(varargin{1}, varargin{2}, varargin{3});
                    else
                        loading_bar(varargin{1}, varargin{2}, ...
                            varargin{3}, varargin{4});
                    end
                    h = guidata(h_fig);
                end
                
            else
                str = {'The number of input arguments is not correct' , ...
                    'Initialisation requires 3 arguments'};
                stop = 1;
            end

        case 'update'
            
            if (isfield(h, 'barData') && isfield(h.barData, 'img_bar') ...
                    && ishandle(h.barData.img_bar))
                
                if nargin == 2
                    
                    h.barData.curr_var = h.barData.curr_var + 1;
                    if h.barData.curr_var >= (h.barData.prev_var + ...
                            h.barData.nb_slopes/200)
                        
                        progress = h.barData.curr_var/h.barData.nb_slopes;
                        if progress <= 1
                            
                            cursor_bar = progress * w_bar;
                            cursor_bar = uint8(cursor_bar);

                            % update the loading bar
                            for gg = 3:(cursor_bar - 2)
                                img_bar(3:(h_bar - 2), gg, 2) = 255;
                            end
                            set(h.barData.img_bar, 'CData', img_bar);
                            text_bar = sprintf('Progress: %0.0f%%', ...
                                progress*100);
                            set(h.barData.text_bar, 'String', text_bar);
                            h.barData.prev_var = h.barData.curr_var;
                            drawnow;
                        else
                            close(h.barData.fig_bar);
                            h = rmfield(h, 'barData');
                            str = {['The maximum number of loading ' ...
                                'steps has been reached.'], ['The ' ...
                                'loading bar can not be updated.']};
                            stop = 1;
                        end
                    end
                    
                else
                    close(h.barData.fig_bar);
                    h = rmfield(h, 'barData');
                    str = {['The number of imput arguments is not ' ...
                        'correct'], ['The status "update" requires 2 ' ...
                        'arguments']};
                    stop = 1;
                end
                
            else
                if isfield(h, 'barData')
                    h = rmfield(h, 'barData');
                end
                str = ['The loading bar does not exist: it can not be ' ...
                    'updated.'];
                stop = 1;
            end
            
        case 'close'
            
            if isfield(h, 'barData') && ishandle(h.barData.fig_bar)
                close(h.barData.fig_bar);
                disp('Process completed.');
                h = rmfield(h, 'barData');
            end
    end
    guidata(h_fig, h);
    
else
    stop = 1;
    str = {'The number of imput arguments is not correct!' , ...
        'The function "loading_bar" requires at least 2 arguments.'};
end

if stop == 1
    setContPan('Process interrupted.','error',h_fig);
    warndlg('Process interrupted.');
end

function fig_bar_CloseRequestFcn(hObj, evd, h_fig)
% Remove loading bar infos when closing loading bar window
% "hObj" >> loading bar figure handle
% "evd" >> event structure
% "h_fig" >> MASH figure handle

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
if isfield(h, 'barData')
    h = rmfield(h, 'barData');
    guidata(h_fig, h);
end
delete(hObj);

