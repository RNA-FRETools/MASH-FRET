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
p = h.param;

if ~prepPanel(h.uipanel_VP_editAndExportVideo,h)
    return
end

% collect experiment settings and processing parameters
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
inSec = p.proj{proj}.time_in_sec;
expT = p.proj{proj}.sampling_time;
labels =  p.proj{proj}.labels;
curr = p.proj{proj}.VP.curr;
meth = curr.edit{1}{1}(1);

% set background correction method
set(h.popupmenu_bgCorr, 'Value', meth);
set(h.checkbox_bgCorrAll, 'Value', ~curr.edit{1}{1}(2));

% set channel
chan = get(h.popupmenu_bgChanel,'value');
if chan>nChan
    chan = nChan;
end
set(h.popupmenu_bgChanel, 'String', getStrPop('chan',{labels,[]}),...
    'value',chan);

% set correction parameters
h_ed = [h.edit_bgParam_01,h.edit_bgParam_02];
for i = 1:size(h_ed,2)
    set(h_ed(i),'String',num2str(curr.edit{1}{2}{meth,chan}(i)),...
        'TooltipString',ttstr0{meth,i});
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
if inSec
    curr.edit{2}(1) = curr.edit{2}(1)*expT;
    curr.edit{2}(2) = curr.edit{2}(2)*expT;
    curr.edit{2}(3) = curr.edit{2}(3)*expT;
end
set(h.edit_startMov,'String',num2str(curr.edit{2}(1)));
set(h.edit_endMov,'String',num2str(curr.edit{2}(2)));
set(h.edit_ivMov,'String',num2str(curr.edit{2}(3)));

