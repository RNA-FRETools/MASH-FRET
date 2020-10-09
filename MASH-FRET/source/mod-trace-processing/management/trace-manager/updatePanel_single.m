function updatePanel_single(h_fig, nb_mol_disp)

% Last update by MH, 24.4.2019
% >> allow molecule tagging even if the molecule unselected
% >> review positionning of existing uicontrol
% >> add listboxes as well as "Tag" and "Untag" pushbuttons to allow 
%    mutiple tags
%
% update: by FS, 24.4.2018
% >> add popupmenu for molecule label and deactivate it if the molecule is 
%    not selected
%
%
    
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = double(nS | nFRET);

% get panel pixel dimensions
pan_units = get(h.tm.uipanel_overview,'units');
set(h.tm.uipanel_overview,'units','pixels');
pos_pan = get(h.tm.uipanel_overview,'position');
set(h.tm.uipanel_overview,'units',pan_units);
w_pan = pos_pan(3);
h_pan = pos_pan(4);

% get button pixel dimensions
but_units = get(h.tm.pushbutton_reduce,'units');
set(h.tm.pushbutton_reduce,'units','pixels');
pos_pan = get(h.tm.pushbutton_reduce,'position');
set(h.tm.pushbutton_reduce,'units',but_units);
y_but = pos_pan(2);

% get slide bar pixel dimensions
sb_units = get(h.tm.slider,'units');
set(h.tm.slider,'units','pixels');
pos_sb = get(h.tm.slider,'position');
set(h.tm.slider,'units',sb_units);
w_sb = pos_sb(3);

% calculate control and axes dimensions
mg = 10;
mg_top = h_pan-y_but;
h_line = (h_pan-mg_top-2*mg)/nb_mol_disp;
w_line = w_pan-w_sb-2*mg;
w_cb = 40;
w_pop = 60; 
h_pop = 20;
w_but = 40; 
h_but = h_pop;
w_col = w_cb+w_pop+w_but+4*mg;
w_lst = w_col-w_cb-3*mg; 
h_lst = h_line-h_pop-h_but-4*mg;
h_lst(h_lst<h_pop) = h_pop;
w_axes_tt = (5/6)*(w_line-w_col);
w_axes_hist = (1/6)*(w_line-w_col);
h_axes = h_line/(1+isBot);

fntS = get(h.tm.axes_ovrAll_1, 'FontSize');

% modified by MH, 24.4.2019
% update field reset with new controls
if isfield(h.tm, 'checkbox_molNb')
    for i = 1:size(h.tm.checkbox_molNb,2)
        if ishandle(h.tm.checkbox_molNb(i))
            delete([h.tm.checkbox_molNb(i),h.tm.axes_itt(i),...
                h.tm.axes_itt_hist(i),h.tm.pushbutton_remLabel(i),...
                h.tm.listbox_molLabel(i),h.tm.popup_molNb(i),...
                h.tm.pushbutton_addTag2mol(i)]);
            if isBot
                delete([h.tm.axes_frettt(i),h.tm.axes_hist(i)]);
            end
        end
    end
    h.tm = rmfield(h.tm,{'checkbox_molNb','axes_itt','axes_itt_hist',...
        'pushbutton_remLabel','listbox_molLabel','popup_molNb',...
        'pushbutton_addTag2mol'});
    if isBot
        h.tm = rmfield(h.tm,{'axes_frettt','axes_hist'});
    end
end

for i = nb_mol_disp:-1:1

    y_0 = mg + (nb_mol_disp-i)*h_line;
    x_0 = mg;

    x_next = x_0;
    y_next = y_0;

    h.tm.checkbox_molNb(i) = uicontrol('Style','checkbox','Parent',...
        h.tm.uipanel_overview,'Units','pixel','Position',...
        [x_next y_next w_col-mg h_line],'String',num2str(i),'Value', ...
        h.tm.molValid(i),'Callback',{@checkbox_molNb_Callback,h_fig},...
        'FontSize',12,'BackgroundColor', ...
        0.05*[mod(i,2) mod(i,2) mod(i,2)]+0.85);

    x_next = x_next + w_cb + mg;
    y_next = y_next + mg;

    h.tm.pushbutton_remLabel(i) = uicontrol('Style', 'pushbutton', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_lst h_but], 'Callback', ...
        {@pushbutton_remLabel_Callback,h_fig,i}, 'String', ...
        'Untag');

    y_next = y_next + h_but + mg;

    str_lst = colorTagLists_OV(h_fig,i);

    h.tm.listbox_molLabel(i) = uicontrol('Style', 'listbox', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_lst h_lst],'string',str_lst);

    x_next = x_0 + w_cb + mg;
    y_next = y_next + h_lst + mg;

    % added by FS, 24.4.2018
    str_pop = colorTagNames(h_fig);

    % modified by MH, 24.4.2019
    % adjust popupmenu to first label in default list and remove 
    % callback
%         if h.tm.molTag(i) > length(str_pop)
%             val = 1;
%         else
%             val = h.tm.molTag(i);
%         end
    h.tm.popup_molNb(i) = uicontrol('Style', 'popup', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_pop h_pop], 'String',  str_pop, ...
        'Value', 1);

    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019: allow labelling even if not selected
%         if h.tm.molValid(i) == 0
%             set(h.tm.popup_molNb(i), 'Enable', 'off')
%         else
%             set(h.tm.popup_molNb(i), 'Enable', 'on')
%         end

    x_next = x_next + w_pop + mg;

    h.tm.pushbutton_addTag2mol(i) = uicontrol('Style','pushbutton', ...
        'Parent',h.tm.uipanel_overview,'Units','pixel','Position', ...
        [x_next y_next w_but h_but],'String','Tag','Callback', ...
        {@pushbutton_addTag2mol_Callback,h_fig,i});

    y_next = y_0;
    x_next = w_col;

    h.tm.axes_itt(i) = axes('Parent', h.tm.uipanel_overview, ...
        'Units', 'pixel', 'Position', [x_next y_next w_axes_tt h_axes], ...
        'YAxisLocation', 'right', 'NextPlot', 'replacechildren', ...
        'GridLineStyle', ':', 'FontUnits', 'pixels', 'FontSize', fntS);

    x_next = x_next + w_axes_tt;

    h.tm.axes_itt_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
        'Units','pixel','Position',[x_next y_next w_axes_hist h_axes], ...
        'YAxisLocation','right','GridLineStyle',':','FontUnits', ...
        'pixels','FontSize',fntS);

    if isBot
        x_next = w_col;
        y_next = y_next + h_axes;

        h.tm.axes_frettt(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'pixel', 'Position', ...
            [x_next y_next w_axes_tt h_line/2], 'YAxisLocation', ...
            'right', 'NextPlot', 'replacechildren', 'GridLineStyle',...
            ':', 'FontUnits', 'pixels', 'FontSize', fntS);

        x_next = x_next + w_axes_tt;

        h.tm.axes_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'pixel', 'Position', ...
            [x_next y_next w_axes_hist h_line/2], 'YAxisLocation',...
            'right', 'GridLineStyle', ':', 'FontUnits', 'pixels', ...
            'FontSize', fntS);
    end
end

setProp(get(h.tm.uipanel_overview, 'children'),'units','normalized');

guidata(h_fig, h);

