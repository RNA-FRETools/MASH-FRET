function expTDPopt(h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
p_proj = p.proj{proj};
opt = p_proj.exp;

prm_default = getExpTDPprm();
opt = adjustVal(opt, prm_default);

if isfield(h, 'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') ...
        && ishandle(h.expTDPopt.figure_expTDPopt)
    return
end

%% build data type list

str_img = {'original', 'Gaussian convoluted', 'all'};

str_tdp = {'matrix(*.tdp)', 'gauss. convoluted matrix(*.tdp)', ...
    'coordinates (x,y,occurrence)(*.txt)', 'all(*.tdp, *.txt)'};

wpan = 210;
mg = 10;
wfull = wpan-2*mg;
hed = 20;
hcb = 20;
wtxt2 = 85; h_txt = 14;
wpop = 105;
wbut = 50;

mgsml = mg/2;
mgttl = mgsml + mg;

hTDP = mgttl + 4*mg + h_txt + 2*hed;
hkin = mgttl + 5*mg + 4*hed;
hmdl = mgttl + 3*hcb + 3*mg;

wFig = 2*wpan + 3*mg;
hFig = 4*mg + hTDP + hkin + hed;
pos_0 = get(0, 'ScreenSize');
xFig = (pos_0(3)-wFig)/2;
yFig = (pos_0(4)-hFig)/2;

bgClr = get(h_fig, 'Color');

q.figure_expTDPopt = figure('Name','Export options', 'MenuBar','none', ...
    'NumberTitle','off', 'Visible','off', ...
    'CloseRequestFcn',{@figure_expTDPopt_CloseRequestFcn, h_fig}, ...
    'Units','pixels', 'Position',[xFig yFig wFig hFig], 'Color', bgClr);


%% Pushbuttons

x = wFig-mg-wbut;
y = hFig-hTDP-hkin-hed-3*mg;

q.pushbutton_next = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Next >>', ...
    'Position',[x y wbut hed], ...
    'Callback',{@pushbutton_expTDPopt_next_Callback, h_fig});

x = x-mg-wbut;

q.pushbutton_cancel = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Cancel', ...
    'Position',[x y wbut hed], ...
    'Callback',{@pushbutton_expTDPopt_cancel_Callback, h_fig});


h = guidata(h_fig);
h.expTDPopt = q;
guidata(h_fig,h);
q.pushbutton_help = setInfoIcons(h.expTDPopt.pushbutton_cancel,...
    h_fig,h.param.movPr.infos_icon_file);


%% Kinetic analysis

x = mg;
y = hFig-hTDP-hkin-2*mg;

q.uipanel_kin = uipanel('Parent',q.figure_expTDPopt, 'Units','pixels', ...
    'Title','Kinetic analysis', 'BackgroundColor',bgClr, ...
    'Position',[x y wpan hkin]);

x = mg;
y = mg;

q.checkbox_figBOBA = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'String','BOBA figures(*.pdf)', ...
    'Position',[x y wfull hed], ...
    'Callback',{@checkbox_expTDPopt_figBOBA_Callback, h_fig}, 'Value',opt{3}(4));

y = y+hed+mg;

q.checkbox_kinBOBA = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'String','BOBA FRET results(*.fit)', ...
    'Position',[x y wfull hed], ...
    'Callback',{@checkbox_expTDPopt_kinBOBA_Callback, h_fig}, 'Value',opt{3}(3));

y = y+hed+mg;

q.checkbox_kinCurves = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y wfull hed], ...
    'String','fitting curves & parameters(*.fit)', ...
    'Callback',{@checkbox_expTDPopt_kinCurves_Callback, h_fig}, 'Value',opt{3}(2));

y = y+hed+mg;

q.checkbox_kinDthist = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y wfull hed], ...
    'String','dwell-time histograms(*.hdt)', ...
    'Callback',{@checkbox_expTDPopt_kinDthist_Callback, h_fig}, 'Value',opt{3}(1));


%% TDP

x = mg;
y = hFig-hTDP-mg;

q.uipanel_TDP = uipanel('Parent',q.figure_expTDPopt, 'Units','pixels', ...
    'Title','TDP', 'BackgroundColor',bgClr, 'Position',[x y wpan hTDP]);

x = mg;
y = mg;

q.checkbox_TDPclust = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','clusters', ...
    'Position',[x y wfull hed], ...
    'Callback',{@checkbox_expTDPopt_TDPclust_Callback, h_fig}, 'Value',opt{2}(5));

x = mg+wtxt2;
y = y+hed+mg;

q.popupmenu_TDPimg = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y wpop hed], ...
    'String',str_img, 'Callback',{@popupmenu_expTDPopt_TDPimg_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',opt{2}(4));

x = mg;

q.checkbox_TDPimg = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','image(*.png)', ...
    'Position',[x y wtxt2 hed], ...
    'Callback',{@checkbox_expTDPopt_TDPimg_Callback, h_fig}, 'Value',opt{2}(2));

x = mg+wtxt2;
y = y+hed+mg;

q.popupmenu_TDPascii = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y wpop hed], ...
    'String',str_tdp, 'Callback',{@popupmenu_expTDPopt_TDPascii_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',opt{2}(3));

x = mg;

q.checkbox_TDPascii = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','ASCII', ...
    'Position',[x y wtxt2 hed], ...
    'Callback',{@checkbox_expTDPopt_TDPascii_Callback, h_fig}, 'Value',opt{2}(1));

%% Kinetic model

x = wFig-mg-wpan;
y = hFig-hTDP-mg;

q.uipanel_mdl = uipanel('Parent',q.figure_expTDPopt,'units','pixels',...
    'title','Kinetic model','backgroundColor',bgClr,'position',...
    [x y wpan hmdl]);

x = x+mg;
y = y-mgttl-hcb;

q.checkbox_mdlSlct = uicontrol('Style','checkbox','units','pixels','parent',...
    q.uipanel_mdl,'string','model selection (*_BIC.txt)','position',...
    [x y wfull hed],'value',opt{4}(1),'callback',...
    {@checkbox_expTDPopt_mdlSlct_Callback,h_fig});

y = y-mg-hcb;

q.checkbox_mdlOpt = uicontrol('Style','checkbox','units','pixels','parent',...
    q.uipanel_mdl,'string','optimized model parameters (*_mdl.txt)',...
    'position',[x y wfull hed],'value',opt{4}(2),'callback',...
    {@checkbox_expTDPopt_mdlOpt_Callback,h_fig});

y = y-mg-hcb;

q.checkbox_mdlSim = uicontrol('Style','checkbox','units','pixels','parent',...
    q.uipanel_mdl,'string','simulated dwell times (*_sim.dt)','position',...
    [x y wfull hed],'callback',{@checkbox_expTDPopt_mdlSim_Callback, h_fig},...
    'value',opt{4}(3));

%% Store uicontrol
h.expTDPopt = q;
guidata(q.figure_expTDPopt,opt);
guidata(h_fig, h);

ud_expTDPopt(h_fig);

set(q.figure_expTDPopt, 'Visible', 'on');

