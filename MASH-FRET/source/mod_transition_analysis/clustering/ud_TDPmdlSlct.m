function ud_TDPmdlSlct(h_fig)

% Last update by MH, 26.1.2020: adapat to current (curr) and last applied (prm) parameters

% defaults
str0 = 'iter nb.';
str1 = 'restarts';
ttstr0 = cat(2,'<html>Maximum number of <b>k-mean iterations:</b><br><b>',...
    '100</b> is a good compromise between<br>execution time and ',...
    'result accuracy.</html>');
ttstr1 = cat(2,'<html>Maximum number of <b>GM initializations:</b><br> <b>',...
    '5</b> is a good compromise between<br>execution time and result ',...
    'accuracy.</html>');

% collect interface parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect processing parameters
curr = p.proj{proj}.curr{tag,tpe}; % current interface settings
meth = curr.clst_start{1}(1);
Jmax = curr.clst_start{1}(3);
mat = curr.clst_start{1}(4);
N = curr.clst_start{1}(5);
boba = curr.clst_start{1}(6);
nSpl = curr.clst_start{1}(7);
nRpl = curr.clst_start{1}(8);
clstDiag = curr.clst_start{1}(9);

% set all controls on-enabled
set([h.text_TA_clstMeth h.popupmenu_TA_clstMeth h.text_TDPiter ...
    h.edit_TDPmaxiter h.text_TDPnStates h.edit_TDPnStates ...
    h.checkbox_TA_clstMat h.checkbox_TA_clstDiag h.checkbox_TDPboba ...
    h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl h.text_TDPnSpl], ...
    'Enable','on','Visible','on');

% reset edit field background color
set([h.edit_TDPmaxiter h.edit_TDPnStates h.edit_TDPnRepl h.edit_TDPnSpl], ...
    'BackgroundColor', [1 1 1]);

% set method settings
set(h.popupmenu_TA_clstMeth, 'Value', meth);
set(h.edit_TDPnStates, 'String', num2str(Jmax));
if meth==3
    set([h.checkbox_TA_clstMat,h.checkbox_TA_clstDiag], 'enable', 'off', ...
        'value', 0);
else
    set(h.checkbox_TA_clstMat, 'value', mat);
    if mat
        set(h.checkbox_TA_clstDiag, 'value', clstDiag);
    else
        set(h.checkbox_TA_clstDiag, 'enable', 'off', 'value', 0);
    end
end
switch meth 
    case 1 % kmean clustering
        set(h.text_TDPiter, 'String', str0);
        set(h.edit_TDPmaxiter,'String',num2str(N),'TooltipString',ttstr0);
    
    case 2 % GMM-based clustering
        set(h.text_TDPiter, 'String', str1);
        set(h.edit_TDPmaxiter,'String',num2str(N),'TooltipString',ttstr1);
        
    case 3 % manual
        set([h.text_TDPiter h.edit_TDPmaxiter], 'Enable', 'off');
        set(h.edit_TDPmaxiter, 'String', '');
        set(h.checkbox_TA_clstMat, 'enable', 'off', 'value', 0);
end

% set BOBA FRET parameters
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

