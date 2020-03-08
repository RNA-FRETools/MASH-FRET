function expTDPopt(h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return;
end

proj = p.curr_proj;
p_proj = p.proj{proj};

prm = p_proj.exp;
prm_default = getExpTDPprm();
prm = adjustVal(prm, prm_default);

if isfield(h, 'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') ...
        && ishandle(h.expTDPopt.figure_expTDPopt)
    return;
end

%% build data type list

str_img = {'original', 'Gaussian convoluted', 'all'};

str_tdp = {'matrix(*.tdp)', 'gauss. convoluted matrix(*.tdp)', ...
    'coordinates (x,y,occurrence)(*.txt)', 'all(*.tdp, *.txt)'};

w_pan = 210;
mg = 10;
w_full = w_pan-2*mg;
h_ed = 20;
w_txt2 = 85; h_txt = 14;
w_pop = 105;
w_but = 50;

mg_sml = mg/2;
mg_ttl = mg_sml + mg;

h_TDP = mg_ttl + 4*mg + h_txt + 2*h_ed;
h_kin = mg_ttl + 4*mg + 3*h_ed;

wFig = w_pan + 2*mg;
hFig = 4*mg + h_TDP + h_kin + h_ed;
pos_0 = get(0, 'ScreenSize');
xFig = (pos_0(3)-wFig)/2;
yFig = (pos_0(4)-hFig)/2;

bgClr = get(h_fig, 'Color');

q.figure_expTDPopt = figure('Name','Export options', 'MenuBar','none', ...
    'NumberTitle','off', 'Visible','off', ...
    'CloseRequestFcn',{@figure_expTDPopt_CloseRequestFcn, h_fig}, ...
    'Units','pixels', 'Position',[xFig yFig wFig hFig], 'Color', bgClr);


%% Pushbuttons

x = wFig-mg-w_but;
y = hFig-h_TDP-h_kin-h_ed-3*mg;

q.pushbutton_next = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Next >>', ...
    'Position',[x y w_but h_ed], ...
    'Callback',{@pushbutton_expTDPopt_next_Callback, h_fig});

x = x-mg-w_but;

q.pushbutton_cancel = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Cancel', ...
    'Position',[x y w_but h_ed], ...
    'Callback',{@pushbutton_expTDPopt_cancel_Callback, h_fig});


h = guidata(h_fig);
h.expTDPopt = q;
guidata(h_fig,h);
q.pushbutton_help = setInfoIcons(h.expTDPopt.pushbutton_cancel,...
    h_fig,h.param.movPr.infos_icon_file);


%% Kinetic analysis

x = wFig-mg-w_pan;
y = hFig-h_TDP-h_kin-2*mg;

q.uipanel_kin = uipanel('Parent',q.figure_expTDPopt, 'Units','pixels', ...
    'Title','Kinetic analysis', 'BackgroundColor',bgClr, ...
    'Position',[x y w_pan h_kin]);

x = mg;
y = mg;

q.checkbox_kinBOBA = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'String','BOBA FRET results(*.fit)', ...
    'Position',[x y w_full h_ed], ...
    'Callback',{@checkbox_expTDPopt_kinBOBA_Callback, h_fig}, 'Value',prm{3}(3));

y = y+h_ed+mg;

q.checkbox_kinCurves = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y w_full h_ed], ...
    'String','fitting curves & parameters(*.fit)', ...
    'Callback',{@checkbox_expTDPopt_kinCurves_Callback, h_fig}, 'Value',prm{3}(2));

y = y+h_ed+mg;

q.checkbox_kinDthist = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y w_full h_ed], ...
    'String','dwell-time histograms(*.hdt)', ...
    'Callback',{@checkbox_expTDPopt_kinDthist_Callback, h_fig}, 'Value',prm{3}(1));


%% TDP

x = wFig-mg-w_pan;
y = hFig-h_TDP-mg;

q.uipanel_TDP = uipanel('Parent',q.figure_expTDPopt, 'Units','pixels', ...
    'Title','TDP', 'BackgroundColor',bgClr, 'Position',[x y w_pan h_TDP]);

x = mg;
y = mg;

q.checkbox_TDPclust = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','clusters', ...
    'Position',[x y w_full h_ed], ...
    'Callback',{@checkbox_expTDPopt_TDPclust_Callback, h_fig}, 'Value',prm{2}(5));

x = mg+w_txt2;
y = y+h_ed+mg;

q.popupmenu_TDPimg = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y w_pop h_ed], ...
    'String',str_img, 'Callback',{@popupmenu_expTDPopt_TDPimg_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',prm{2}(4));

x = mg;

q.checkbox_TDPimg = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','image(*.png)', ...
    'Position',[x y w_txt2 h_ed], ...
    'Callback',{@checkbox_expTDPopt_TDPimg_Callback, h_fig}, 'Value',prm{2}(2));

x = mg+w_txt2;
y = y+h_ed+mg;

q.popupmenu_TDPascii = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y w_pop h_ed], ...
    'String',str_tdp, 'Callback',{@popupmenu_expTDPopt_TDPascii_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',prm{2}(3));

x = mg;

q.checkbox_TDPascii = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','ASCII', ...
    'Position',[x y w_txt2 h_ed], ...
    'Callback',{@checkbox_expTDPopt_TDPascii_Callback, h_fig}, 'Value',prm{2}(1));


%% Store uicontrol
h.expTDPopt = q;
guidata(q.figure_expTDPopt,prm);
guidata(h_fig, h);

ud_expTDPopt(h_fig);

set(q.figure_expTDPopt, 'Visible', 'on');

