function routinetest_TP_subImages(h_fig,p,prefix)
% routinetest_TP_subImages(h_fig,p,prefix)
%
% Tests sub-image settings and adjustment of molecule coordinates
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% multi- and single-channel video-based mash files
vid_type = {'multi-channel', 'single-channel'};

[~,name,ext] = fileparts(p.mash_files{p.nL,p.nChan});
mash_files = {p.mash_files{p.nL,p.nChan},[name,'_sgl',ext]};

for f = 1:numel(mash_files)
    
    disp(cat(2,prefix,'test ',vid_type{f},' video-based project...'));
    
    % open default project
    disp(cat(2,prefix,'>> import file ',mash_files{f}));
    pushbutton_openProj_Callback({p.annexpth,mash_files{f}},[],h_fig);

    % set default parameters
    setDefault_TP(h_fig,p);

    % expand panel
    h_but = getHandlePanelExpandButton(h.uipanel_TP_subImages,h_fig);
    if strcmp(h_but.String,char(9660))
        pushbutton_panelCollapse_Callback(h_but,[],h_fig);
    end

    % test sub-image settings
    disp(cat(2,prefix,'>> test sub-image settings...'));

    nExc = numel(get(h.popupmenu_subImg_exc,'string'));
    for exc = 1:nExc
        set(h.popupmenu_subImg_exc,'value',exc);
        popupmenu_subImg_exc_Callback(h.popupmenu_subImg_exc,[],h_fig);
    end

    % test coordinates adjustments
    disp(cat(2,prefix,'>> test adjustement of molecule coordinates...'));
    nChan = numel(get(h.popupmenu_TP_subImg_channel,'string'));
    for c = 1:nChan
        set(h.popupmenu_TP_subImg_channel,'value',c);
        popupmenu_TP_subImg_channel_Callback(h.popupmenu_TP_subImg_channel,...
            [],h_fig);

        x = str2double(get(h.edit_TP_subImg_x,'string'));
        set(h.edit_TP_subImg_x,'string',num2str(x+1));
        edit_TP_subImg_x_Callback(h.edit_TP_subImg_x,[],h_fig);

        y = str2double(get(h.edit_TP_subImg_y,'string'));
        set(h.edit_TP_subImg_y,'string',num2str(y+1));
        edit_TP_subImg_y_Callback(h.edit_TP_subImg_y,[],h_fig);
    end
    pushbutton_refocus_Callback(h.checkbox_refocus,[],h_fig);

    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
end

