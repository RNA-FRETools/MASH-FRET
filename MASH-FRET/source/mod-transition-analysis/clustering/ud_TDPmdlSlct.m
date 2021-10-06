function ud_TDPmdlSlct(h_fig)

% Last update by MH, 26.1.2020: adapat to current (curr) and last applied (prm) parameters

% defaults
str0 = {'iter nb.','restarts',''};
ttstr0{1} = wrapHtmlTooltipString('Maximum number of <b>k-mean iterations: 100</b> is a good compromise between execution time and result accuracy.');
ttstr0{2} = wrapHtmlTooltipString('Maximum number of <b>GM initializations: 5</b> is a good compromise between execution time and result accuracy.');
ttstr0{3} = '';
ttstr1{1} = wrapHtmlTooltipString('<b>Maximum model complexity:</b> largest possible number of states in the TDP.');
ttstr1{2} = wrapHtmlTooltipString('<b>Maximum model complexity:</b> largest possible number of clusters in the upper or lower half of the TDP.');
ttstr1{3} = wrapHtmlTooltipString('<b>Maximum model complexity:</b> largest possible number of clusters in the TDP.');

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TA_stateConfiguration,h)
    set([h.uipanel_TA_clusters,h.uipanel_TA_results],'visible','off');
    set(h.uipanel_TA_selectTool,'visible','off');
    set(h.tooglebutton_TDPmanStart,'value',0);
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe}; % interface settings at last analysis

meth = curr.clst_start{1}(1);
Jmax = curr.clst_start{1}(3);
mat = curr.clst_start{1}(4);
N = curr.clst_start{1}(5);
boba = curr.clst_start{1}(6);
nSpl = curr.clst_start{1}(7);
nRpl = curr.clst_start{1}(8);

% set method settings
set(h.popupmenu_TA_clstMeth, 'Value', meth);
set(h.edit_TDPnStates,'String',num2str(Jmax),'TooltipString',ttstr1{mat});
set(h.text_TDPiter, 'String', str0{meth});
set(h.edit_TDPmaxiter,'TooltipString',ttstr0{meth});

if sum(meth==[1,2]) 
    set(h.edit_TDPmaxiter,'String',num2str(N));
else
    set(h.edit_TDPmaxiter,'enable','off','String', '');
end

% set BOBA FRET parameters
if meth==3
    set(h.checkbox_TDPboba,'enable','off');
end
set(h.checkbox_TDPboba, 'Value', boba);
if boba
    set(h.edit_TDPnSpl, 'String', num2str(nSpl));
    set(h.edit_TDPnRepl, 'String', num2str(nRpl));
else
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl h.text_TDPnSpl], ...
        'Enable', 'off');
    set([h.edit_TDPnRepl h.edit_TDPnSpl], 'String', '');
end

ud_clustersPan(h_fig);

ud_resultsPan(h_fig);

% update cluster colors
if isfield(prm,'clst_res') && ~isempty(prm.clst_res{1})
    clr = prm.clst_start{3};
else
    clr = curr.clst_start{3};
end
K = size(clr,1);
k = h.popupmenu_TA_setClstClr.Value;
if k>K
    k = K;
end
str_pop = getClrStrPop(cellstr(num2str((1:K)'))',clr);
set(h.popupmenu_TA_setClstClr,'string',str_pop,'value',k);
set(h.pushbutton_TA_setClstClr,'backgroundcolor',clr(k,:));

