function buildItgOpt(cio,but_obj,h_fig)
% buildItgOpt(cio,but_obj,h_fig)
%
% Build window for co-localized coordinates import options
%
% cio: {1-by-2} coordinates import options with:
%  cio{1}: [nChan-by-2] columns index in file where x- and y-coordinates are written for each channel
%  cio{2}: number of file header lines
% but_obj: handle to pushbutton that was pressed to open window
% h_fig: handle to main figure

% defaults
figttl = 'Import options';
panttl = 'Molecule coordinates';
str0 = 'Ok';
str1 = 'Cancel';
str2 = 'channel %i:';
str3 = 'x-col';
str4 = 'y-col';
str5 = 'number of header lines:';

% collect layout parameters
h = guidata(h_fig);
if isfield(h,'dimprm')
    p = h.dimprm;
else
    p = h;
end
if isfield(p,'hedit')
    hedit = p.hedit;
    htxt = p.htxt;
    un = p.un;
    fun = p.fun;
    fsz = p.fsz;
else
    hedit = p.hedit0;
    htxt = p.htxt0;
    un = p.posun;
    fun = p.fntun;
    fsz = p.fntsz1;
end

nChan = size(cio{1,1},1);

% dimension
wbut0 = getUItextWidth(str0,fun,fsz,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str1,fun,fsz,'normal',p.tbl)+p.wbrd;
wtxt1 = getUItextWidth(str2,fun,fsz,'normal',p.tbl);
wtxt2 = getUItextWidth(str5,fun,fsz,'normal',p.tbl);
dim_but0 = [wbut0 hedit];
dim_but1 = [wbut1 hedit];
dim_edit = [p.wedit0 hedit];
dim_txt0 = [p.wedit0 htxt];
dim_txt1 = [wtxt1 htxt];
dim_txt2 = [wtxt2 htxt];
hpan = p.mgpan+hedit+p.mg+htxt+hedit+p.mg+(nChan-1)*(hedit+p.mg);
wpan = p.mg+wtxt2+p.mg+p.wedit0+p.mg;
hfig = p.mg+hpan+p.mg+hedit+p.mg;
wfig = wpan+2*p.mg;

posfig = getPixPos(h_fig);
x = posfig(1)+(posfig(3)-wfig)/2;
y = posfig(2)+(posfig(4)-hfig)/2;

h.figure_itgOpt = figure('Resize','off','NumberTitle','off','MenuBar',...
    'none','Name',figttl,'Visible','off','Units',un,'Position',...
    [x y wfig hfig],'CloseRequestFcn',...
    {@figure_itgOpt_CloseRequestFcn,h_fig});

x = p.mg;
y = hfig-p.mg-hpan;

h.itgOpt.uipanel_molCoord = uipanel('parent',h.figure_itgOpt,'Title',...
    panttl,'Units',un,'fontunits',fun,'FontSize',fsz,'Position',...
    [x y wpan hpan]);
h_pan = h.itgOpt.uipanel_molCoord;

% Panel molecule coordinates
x = p.mg;
y = hpan-p.mgpan-hedit+(hedit-htxt)/2;

h.itgOpt.text_nHead = uicontrol('Style','text','Parent',h_pan,'String',...
    str5,'Units',un,'FontUnits',fun,'FontSize',fsz,'HorizontalAlignment',...
    'left','Position',[x y dim_txt2]);

x = x + wtxt2 + p.mg;
y = y-(hedit-htxt)/2;

h.itgOpt.edit_nHead = uicontrol('Style','edit','Parent',h_pan,'String', ...
    num2str(cio{1,2}),'Units',un,'FontUnits',fun,'FontSize',fsz,'Position',...
    [x y dim_edit]);

x = p.mg + wtxt1 + p.mg;
y = y-p.mg-htxt;

h.itgOpt.text_cColX = uicontrol('Style','text','Parent',h_pan,'String',...
    str3,'Units',un,'FontUnits',fun,'FontSize',fsz,'Position',...
    [x y dim_txt0]);

x = x + p.wedit0 + p.mg;

h.itgOpt.text_cColY = uicontrol('Style','text','Parent',h_pan,'String',...
    str4,'Units',un,'FontUnits',fun,'FontSize',fsz,'Position',...
    [x y dim_txt0]);

for i = 1:nChan

    y = y - hedit + (hedit-htxt)/2;
    x = p.mg;

    h.itgOpt.text_cChan(i) = uicontrol('Style','text','Parent',h_pan,...
        'String',sprintf(str2,i),'Units',un,'FontUnits',fun,'FontSize',fsz,...
        'HorizontalAlignment','center','Position',[x y dim_txt1]);

    x = x + wtxt1 + p.mg;
    y = y - (hedit-htxt)/2;

    h.itgOpt.edit_cColX(i) = uicontrol('Style','edit','Parent',h_pan,...
        'String',num2str(cio{1,1}(i,1)),'Units',un,'FontUnits',fun,...
        'FontSize',fsz,'Position',[x y dim_edit]);

    x = x + p.wedit0 + p.mg;

    h.itgOpt.edit_cColY(i) = uicontrol('Style','edit','Parent',h_pan,...
        'String',num2str(cio{1,1}(i,2)),'Units',un,'FontUnits',fun,...
        'FontSize',fsz,'Position',[x y dim_edit]);

    y = y - p.mg;

end

y = p.mg;
x = p.mg;

h.itgOpt.pushbutton_itgOpt_ok = uicontrol('Style','pushbutton','parent',...
    h.figure_itgOpt ,'String',str0,'Units',un,'fontunits',fun,'FontSize',...
    fsz,'Position',[x y dim_but0],'Callback',...
    {@pushbutton_itgOpt_ok_Callback,h_fig,but_obj});

x = x + wbut0 + p.mg;

h.itgOpt.pushbutton_itgOpt_cancel = uicontrol('Style','pushbutton',...
    'parent',h.figure_itgOpt,'String',str1,'Units',un,'fontunits',fun,...
    'FontSize',fsz,'Position',[x y dim_but1],'Callback',...
    {@pushbutton_itgOpt_cancel_Callback,h_fig});

guidata(h_fig, h);

set(h.figure_itgOpt, 'Visible', 'on');
    