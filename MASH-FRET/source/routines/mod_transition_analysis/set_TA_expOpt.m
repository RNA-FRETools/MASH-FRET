function set_TA_expOpt(opt,h_fig)
% set_TA_expOpt(opt,h_fig)
%
% Set ASCII files export options to proper values
%
% opt: [1-by-8] export options as set in getDefault_TA (see p.expOpt)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = h.expTDPopt;

set(q.checkbox_TDPascii,'value',opt(1));
checkbox_expTDPopt_TDPascii_Callback(q.checkbox_TDPascii,[],h_fig);
if opt(1)
    set(q.popupmenu_TDPascii,'value',opt(2));
    popupmenu_expTDPopt_TDPascii_Callback(q.popupmenu_TDPascii,[],h_fig);
end

set(q.checkbox_TDPimg,'value',opt(3));
checkbox_expTDPopt_TDPimg_Callback(q.checkbox_TDPimg,[],h_fig);
if opt(3)
    set(q.popupmenu_TDPimg,'value',opt(4));
    checkbox_expTDPopt_TDPimg_Callback(q.popupmenu_TDPimg,[],h_fig);
end

set(q.checkbox_TDPclust,'value',opt(5));
checkbox_expTDPopt_TDPclust_Callback(q.checkbox_TDPclust,[],h_fig);

set(q.checkbox_kinDthist,'value',opt(6));
checkbox_expTDPopt_kinDthist_Callback(q.checkbox_kinDthist,[],h_fig);

set(q.checkbox_kinCurves,'value',opt(7));
checkbox_expTDPopt_kinCurves_Callback(q.checkbox_kinCurves,[],h_fig);

set(q.checkbox_kinBOBA,'value',opt(8));
checkbox_expTDPopt_kinBOBA_Callback(q.checkbox_kinBOBA,[],h_fig);



