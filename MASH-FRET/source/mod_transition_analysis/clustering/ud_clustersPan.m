function ud_clustersPan(h_fig)
% Set cluster panel to proper values

% defaults
clrslct = [0.93,0.93,0.93];
gray = [0.94,0.94,0.94];
ttstr0{1} = {...
    wrapHtmlTooltipString('<b>Square</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Isotropic Gaussian</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Square</b>-shaped clusters')};
ttstr0{2} = {...
    wrapHtmlTooltipString('<b>Straight ellipse</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Straight multivariate Gaussian</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Straight ellipse</b>-shaped clusters')};
ttstr0{3} = {...
    wrapHtmlTooltipString('<b>Diagonal ellipse</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Diagonal multivariate Gaussian</b>-shaped clusters'), ...
    wrapHtmlTooltipString('<b>Diagonal ellipse</b>-shaped clusters')};
ttstr0{4} = {...
    wrapHtmlTooltipString(''), ...
    wrapHtmlTooltipString('<b>Free rotating multivariate Gaussian</b>-shaped clusters'), ...
    wrapHtmlTooltipString('')};
ttstr1{1} = wrapHtmlTooltipString('Select a state to configure');
ttstr1{2} = wrapHtmlTooltipString('Select a cluster to configure');
ttstr1{3} = wrapHtmlTooltipString('Select a cluster to configure');

% collect interface parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect processing parameters
curr = p.proj{proj}.curr{tag,tpe};
meth = curr.clst_start{1}(1);
shape = curr.clst_start{1}(2);
Jmax = curr.clst_start{1}(3);
mat = curr.clst_start{1}(4);
clstDiag = curr.clst_start{1}(9);
logl = curr.clst_start{1}(10);
trs_k = curr.clst_start{2};

% set all controls visible and enabled
set([h.popupmenu_TA_clstMat h.checkbox_TA_clstDiag h.text_TDPlike ...
    h.popupmenu_TDPlike h.text_TDPstate h.popupmenu_TDPstate ...
    h.text_TDPshape h.text_TDPiniVal h.text_TDPradius h.edit_TDPiniValX ...
    h.edit_TDPiniValY h.pushbutton_TDPautoStart h.edit_TDPradiusX ...
    h.edit_TDPradiusY h.togglebutton_TDPshape1 h.togglebutton_TDPshape2 ...
    h.togglebutton_TDPshape3 h.togglebutton_TDPshape4 ...
    h.tooglebutton_TDPmanStart h.pushbutton_TDPupdateClust],'Enable','on', ...
    'Visible','on');
setProp(h.uipanel_TA_selectTool,'enable','on');

% reset edit field background color
set([h.edit_TDPiniValX h.edit_TDPradiusX h.edit_TDPiniValY ...
    h.edit_TDPradiusY], 'BackgroundColor', [1 1 1]);

% set cluster contraint
if mat~=1
    set(h.checkbox_TA_clstDiag, 'enable', 'off');
end
set(h.popupmenu_TA_clstMat, 'value', mat);
set(h.checkbox_TA_clstDiag, 'value', clstDiag);

% set button for switching pointer
tool = get(h.tooglebutton_TDPmanStart,'userdata');
if tool==2 % selection mode
    set(h.tooglebutton_TDPmanStart,'cdata',...
        get(h.tooglebutton_TDPselectCross,'cdata'));
else
    set(h.tooglebutton_TDPmanStart,'cdata',...
        get(h.tooglebutton_TDPselectZoom,'cdata'));
end

% close selection tool panel
set(h.uipanel_TA_selectTool,'visible','off');
set(h.tooglebutton_TDPmanStart,'value',0);

% update selection buttons
h_tb = [h.togglebutton_TDPshape1,h.togglebutton_TDPshape2,...
    h.togglebutton_TDPshape3,h.togglebutton_TDPshape4];
img = get(h_tb(1),'userdata');
set(h_tb(1), 'Cdata', img{meth});
set(h_tb(shape),'value',1,'backgroundcolor',clrslct);
set(h_tb((1:size(h_tb,2))~=shape),'value',0,'backgroundcolor',gray);
for tb = 1:size(h_tb,2)
    set(h_tb(tb),'tooltipstring',ttstr0{tb}{meth});
end

% set starting parameters
if meth==2 % GM
    set([h.text_TDPstate,h.popupmenu_TDPstate,h.text_TDPiniVal,...
        h.text_TDPradius,h.edit_TDPiniValX,h.edit_TDPradiusX,...
        h.edit_TDPiniValY,h.edit_TDPradiusY,h.pushbutton_TDPautoStart,...
        h.tooglebutton_TDPmanStart],'Visible','off','Enable','off');

    set(h.popupmenu_TDPlike,'value',logl);
    
else % k-mean or manual

    set([h.text_TDPlike,h.popupmenu_TDPlike,h_tb(4)],'Visible','off',...
        'Enable','off');

    if mat==1
        set(h.text_TDPstate, 'String', 'state');
        set([h.edit_TDPiniValY h.edit_TDPradiusY], 'Enable', 'off');
    else
        set(h.text_TDPstate, 'String', 'cluster');
    end

    k = get(h.popupmenu_TDPstate, 'Value');
    if k>Jmax
        k = Jmax;
    end
    set(h.popupmenu_TDPstate, 'Value', k, 'String', ...
        cellstr(num2str((1:Jmax)')), 'tooltipstring', ttstr1{mat});

    set(h.edit_TDPiniValX, 'String', num2str(trs_k(k,1)));
    set(h.edit_TDPradiusX, 'String', num2str(trs_k(k,3)));
    if mat==1
        set(h.edit_TDPiniValY, 'String', '');
        set(h.edit_TDPradiusY, 'String', '');
    else
        set(h.edit_TDPiniValY, 'String', num2str(trs_k(k,2)));
        set(h.edit_TDPradiusY, 'String', num2str(trs_k(k,4)));
    end

    ud_selectToolPan(h_fig);
end
