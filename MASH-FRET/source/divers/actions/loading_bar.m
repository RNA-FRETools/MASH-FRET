function stop = loading_bar(varargin)
% stop = loading_bar('init', h_fig, iterNb)
% stop = loading_bar('init', h_fig, iterNb, text)
% stop = loading_bar('update',h_fig)
% stop = loading_bar('close')
%
% Open, update or close the loading bar.
% loading_bar has to be initialized prior the iterative process, updated at each iteration and closed after process compeltion.
% The variable h.barData.prev_var has to be created externally, just after initialization (set value to 0).
%
% h_fig: handle to main figure
% iterNb: number of iterations the loadingbar has to monitor
% text: action string
% stop: execution failure (1) or success (0)

% Last update: 19th of May 2014 by Mélodie C.A.S Hadzic

stop = 0;

h_bar = 24;
w_bar = 255;
img_bar = uint8(zeros(h_bar, w_bar, 3));

if nargin<2
    stop = 1;
    warndlg({cat(2,'Process interrupted: the number of imput arguments is ',...
        'not correct!'),...
        'The function "loading_bar" requires at least 2 arguments.'});
    return
end
status = varargin{1};
h_fig = varargin{2};

h = guidata(h_fig);
if h.mute_actions
    if strcmp(status,'init')
        h.barData.curr_var = 0;
        guidata(h_fig,h);
        return
    elseif strcmp(status,'update')
        return
    end
end

switch status

    case 'init'
        if nargin<3
            setContPan(cat(2,'The number of input arguments is not ',...
                'correct\nInitialisation requires 3 arguments'),'error',...
                h_fig);
            stop = 1;
            return
        end
        if isfield(h, 'barData')
            h = rmfield(h, 'barData');
            guidata(h_fig, h);
            if nargin==3
                loading_bar(varargin{1},varargin{2},varargin{3});
            else
                loading_bar(varargin{1},varargin{2},varargin{3},...
                    varargin{4});
            end
            return
        end
        
        % register parameters in h
        h.barData.curr_var = 0;
        h.barData.nb_slopes = varargin{3};

        % open the figure of the loading bar
        h.barData.fig_bar = figure('Visible','off','MenuBar','none',...
            'Resize','off','Name','Process is running, please wait...', ...
            'NumberTitle','off','Units','pixels');

        % adjust dimensions of the new window
        pos = get(h.barData.fig_bar, 'Position');
        pos(3) = pos(3) * 2/3;
        pos(4) = pos(4) / 4;
        set(h.barData.fig_bar, 'Position', pos);

        if nargin == 4
            % create informative text
            textInfo_bar = sprintf(varargin{4});
            h.barData.textInfo_bar = uicontrol('Style','text','Parent',...
                h.barData.fig_bar,'String',textInfo_bar,...
                'HorizontalAlignment','center','BackgroundColor', ...
                get(h.barData.fig_bar, 'Color'),'ForegroundColor','black',...
                'Units','pixels','FontSize',10);
            disp(textInfo_bar);
        else
            disp('Processing ...');
        end

        % create progress text
        text_bar = sprintf('Progress: ');
        h.barData.text_bar = uicontrol('Style','text','Parent', ...
            h.barData.fig_bar,'String',text_bar,'HorizontalAlignment',...
            'center','BackgroundColor',get(h.barData.fig_bar,'Color'),...
            'Units','pixels');

        % create image axes and show image bar
        h.barData.axes_bar = axes('Parent', h.barData.fig_bar);
        h.barData.img_bar = image(img_bar, 'Parent', h.barData.axes_bar);
        set(h.barData.axes_bar, 'visible', 'off');
        axis(h.barData.axes_bar, 'image');

        if nargin == 4
            % set info text dimension and position
            pos_textInfo = get(h.barData.textInfo_bar, 'Position');
            pos_textInfo(1) = 0;
            pos_textInfo(2) = pos(4) - 1.3*pos_textInfo(4);
            pos_textInfo(3) = pos(3);
            set(h.barData.textInfo_bar, 'Position', pos_textInfo);
        end

        % set progress text dimension and position
        pos_text = get(h.barData.text_bar, 'Position');
        pos_text(3) = pos(3);
        pos_text(1) = pos(3)/2 - pos_text(3)/2;
        set(h.barData.text_bar, 'Position', pos_text);

        % make the figure visible
        set(h.barData.fig_bar, 'Visible', 'on', 'CloseRequestFcn', ...
            {@fig_bar_CloseRequestFcn, h_fig});

    case 'update'
        if ~(isfield(h, 'barData') && isfield(h.barData, 'img_bar') ...
                && ishandle(h.barData.img_bar))
            if isfield(h, 'barData')
                h = rmfield(h, 'barData');
            end
            setContPan('Process interrupted.','error',h_fig);
            stop = 1;
            guidata(h_fig,h);
            return
        end
        if nargin~=2
            close(h.barData.fig_bar);
            h = rmfield(h, 'barData');
            disp(cat(2,'The number of imput arguments is not correct: the ',...
                'status "update" requires 2 arguments'));
            stop = 1;
            guidata(h_fig,h);
            return
        end

        h.barData.curr_var = h.barData.curr_var + 1;
        if h.barData.curr_var<(h.barData.prev_var+h.barData.nb_slopes/200)
            guidata(h_fig,h);
            return
        end

        progress = h.barData.curr_var/h.barData.nb_slopes;
        if progress <= 1

            cursor_bar = progress * w_bar;
            cursor_bar = uint8(cursor_bar);

            % update the loading bar
            for gg = 3:(cursor_bar - 2)
                img_bar(3:(h_bar - 2), gg, 2) = 255;
            end
            set(h.barData.img_bar, 'CData', img_bar);
            text_bar = sprintf('Progress: %0.0f%%', progress*100);
            set(h.barData.text_bar, 'String', text_bar);
            h.barData.prev_var = h.barData.curr_var;
            drawnow;

        else
            close(h.barData.fig_bar);
            h = rmfield(h, 'barData');
            disp(cat(2,'The maximum number of loading steps has been ',...
                'reached: the loading bar can no longer be updated.'));
            stop = 1;
            guidata(h_fig,h);
            return
        end

    case 'close'
        if isfield(h, 'barData')
            if isfield(h.barData,'fig_bar') && ishandle(h.barData.fig_bar)
                close(h.barData.fig_bar);
                h = rmfield(h, 'barData');
                disp('Process completed.');
            else
                h = rmfield(h, 'barData');
            end
        end
end
guidata(h_fig, h);
    

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

