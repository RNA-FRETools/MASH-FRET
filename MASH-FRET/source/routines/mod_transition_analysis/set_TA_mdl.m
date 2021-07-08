function set_TA_mdl(meth,Dmax,restart,h_fig)
% set_TA_mdl(meth,Dmax,restart,h_fig)
%
% Set kinetic model settings
%
% meth: index in list of starting guess determination method
% Dmax: maximum number of degenerated levels when using DPH fit method
% restart: number of Baum-Welch restart for model inferrence
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_TA_mdlMeth,'value',meth);
popupmenu_TA_mdlMeth_Callback(h.popupmenu_TA_mdlMeth,[],h_fig);

if meth==1
    set(h.edit_TA_mdlJmax,'string',num2str(Dmax));
    edit_TA_mdlJmax_Callback(h.edit_TA_mdlJmax,[],h_fig);
end
    
set(h.edit_TA_mdlRestartNb,'string',num2str(restart));
edit_TA_mdlRestartNb_Callback(h.edit_TA_mdlRestartNb,[],h_fig);




