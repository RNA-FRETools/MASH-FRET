function set_TP_photobleaching(meth,prm,h_fig)
% set_TP_photobleaching(meth,prm,h_fig)
%
% Set Photobleaching detection to proper settings
%
% meth: index of detection method in list
% prm: {1-by-2} method parameters for:
%  prm{1}: manual cutoff (cut off frame)
%  prm{2}: threshold-based detection ([nData-by-2] settings for each data as set in getDefault_TP)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_debleachtype,'value',meth);
popupmenu_debleachtype_Callback(h.popupmenu_debleachtype,[],h_fig);

if meth==1
    set(h.edit_photobl_stop,'string',num2str(prm{1}));
    edit_photobl_stop_Callback(h.edit_photobl_stop,[],h_fig);
else
    for dat = 1:numel(h.popupmenu_bleachChan.String)
        set(h.popupmenu_bleachChan,'value',dat);
        popupmenu_bleachChan_Callback(h.popupmenu_bleachChan,[],h_fig);
        
        set(h.edit_photoblParam_01,'string',num2str(prm{2}(dat,1)));
        edit_photoblParam_01_Callback(h.edit_photoblParam_01,[],h_fig);
        
        set(h.edit_photoblParam_02,'string',num2str(prm{2}(dat,2)));
        edit_photoblParam_02_Callback(h.edit_photoblParam_02,[],h_fig);
    end
end


