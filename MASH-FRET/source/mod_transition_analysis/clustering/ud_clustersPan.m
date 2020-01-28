function ud_clustersPan(h_fig)
% Set cluster panel to proper values

% collect interface parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect processing parameters
curr = p.proj{proj}.curr{tag,tpe};
meth = curr.clst_start{1}(1);
mode = curr.clst_start{1}(2);
Jmax = curr.clst_start{1}(3);
logl = curr.clst_start{1}(10);
trs_k = curr.clst_start{2};

% set all controls visible and enabled
set([h.text_TDPstate h.popupmenu_TDPstate h.text_TDPshape ...
    h.popupmenu_TDPshape h.text_TDPlike h.popupmenu_TDPlike ...
    h.text_TDPiniVal h.edit_TDPiniVal h.text_TDPradius h.edit_TDPradius ...
    h.pushbutton_TDPautoStart h.tooglebutton_TDPmanStart...
    h.pushbutton_TDPupdateClust], 'Enable', 'on', 'Visible','on');
setProp(h.uipanel_TA_selectTool,'enable','on');

% reset edit field background color
set([h.edit_TDPiniVal h.edit_TDPradius], 'BackgroundColor', [1 1 1]);

% close selection tool panel
set(h.uipanel_TA_selectTool,'visible','off');
set(h.tooglebutton_TDPmanStart,'value',0);

% set starting parameters
switch meth 
    case 1 % kmean clustering
        set([h.text_TDPshape,h.popupmenu_TDPshape,h.text_TDPlike,...
            h.popupmenu_TDPlike],'Visible','off','Enable','off');
        
        state = get(h.popupmenu_TDPstate, 'Value');
        if state > Jmax
            state = Jmax;
        end

        set(h.popupmenu_TDPstate, 'Value', state, 'String', ...
            cellstr(num2str((1:Jmax)')));

        set(h.text_TDPstate, 'String', 'state:');
        set(h.text_TDPiniVal, 'String', 'value');
        set(h.text_TDPradius, 'String', 'radius');
        set(h.edit_TDPiniVal, 'String', num2str(trs_k(state,1)));
        set(h.edit_TDPradius, 'String', num2str(trs_k(state,2)));

        ud_selectToolPan(h_fig);
    
    case 2 % GMM-based clustering
        set([h.text_TDPstate,h.popupmenu_TDPstate,h.text_TDPiniVal,...
            h.text_TDPradius,h.edit_TDPiniVal,h.edit_TDPradius,...
            h.pushbutton_TDPautoStart,h.tooglebutton_TDPmanStart],...
            'Visible','off','Enable','off');

        set(h.popupmenu_TDPshape, 'Value', mode);
        set(h.popupmenu_TDPlike,'value',logl);

    case 3 % manual
        set([h.text_TDPshape,h.popupmenu_TDPshape,h.text_TDPlike,...
            h.popupmenu_TDPlike,h.pushbutton_TDPautoStart],'Visible','off',...
            'Enable','off');
        
        state = get(h.popupmenu_TDPstate, 'Value');
        if state > Jmax
            state = Jmax;
        end

        set(h.popupmenu_TDPstate, 'Value', state, 'String', ...
            cellstr(num2str((1:Jmax)')));

        set(h.text_TDPstate, 'String', 'state:');
        set(h.text_TDPiniVal, 'String', 'value');
        set(h.text_TDPradius, 'String', 'radius');
        set(h.edit_TDPiniVal, 'String', num2str(trs_k(state,1)));
        set(h.edit_TDPradius, 'String', num2str(trs_k(state,2)));

        ud_selectToolPan(h_fig);
end
