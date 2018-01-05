function expTDPopt(h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return;
end

proj = p.curr_proj;
p_proj = p.proj{proj};
exc = p_proj.excitations;
labels = p_proj.labels;
FRET = p_proj.FRET;
S = p_proj.S;
nFRET = size(FRET);
nS = size(S);
isMov = p_proj.is_movie;
isCoord = p_proj.is_coord;
isSubIm = isMov&isCoord;
isFRET = nFRET>0;
isS = nS>0;
isBot = (nFRET+nS)>0;

prm = p_proj.exp;
prm_default = getExpTDPprm(p);
prm = adjustVal(prm, prm_default);

if ~isFRET
    prm{1}{2}(2,1) = 0; % no FRET histogram file
end
if ~isS
    prm{1}{2}(3,1) = 0; % no S histogram file
end
if ~isBot
    prm{1}{4}(2) = 0; % no bottom axes in figure
end
if ~isSubIm
    prm{1}{3}(3) = 0; % no sub-images in figure
end

if isfield(h, 'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') ...
        && ishandle(h.expTDPopt.figure_expTDPopt)
    return;
end

%% build data type list

str_img = {'original', 'Gaussian convoluted', 'all'};

str_tdp = {'matrix(*.tdp)', 'gauss. convoluted matrix(*.tdp)', ...
    'coordinates (x,y,occurrence)(*.txt)', 'all(*.tdp, *.txt)'};

str_top = getStrPop('plot_topChan',{labels 1 p.proj{proj}.colours{1}});

str_exc = getStrPop('plot_exc',exc);

str_bot = getStrPop('plot_botChan',{FRET S exc p.proj{proj}.colours ...
    labels});

str_fmt = {'Portable document format(*.pdf)', ...
    'Portable network graphics(*.png)', ...
    'Joint photographic expert group(*.jpeg)'};

w_pan = 210;
mg = 10;
eps = 1;
w_full = w_pan-2*mg;
w_ed = 40; w_ed_sml = 35; h_ed = 20;
w_txt1 = 80; w_txt2 = 85; w_txt3 = 110; h_txt = 14;
w_pop = 105;
w_but = 50;

mg_sml = mg/2;
mg_big = 2*mg;
mg_ttl = mg_sml + mg;

h_dat = mg_ttl + 2*h_txt + 14*h_ed + 6*mg + 8*mg_sml;
h_TDP = mg_ttl + 4*mg + h_txt + 2*h_ed;
h_kin = mg_ttl + 4*mg + 3*h_ed;

wFig = 2*w_pan + 3*mg;
hFig = max([(2*mg + h_dat) (4*mg + h_TDP + h_kin + h_ed)]);
pos_0 = get(0, 'ScreenSize');
xFig = (pos_0(3)-wFig)/2;
yFig = (pos_0(4)-hFig)/2;

bgClr = get(h_fig, 'Color');

q.figure_expTDPopt = figure('Name','Export options', 'MenuBar','none', ...
    'NumberTitle','off', 'Visible','off','WindowStyle','modal', ...
    'CloseRequestFcn',{@figure_expTDPopt_CloseRequestFcn, h_fig}, ...
    'Units','pixels', 'Position',[xFig yFig wFig hFig], 'Color', bgClr);


%% Pushbuttons

x = wFig-mg-w_but;
y = hFig-h_TDP-h_kin-h_ed-3*mg;

q.pushbutton_next = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Next >>', ...
    'Position',[x y w_but h_ed], ...
    'Callback',{@pushbutton_next_Callback, h_fig});

x = x-mg-w_but;

q.pushbutton_cancel = uicontrol('Style','pushbutton', 'Units','pixels', ...
    'Parent',q.figure_expTDPopt, 'String','Cancel', ...
    'Position',[x y w_but h_ed], ...
    'Callback',{@pushbutton_cancel_Callback, h_fig});

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
    'Callback',{@checkbox_kinBOBA_Callback, h_fig}, 'Value',prm{3}(3));

y = y+h_ed+mg;

q.checkbox_kinCurves = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y w_full h_ed], ...
    'String','fitting curves & parameters(*.fit)', ...
    'Callback',{@checkbox_kinCurves_Callback, h_fig}, 'Value',prm{3}(2));

y = y+h_ed+mg;

q.checkbox_kinDthist = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_kin, 'Position',[x y w_full h_ed], ...
    'String','dwell-time histograms(*.hdt)', ...
    'Callback',{@checkbox_kinDthist_Callback, h_fig}, 'Value',prm{3}(1));


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
    'Callback',{@checkbox_TDPclust_Callback, h_fig}, 'Value',prm{2}(5));

x = mg+w_txt2;
y = y+h_ed+mg;

q.popupmenu_TDPimg = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y w_pop h_ed], ...
    'String',str_img, 'Callback',{@popupmenu_TDPimg_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',prm{2}(4));

x = mg;

q.checkbox_TDPimg = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','image(*.png)', ...
    'Position',[x y w_txt2 h_ed], ...
    'Callback',{@checkbox_TDPimg_Callback, h_fig}, 'Value',prm{2}(2));

x = mg+w_txt2;
y = y+h_ed+mg;

q.popupmenu_TDPascii = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'Position',[x y w_pop h_ed], ...
    'String',str_tdp, 'Callback',{@popupmenu_TDPascii_Callback, h_fig}, ...
    'BackgroundColor', [1 1 1], 'Value',prm{2}(3));

x = mg;

q.checkbox_TDPascii = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_TDP, 'String','ASCII', ...
    'Position',[x y w_txt2 h_ed], ...
    'Callback',{@checkbox_TDPascii_Callback, h_fig}, 'Value',prm{2}(1));


%% Data adjusted after clustering

x = mg;
y = hFig-h_dat-mg;

q.uipanel_dat = uipanel('Parent',q.figure_expTDPopt, 'Units','pixels', ...
    'Title','Data adjusted after clustering', 'BackgroundColor',bgClr, ...
    'Position',[x y w_pan h_dat]);

x = w_pan-mg-w_but;
y = mg;

q.pushbutton_datFigPrev = uicontrol('Style','pushbutton', ...
    'Units','pixels', 'Parent',q.uipanel_dat, 'String','Preview', ...
    'Position',[x y w_but h_ed], ...
    'Callback',{@pushbutton_datFigPrev_Callback, h_fig});

x = mg_big;
y = y+h_ed+mg_sml;

q.checkbox_datFigtr = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','include discretised traces', ...
    'Position',[x y w_full-mg h_ed], ...
    'Callback',{@checkbox_datFigtr_Callback, h_fig}, 'Value',prm{1}{4}(7));

y = y+h_ed+mg_sml;

q.checkbox_datFigHist = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','histogram axes', ...
    'Position',[x y w_full-mg h_ed], 'Value',prm{1}{4}(6), ...
    'Callback',{@checkbox_datFigHist_Callback, h_fig});

x = mg+w_txt2;
y = y+h_ed+mg_sml;

q.popupmenu_datFigBot = uicontrol('Style','popupmenu', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'Position',[x y w_pop h_ed], ...
    'String',str_bot, 'BackgroundColor', [1 1 1], 'Value',prm{1}{4}(5), ...
    'Callback',{@popupmenu_datFigBot_Callback, h_fig});

x = mg;

q.checkbox_datFigBot = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','bottom axes:', ...
    'Position',[x y w_txt2 h_ed], 'Value',prm{1}{4}(2), ...
    'Callback',{@checkbox_datFigHist_Callback, h_fig});

x = mg+w_txt2+mg_sml+w_but;
y = y+h_ed+mg_sml;

q.popupmenu_datFigTopChan = uicontrol('Style','popupmenu', ...
    'Units','pixels', 'Parent',q.uipanel_dat, 'String',str_top, ...
    'Position',[x y w_but h_ed], 'BackgroundColor', [1 1 1],...
    'Callback',{@popupmenu_datFigTopChan_Callback, h_fig}, ...
    'Value',prm{1}{4}(4));

x = x-mg_sml-w_but;

q.popupmenu_datFigTopExc = uicontrol('Style','popupmenu', ...
    'Units','pixels', 'Parent',q.uipanel_dat, 'String',str_exc, ...
    'Position',[x y w_but h_ed], 'BackgroundColor', [1 1 1],...
    'Callback',{@popupmenu_datFigTopExc_Callback, h_fig}, ...
    'Value',prm{1}{4}(3));

x = x-w_txt2;

q.checkbox_datFigTop = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','top axes:', ...
    'Position',[x y w_txt2 h_ed], 'Value',prm{1}{4}(1), ...
    'Callback',{@checkbox_datFigTop_Callback, h_fig});

x = mg;
y = y+h_ed+mg_sml;

q.checkbox_datFigSubimg = uicontrol('Style','checkbox', ...
    'Units','pixels', 'Parent',q.uipanel_dat, 'Value',prm{1}{3}(3), ...
    'String','molecule sub-images:', 'Position',[x y w_full h_ed], ...
    'Callback',{@checkbox_datFigSubimg_Callback, h_fig});

x = mg+w_txt3;
y = y+h_ed+mg_sml;

q.edit_datFigMol = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String',num2str(prm{1}{3}(2)) , ...
    'Position',[x y w_ed h_ed], 'BackgroundColor', [1 1 1], ...
    'Callback',{@edit_datFigMol_Callback, h_fig});

x = mg;

q.text_datFigMol = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','molecules per figure:', ...
    'Position',[x y w_txt3 h_txt], 'HorizontalAlignment','left');

x = mg+w_txt2;
y = y+h_ed+mg_sml;

q.popupmenu_datFigFmt = uicontrol('Style','popupmenu', ...
    'Units','pixels', 'Parent',q.uipanel_dat, 'String',str_fmt, ...
    'Position',[x y w_pop h_ed], 'BackgroundColor', [1 1 1],...
    'Callback',{@popupmenu_datFigFmt_Callback, h_fig}, ...
    'Value',prm{1}{3}(1));

x = mg;

q.text_datFigFmt = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','export format:', ...
    'Position',[x y w_txt2 h_txt], 'HorizontalAlignment','left');

y = y+h_ed+mg_sml;

q.checkbox_datFig = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','figures', ...
    'Position',[x y w_full h_ed], 'Value',prm{1}{1}(4), ...
    'Callback',{@checkbox_datFig_Callback, h_fig});

x = mg+w_txt1+2*w_ed_sml+2*eps;
y = y+h_ed+mg;

q.edit_datMaxS = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(3,3)), ...
    'Callback',{@edit_datMaxS_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datBinS = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(3,2)), ...
    'Callback',{@edit_datBinS_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datMinS = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(3,1)), ...
    'Callback',{@edit_datMinS_Callback, h_fig});

x = mg;

q.text_datS = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','stoichiometries:', ...
    'Position',[x y w_txt1 h_txt], 'HorizontalAlignment','left');

x = mg+w_txt1+2*w_ed_sml+2*eps;
y = y+h_ed+eps;

q.edit_datMaxFRET = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(2,3)), ...
    'Callback',{@edit_datMaxFRET_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datBinFRET = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(2,2)), ...
    'Callback',{@edit_datBinFRET_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datMinFRET = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(2,1)), ...
    'Callback',{@edit_datMinFRET_Callback, h_fig});

x = mg;

q.text_datFRET = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', q.uipanel_dat, 'String', 'FRET:', ...
    'Position', [x y w_txt1 h_txt], 'HorizontalAlignment', 'left');

x = mg+w_txt1+2*w_ed_sml+2*eps;
y = y+h_ed+eps;

q.edit_datMaxI = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(1,3)), ...
    'Callback',{@edit_datMaxI_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datBinI = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(1,2)), ...
    'Callback',{@edit_datBinI_Callback, h_fig});

x = x-w_ed_sml-eps;

q.edit_datMinI = uicontrol('Style','edit', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'BackgroundColor',[1 1 1], ...
    'Position',[x y w_ed_sml h_ed], 'String',num2str(prm{1}{2}(1,1)), ...
    'Callback',{@edit_datMinI_Callback, h_fig});

x = mg;

q.text_datI = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','intensities:', ...
    'Position',[x y w_txt1 h_txt], 'HorizontalAlignment','left');

x = mg+w_txt1+2*w_ed_sml+2*eps;
y = y+h_ed;

q.text_datMax = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','max', ...
    'HorizontalAlignment','center', 'Position',[x y w_ed_sml h_txt]);

x = x-w_ed_sml-eps;

q.text_datBin = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','bin', ...
    'HorizontalAlignment','center', 'Position',[x y w_ed_sml h_txt]);

x = x-w_ed_sml-eps;

q.text_datMin = uicontrol('Style','text', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','min', ...
    'HorizontalAlignment','center', 'Position',[x y w_ed_sml h_txt]);

x = mg;
y = y+h_txt+mg_sml;

q.checkbox_datDscrHist = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'Position',[x y w_full h_ed], ...
    'String','discretised histogram files(*.hd)', 'Value',prm{1}{1}(3), ...
    'Callback',{@checkbox_datDscrHist_Callback, h_fig});

y = y+h_ed+mg;

q.checkbox_datDt = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','dwell-time files(*.dt)', ...
    'Position',[x y w_full h_ed], ...
    'Callback',{@checkbox_datDt_Callback, h_fig}, 'Value',prm{1}{1}(2));

y = y+h_ed+mg;

q.checkbox_datTr = uicontrol('Style','checkbox', 'Units','pixels', ...
    'Parent',q.uipanel_dat, 'String','ASCII trace files(*.txt)', ...
    'Position',[x y w_full h_ed], ...
    'Callback',{@checkbox_datTr_Callback, h_fig}, 'Value',prm{1}{1}(1));


%% Store uicontrol
h.expTDPopt = q;
guidata(q.figure_expTDPopt,prm);
guidata(h_fig, h);

ud_expTDPopt(h_fig);

set(q.figure_expTDPopt, 'Visible', 'on');


function figure_expTDPopt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'expTDPopt')
    q = guidata(h.expTDPopt.figure_expTDPopt);
    proj = h.param.TDP.curr_proj;
    h.param.TDP.proj{proj}.exp = q;
    h = rmfield(h, 'expTDPopt');
    guidata(h_fig, h);
end
delete(obj);


function pushbutton_cancel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
close(h.expTDPopt.figure_expTDPopt);


function pushbutton_next_Callback(obj, evd, h_fig)
h = guidata(h_fig);
h_fig_opt = h.expTDPopt.figure_expTDPopt;
proj = h.param.TDP.curr_proj;
q = guidata(h_fig_opt);
h.param.TDP.proj{proj}.exp = q;
guidata(h_fig, h);

close(h_fig_opt);

saveTDP(h_fig);


function checkbox_kinBOBA_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{3}(3) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_kinCurves_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{3}(2) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);

function checkbox_kinDthist_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{3}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_TDPclust_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(5) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_TDPimg_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(4) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_TDPimg_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(2) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_TDPascii_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(3) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_TDPascii_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function pushbutton_datFigPrev_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
incl = p.proj{proj}.coord_incl;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
[o,m_valid,o] = find(incl);

prm = guidata(h.expTDPopt.figure_expTDPopt);

molPerFig = prm{1}{3}(2);
min_end = min([molPerFig numel(m_valid)]);
p_fig.isSubimg = prm{1}{3}(3);
p_fig.isHist = prm{1}{4}(6);
p_fig.isDiscr = prm{1}{4}(7);
p_fig.isTop = prm{1}{4}(1);
p_fig.topExc = prm{1}{4}(3);
p_fig.topChan = prm{1}{4}(4);
if nFRET > 0 || nS > 0
    p_fig.isBot = prm{1}{4}(2);
    p_fig.botChan = prm{1}{4}(5);
else
    p_fig.isBot = 0;
    p_fig.botChan = 0;
end

p2 = p;
p2.proj{proj}.prm = p.proj{proj}.prmTT;
p2.proj{proj}.intensities_DTA = p2.proj{proj}.adj.intensities_DTA;
p2.proj{proj}.FRET_DTA = p2.proj{proj}.adj.FRET_DTA;
p2.proj{proj}.S_DTA = p2.proj{proj}.adj.S_DTA;

h_fig_mol = [];
m_i = 0;
for m = m_valid(1:min_end)
    m_i = m_i + 1;
    h_fig_mol = buildFig(p2, m, m_i, m_i, molPerFig, p_fig, h_fig_mol);
end
set(h_fig_mol, 'Visible', 'on');


function checkbox_datFigtr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(7) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datFigHist_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(6) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_datFigBot_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(5) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datFigBot_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(2) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_datFigTopChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(4) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_datFigTopExc_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(3) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datFigTop_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{4}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datFigSubimg_Callback(obj, evd, h_fig)
h = guidata(h_fig);
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Molecule number must be positive', 'error', h_fig);
    return;
end
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{3}(2) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datFigSubimg_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{3}(3) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);

function edit_datFigMol_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Number of molecule per page must be a positive ' ...
        'integer'], 'error', h_fig);
    return;
end
prm{1}{3}(2) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function popupmenu_datFigFmt_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{3}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datFig_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{1}(4) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMaxS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
minVal = prm{1}{2}(3,1);
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Max. stoichiometry must be > min. stoichiometry (' ...
        num2str(minVal) ')'], 'error', h_fig);
    return;
end
prm{1}{2}(3,3) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datBinS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Stoichiometry binning must be positive.', 'error', h_fig);
    return;
end
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{2}(3,2) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMinS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
maxVal = prm{1}{2}(3,3);
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Min. stoichiometry must be > max. stoichiometry (' ...
        num2str(maxVal) ')'], 'error', h_fig);
    return;
end
prm{1}{2}(3,1) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMaxFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
minVal = prm{1}{2}(2,1);
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Max. FRET must be > min. FRET (' num2str(minVal) ')'], ...
        'error', h_fig);
    return;
end
prm{1}{2}(2,3) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datBinFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('FRET binning must be positive.', 'error', h_fig);
    return;
end
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{2}(2,2) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMinFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
maxVal = prm{1}{2}(2,3);
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Min. FRET must be > max. FRET (' ...
        num2str(maxVal) ')'], 'error', h_fig);
    return;
end
prm{1}{2}(2,1) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMaxI_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
minVal = prm{1}{2}(1,1);
if ~(numel(val)==1 && ~isnan(val) && val > minVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Max. intensity must be > min. intensity (' ...
        num2str(minVal) ')'], 'error', h_fig);
    return;
end
prm{1}{2}(1,3) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datBinI_Callback(obj, evd, h_fig)
h = guidata(h_fig);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('intensity binning must be positive.', 'error', h_fig);
    return;
end
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{2}(1,2) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function edit_datMinI_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
maxVal = prm{1}{2}(1,3);
if ~(numel(val)==1 && ~isnan(val) && val < maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(['Min. intensity must be > max. intensity (' ...
        num2str(maxVal) ')'], 'error', h_fig);
    return;
end
prm{1}{2}(1,1) = val;
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datDscrHist_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{1}(3) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datDt_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{1}(2) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


function checkbox_datTr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{1}{1}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);



function def = getExpTDPprm(p)

def = cell(1,3);
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isMov = p.proj{proj}.is_movie;
isCoord = p.proj{proj}.is_coord;

%% Data corrected after clustering

% save ASCII trace files, save dwell-time files, discretised histogram 
% files, figures.
def{1}{1} = [1 1 1 1];

% min. value, binning, max. value of (intensity;FRET;S) discretised hist.
def{1}{2} = [-200 5 1000
    -0.2 0.01 1.2
    -0.2 0.01 1.2];

% data format to export, nb. of mol. per figure, include mol. subimage
def{1}{3} = [1 6 (isMov & isCoord)];

% top axes, bottom axes, excitation, channel top, bottom channel, histogram
% axes, discretised traces
def{1}{4} = [1 double((nFRET+nS)>0) nExc+double(nExc>1) ...
    nChan+1+double(nChan>1) nFRET+nS+1+double((nFRET+nS)>1) 1 1];


%% TDP

% export TDP ASCII, export TDP image, ASCII type, image type, clusters
def{2} = [1 1 4 3 1];


%% Kinetic analysis

% data type, dwell-time histograms, fitting curves + parameters, BOBA FRET
% results.
def{3} = [1 1 1];


function ud_expTDPopt(h_fig)
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
isMov = p.proj{proj}.is_movie;
isCoord = p.proj{proj}.is_coord;
isFRET = size(p.proj{proj}.FRET,1)>0;
isS = size(p.proj{proj}.S,1)>0;
isBot = (isFRET|isS);

q = h.expTDPopt;
p_exp = guidata(q.figure_expTDPopt);

% remove function: bugged
p_exp{1}{1}(1) = 0;
p_exp{1}{1}(2) = 0;
p_exp{1}{1}(3) = 0;
p_exp{1}{1}(4) = 0;

datTr = p_exp{1}{1}(1);
datDt = p_exp{1}{1}(2);
datDiscrHist = p_exp{1}{1}(3);
datFig = p_exp{1}{1}(4);

limI = [p_exp{1}{2}(1,1) p_exp{1}{2}(1,3)];
binI = p_exp{1}{2}(1,2);
limE = [p_exp{1}{2}(2,1) p_exp{1}{2}(2,3)];
binE = p_exp{1}{2}(2,2);
limS = [p_exp{1}{2}(3,1) p_exp{1}{2}(3,3)];
binS = p_exp{1}{2}(3,2);

datFig_fmt = p_exp{1}{3}(1);
datFig_mol = p_exp{1}{3}(2);

datTop = p_exp{1}{4}(1);
datBot = p_exp{1}{4}(2);
datTopExc = p_exp{1}{4}(3);
datTopChan = p_exp{1}{4}(4);
datBotChan = p_exp{1}{4}(5);
datHist = p_exp{1}{4}(6);
datDiscr = p_exp{1}{4}(7);

TDPascii = p_exp{2}(1);
TDPimg = p_exp{2}(2);
TDPascii_fmt = p_exp{2}(3);
TDPimg_fmt = p_exp{2}(4);
TDPclust = p_exp{2}(5);

kinDtHist = p_exp{3}(1);
kinFit = p_exp{3}(2);
kinBoba = p_exp{3}(3);

set([q.checkbox_datTr q.checkbox_datDt q.checkbox_datDscrHist ...
    q.checkbox_datFig ], 'Enable', 'on');

set([q.checkbox_TDPascii q.checkbox_TDPimg ...
    q.checkbox_kinDthist q.checkbox_kinCurves q.checkbox_kinBOBA ...
    q.pushbutton_cancel q.pushbutton_next], 'Enable', 'on');

enbl_FRET = 'off'; enbl_S = 'off';
if isFRET
    enbl_FRET = 'on';
end
if isS
    enbl_S = 'on';
end

set([q.edit_datMinI q.edit_datBinI q.edit_datMaxI q.edit_datMinFRET ...
    q.edit_datBinFRET q.edit_datMaxFRET q.edit_datMinS q.edit_datBinS ...
    q.edit_datMaxS q.edit_datFigMol], 'BackgroundColor', [1 1 1]);

set(q.checkbox_datTr, 'Value', datTr);
set(q.checkbox_datDt, 'Value', datDt);
set(q.checkbox_datDscrHist, 'Value', datDiscrHist);
set(q.checkbox_datFig, 'Value', datFig);

set(q.checkbox_TDPascii, 'Value', TDPascii);
set(q.checkbox_TDPimg, 'Value', TDPimg);
set(q.checkbox_TDPclust, 'Value', TDPclust);
set(q.checkbox_kinDthist, 'Value', kinDtHist);
set(q.checkbox_kinCurves, 'Value', kinFit);
set(q.checkbox_kinBOBA, 'Value', kinBoba);

if datDiscrHist
    set([q.text_datMin q.text_datBin q.text_datMax q.text_datI ...
        q.edit_datMinI q.edit_datBinI q.edit_datMaxI], 'Enable', 'on');
    set([q.text_datFRET q.edit_datMinFRET q.edit_datBinFRET ...
        q.edit_datMaxFRET], 'Enable', enbl_FRET);
    set([q.text_datS q.edit_datMinS q.edit_datBinS q.edit_datMaxS], ...
        'Enable', enbl_S);
    set(q.edit_datMinI, 'String', num2str(limI(1)));
    set(q.edit_datBinI, 'String', num2str(binI));
    set(q.edit_datMaxI, 'String', num2str(limI(2)));
    set(q.edit_datMinFRET, 'String', num2str(limE(1)));
    set(q.edit_datBinFRET, 'String', num2str(binE));
    set(q.edit_datMaxFRET, 'String', num2str(limE(2)));
    set(q.edit_datMinS, 'String', num2str(limS(1)));
    set(q.edit_datBinS, 'String', num2str(binS));
    set(q.edit_datMaxS, 'String', num2str(limS(2)));
else
    set([q.text_datMin q.text_datBin q.text_datMax q.text_datI ...
        q.edit_datMinI q.edit_datBinI q.edit_datMaxI q.text_datFRET ...
        q.edit_datMinFRET q.edit_datBinFRET q.edit_datMaxFRET ...
        q.text_datS q.edit_datMinS q.edit_datBinS q.edit_datMaxS], ...
        'Enable', 'off');
    set([q.edit_datMinI q.edit_datBinI q.edit_datMaxI q.edit_datMinFRET ...
        q.edit_datBinFRET q.edit_datMaxFRET q.edit_datMinS ...
        q.edit_datBinS q.edit_datMaxS], 'String', '');
end

if datFig
    datSubimg = p_exp{1}{3}(3);
    if isMov && isCoord
        enbl_sbim = 'on';
    else
        enbl_sbim = 'off';
    end
    if isBot
        enbl_bot = 'on';
    end
    set([q.text_datFigFmt q.popupmenu_datFigFmt q.text_datFigMol ...
        q.edit_datFigMol q.checkbox_datFigSubimg q.checkbox_datFigTop ...
        q.checkbox_datFigBot q.checkbox_datFigHist q.checkbox_datFigtr ...
        q.pushbutton_datFigPrev], 'Enable', 'on');
    set(q.popupmenu_datFigFmt, 'Value', datFig_fmt);
    set(q.edit_datFigMol, 'String', num2str(datFig_mol));
    set(q.checkbox_datFigSubimg, 'Value', datSubimg, 'Enable', enbl_sbim);
    set(q.checkbox_datFigTop, 'Value', datTop);
    set(q.checkbox_datFigBot, 'Value', datBot, 'Enable', enbl_bot);
    set(q.checkbox_datFigHist, 'Value', datHist);
    set(q.checkbox_datFigtr, 'Value', datDiscr);
    if datTop
        set(q.popupmenu_datFigTopExc, 'Enable','on', 'Value',datTopExc);
        set(q.popupmenu_datFigTopChan, 'Enable','on', 'Value',datTopChan);
    else
        set([q.popupmenu_datFigTopExc q.popupmenu_datFigTopChan], ...
            'Enable', 'off');
    end
    if datBot
        set(q.popupmenu_datFigBot, 'Enable','on', 'Value',datBotChan);
    else
        set(q.popupmenu_datFigBot, 'Enable','on');
    end

else
    set([q.text_datFigFmt q.popupmenu_datFigFmt q.text_datFigMol ...
        q.edit_datFigMol q.checkbox_datFigSubimg q.checkbox_datFigTop ...
        q.popupmenu_datFigTopExc q.popupmenu_datFigTopChan ...
        q.checkbox_datFigBot q.popupmenu_datFigBot ...
        q.checkbox_datFigHist q.checkbox_datFigtr ...
        q.pushbutton_datFigPrev], 'Enable','off');
end

if TDPascii
    set(q.popupmenu_TDPascii, 'Enable','on', 'Value',TDPascii_fmt);
else
    set(q.popupmenu_TDPascii, 'Enable','off');
end

if TDPimg
    set(q.popupmenu_TDPimg, 'Enable','on', 'Value',TDPimg_fmt);
else
    set(q.popupmenu_TDPimg, 'Enable','off');
end





