function routinetest_TP_subImages(h_fig,p,prefix)
% routinetest_TP_subImages(h_fig,p,prefix)
%
% Tests sub-image settings and adjustment of molecule coordinates
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

% test sub-image settings
disp(cat(2,prefix,'test sub-image settings...'));

nExc = numel(get(h.popupmenu_subImg_exc,'string'));
for exc = 1:nExc
    set(h.popupmenu_subImg_exc,'value',exc);
    popupmenu_subImg_exc_Callback(h.popupmenu_subImg_exc,[],h_fig);
end

% test coordinates adjustments
disp(cat(2,prefix,'test adjustement of molecule coordinates...'));
nChan = numel(get(h.popupmenu_TP_subImg_channel,'string'));
for c = 1:nChan
    set(h.popupmenu_TP_subImg_channel,'value',c);
    popupmenu_TP_subImg_channel_Callback(h.popupmenu_TP_subImg_channel,[],h_fig);
    
    x = str2double(get(h.edit_TP_subImg_x,'string'));
    set(h.edit_TP_subImg_x,'string',num2str(x+1));
    edit_TP_subImg_x_Callback(h.edit_TP_subImg_x,[],h_fig);
    
    y = str2double(get(h.edit_TP_subImg_y,'string'));
    set(h.edit_TP_subImg_y,'string',num2str(y+1));
    edit_TP_subImg_y_Callback(h.edit_TP_subImg_y,[],h_fig);
end
pushbutton_refocus_Callback(h.checkbox_refocus,[],h_fig);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

