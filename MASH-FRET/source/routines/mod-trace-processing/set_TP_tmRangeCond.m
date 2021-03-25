function set_TP_tmRangeCond(opt,h_fig)
% set_TP_tmRangeCond(opt,h_fig)
%
% Set range condition in Trace manager
%
% opt: [1-by10] options as set in getDefault_TP (see p.tmOpt)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = h.tm;

set(q.popupmenu_cond,'value',opt{3}(2));
popupmenu_cond_Callback(q.popupmenu_cond,[],h_fig);

set(q.edit_conf1,'string',num2str(opt{3}(3)));
edit_conf_Callback(q.edit_conf1,[],h_fig);

if opt{3}(2)==3
    set(q.edit_conf2,'string',num2str(opt{3}(4)));
    edit_conf_Callback(q.edit_conf2,[],h_fig);
end

set(q.popupmenu_units,'value',opt{3}(5));
popupmenu_units_Callback(q.popupmenu_units,[],h_fig);