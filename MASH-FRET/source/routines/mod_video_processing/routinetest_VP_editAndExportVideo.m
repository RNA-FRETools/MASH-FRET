function routinetest_VP_editAndExportVideo(h_fig,p,prefix)
% routinetest_VP_editAndExportVideo(h_fig,p,prefix)
%
% Tests different image filters, filter list management and video export to files of different formats
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
bugfilters = [2,5:10];

% collect interface parameters
h = guidata(h_fig);

setDefault_VP(h_fig,p,prefix);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_VP_editAndExportVideo,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

disp(cat(2,prefix,'>> test different image filters...'));
filt_list = get(h.popupmenu_bgCorr,'string');
nCorr = size(filt_list,1);
m = 1;
for corr = 1:nCorr
    if sum(bugfilters==corr)
        continue
    end

    % apply background for all frames
    disp(cat(2,prefix,'>> "',filt_list{corr},'" on all frames...'));
    set_VP_imFilters(corr,p.bg_prm,true,[p.annexpth,filesep,p.bg_file],...
        p.nChan,h_fig);

    % move sliding bar
    n = get(h.slider_img,'value');
    set(h.slider_img,'value',n+m);
    m = -m;
    slider_img_Callback(h.slider_img,[],h_fig);

    % export
    pushbutton_export_Callback({p.dumpdir,[p.exp_vid,...
        sprintf('_bg%i_all',corr),p.exp_fmt{1}]},[],h_fig);

    % apply background on current frame only
    disp(cat(2,prefix,'>> "',filt_list{corr},'" on current frame...'));
    set_VP_imFilters(corr,p.bg_prm,false,[p.annexpth,filesep,p.bg_file],...
        p.nChan,h_fig);

    % move sliding bar
    n = get(h.slider_img,'value');
    set(h.slider_img,'value',n+m);
    m = -m;
    slider_img_Callback(h.slider_img,[],h_fig);

    pushbutton_export_Callback({p.dumpdir,[p.exp_vid,sprintf('_bg%i',corr),...
        p.exp_fmt{1}]},[],h_fig);
end

setDefault_VP(h_fig,p,prefix);

% export to different formats
disp(cat(2,prefix,'test export to different file formats...'));
nFmt = size(p.exp_fmt,2);
for fmt = 1:nFmt
    disp(cat(2,prefix,'>> export ',p.exp_fmt{fmt},'...'));
    if strcmp(p.exp_fmt{fmt},'.png')
        set(h.edit_startMov,'string',num2str(1));
        edit_startMov_Callback(h.edit_startMov,[],h_fig);

        set(h.edit_endMov,'string',num2str(1));
        edit_endMov_Callback(h.edit_endMov,[],h_fig);

        set(h.edit_ivMov,'string',num2str(1));
        edit_ivMov_Callback(h.edit_ivMov,[],h_fig);
    else
        set(h.edit_startMov,'string',num2str(p.vid_start));
        edit_startMov_Callback(h.edit_startMov,[],h_fig);

        set(h.edit_endMov,'string',num2str(p.vid_end));
        edit_endMov_Callback(h.edit_endMov,[],h_fig);

        set(h.edit_ivMov,'string',num2str(p.vid_iv));
        edit_ivMov_Callback(h.edit_ivMov,[],h_fig);
    end
    pushbutton_export_Callback({p.dumpdir,[p.exp_vid,p.exp_fmt{fmt}]},[],...
        h_fig);
end

