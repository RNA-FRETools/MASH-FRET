function ud_cross(h_fig)

% Last update: 10.1.2020 by MH
% >> remove factor UI controls
%
% update: 3.4.2019 by MH
% --> change pushbutton string to "Opt." if method photobleaching-based 
%     gamma is chosen, or "Load" if manual
% --> correct control off-enabling when data "none" is selected
%
% update: 29.3.2019 by MH
% --> delete popupmenu_excDirExc and text_dirExc from GUI
% --> adapt display of bleethrough and direct excitation coefficient to new 
%     parameter structure (see project/setDefPrm_traces.m)
%
% update: 28.3.2019 by MH
% --> UI controls for DE coefficients are made visible even if calculation
%     is not possible (one laser data) but are off-enabled in that case,
%     but popupmenu for laser selection is made off-visible.
%
% update: 26.3.2019 by MH
% --> gamma correction checkbox changed to popupmenu
%
% update: 26.4.2018 by FS
% --> update the gamma correction checkbox when changing to different 
%     molecules

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

% project parameters
proj = p.curr_proj;
mol = p.curr_mol(proj);
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
nExc = numel(exc);
labels = p.proj{proj}.labels;
clr = p.proj{proj}.colours;
chanExc = p.proj{proj}.chanExc;

% processing parameters
curr_exc = p.proj{proj}.fix{3}(1);
curr_chan = p.proj{proj}.fix{3}(2);
curr_btChan = p.proj{proj}.fix{3}(3);
p_panel = p.proj{proj}.fix{4};

set(h.popupmenu_corr_chan, 'Value', 1, 'String', ...
    getStrPop('chan', {labels curr_exc clr{1}}));
set(h.popupmenu_corr_chan, 'Value', curr_chan);

set(h.popupmenu_bt, 'Value', 1, 'String', getStrPop('bt_chan', ...
    {labels curr_chan curr_exc clr{1}}));
set(h.popupmenu_bt, 'Value', curr_btChan);

if nChan > 1
    set(h.edit_bt,'String',num2str(p_panel{1}(curr_chan,curr_btChan)));
else
    set(h.edit_bt,'String','0','enable','off');
end

if nExc==1
    set(h.edit_dirExc,'Enable','off','String','0');
    return
end

l0 = find(exc==chanExc(curr_chan));
if isempty(l0) % no emitter-specific laser defined
    set(h.popupmenu_corr_exc, 'Value', 1,'String',{'none'});
    set(h.edit_dirExc,'String','0');
    set([h.popupmenu_corr_exc,h.edit_dirExc],'Enable','off');
else
    l0 = l0(1);
    set(h.popupmenu_corr_exc, 'Value', 1, 'String', ...
        getStrPop('dir_exc',{exc l0}));
    set(h.popupmenu_corr_exc, 'Value', curr_exc);
    set([h.text_TP_cross_by,h.popupmenu_corr_exc],'Visible','on');
    set([h.popupmenu_corr_exc,h.text_TP_cross_de,h.edit_dirExc],'Enable',...
        'on');
    set(h.edit_dirExc, 'String', num2str(p_panel{2}(curr_exc,curr_chan)));
end

