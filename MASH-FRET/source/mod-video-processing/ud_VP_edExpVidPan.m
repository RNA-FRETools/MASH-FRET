function ud_VP_edExpVidPan(h_fig)
% ud_VP_edExpVidPan(h_fig)
%
% Set panel "Edit and export video" in module Video processing to proper values
%
% h_fig: handle to main figure

% default
ttstr0 = {'','';... % none
    'Halfwindow size and standard deviation','';... % gauss
    'Halfwindow size','';... % mean
    'Halfwindow size','';... % median
    'Halfwindow size','Standard deviation';... % ggf
    'Halfwindow size','Noise intensity per pixel' ;... % lwf
    'Noise intensity per pixel','';... % gwf
    'Radius of a spot','Correction intensity' ;... % outlier
    'Percentage of background','';... % histothresh
    'Minimum intensity','';... % simple thresh
    'Tolerance factor','';... % mean (old)
    'Tolerance factor','Histogram interval number';...% most frequent (old)
    '','Cumulative probability threshold';... % histothresh (old)
    '','';... % Ha-all
    '','';... % Ha-each
    'Bandpass Kernel diameter','Noise length';... % Twotone
    '','';... % subtract image
    'Factor','';... % multiplication
    'Offset',''}; % addition

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% make elements invisible if panel is collapsed
h_pan = h.uipanel_VP_editAndExportVideo;
if isPanelOpen(h_pan)==1
    setProp(get(h_pan,'children'),'visible','off');
    return
else
    setProp(get(h_pan,'children'),'visible','on');
end

% set all uicontrol enabled
setProp(get(h_pan,'children'),'enable','on');

h_ed = [h.edit_bgParam_01,h.edit_bgParam_02];

% reset edit fields background color
set([h_ed,h.edit_startMov,h.edit_endMov],'backgroundcolor',[1,1,1]);

% collect processing parameters
labels = p.labels;
meth = p.movBg_method;

% set background correction method
set(h.popupmenu_bgCorr, 'Value', meth);
set(h.checkbox_bgCorrAll, 'Value', ~p.movBg_one);

% set channel
chan = get(h.popupmenu_bgChanel,'value');
if chan>p.nChan
    chan = p.nChan;
end
set(h.popupmenu_bgChanel, 'String', getStrPop('chan',{labels,[]}),'value',...
    chan);

% set correction parameters
for i = 1:size(h_ed,2)
    set(h_ed(i),'String',num2str(p.movBg_p{meth,chan}(i)),'TooltipString',...
        ttstr0{meth,i});
end
if sum(meth==[1,13,14,15,17])
    set(h_ed(1),'enable','off');
end
if sum(meth==[1:4,7,9:11,14,15,17:19])
    set(h_ed(2),'enable','off');
end
if sum(meth==[1,17])
    set(h_ed, 'String', '');
end

% update background correction list
ud_lstBg(h_fig);

% set export parameters
set(h.edit_startMov,'String',num2str(p.mov_start));
set(h.edit_endMov,'String',num2str(p.mov_end));

