function set_TA_mdl(meth,dtbin,Dmax,Tdph,Tbw,h_fig)
% set_TA_mdl(meth,dtbin,Dmax,Tdph,Tbw,h_fig)
%
% Set kinetic model settings
%
% meth: index in list of starting guess determination method
% dtbin: dwell time histogram bin size (in time steps)
% Dmax: maximum number of degenerated levels when using DPH fit method
% Tdph: number of ML-DPH restarts
% Tbw: number of Baum-Welch restarts
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_TA_mdlMeth,'value',meth);
popupmenu_TA_mdlMeth_Callback(h.popupmenu_TA_mdlMeth,[],h_fig);

if meth==1
    set(h.edit_TA_mdlBin,'string',num2str(dtbin));
    edit_TA_mdlBin_Callback(h.edit_TA_mdlBin,[],h_fig);
    
    set(h.edit_TA_mdlJmax,'string',num2str(Dmax));
    edit_TA_mdlJmax_Callback(h.edit_TA_mdlJmax,[],h_fig);
    
    set(h.edit_TA_mdlDPHrestart,'string',num2str(Tdph));
    edit_TA_mdlDPHrestart_Callback(h.edit_TA_mdlDPHrestart,[],h_fig);
end
    
set(h.edit_TA_mdlRestartNb,'string',num2str(Tbw));
edit_TA_mdlRestartNb_Callback(h.edit_TA_mdlRestartNb,[],h_fig);




