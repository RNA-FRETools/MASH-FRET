function h = build_setExpSetTabImport(h,dat2import,nChan,h_fig0)
% h = build_setExpSetTabImport(h,dat2import,nChan,h_fig0)
%
% Builds first tabbed panel "Import" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% dat2import: data to import from file ('video' or 'trajectories')
% nChan: number of channels
% h_fig0: handle to main figure

% defaults
blue = [0,0,1];
str0a = 'a multi-channel video file';
str0b = 'single-channel video files';
if strcmp(dat2import,'video')
    str0c = 'Select:';
else
    str0c = '(optional) Select:';
end
str1 = 'Select trajectory files:';
str2 = '...';
str3 = 'Import options';
str4 = '(optional) Select a single molecule coordinates file:';
str5 = '(optional) Select gamma factor files:';
str6 = '(optional) Select beta factor files:';
str7 = ['Next ',char(9658)];

% parents
h_fig = h.figure;
h_tab = h.tab_imp;

% dimensions
postab = h_tab.Position;
wrb0a = getUItextWidth(str0a,h.fun,h.fsz,'normal',h.tbl)+h.wbox;
wtxt0b = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl);
wtxt0c = getUItextWidth(str0c,h.fun,h.fsz,'normal',h.tbl);
wbut0 = getUItextWidth(str2,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wbut1 = getUItextWidth(str3,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wbut2 = getUItextWidth(str7,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wrb0b = postab(3)-2*h.mg-wtxt0c-h.mg-wrb0a-h.mg/2;
wtxt0a = postab(3)-2*h.mg;
wedit0 = postab(3)-2*h.mg-h.mg/2-wbut0;
wlst = postab(3)-2*h.mg;
hlst = postab(4)-h.mgtab-h.hedit-h.mg/2-h.mg-h.hedit-2*h.htxt-...
    3*(h.mg/2+h.hedit+h.mg)-h.hedit-h.mg;
wtxt1 = (postab(3)-4*h.mg)/2;
wedit1 = wtxt1-h.mg/2-wbut0;
wedit2 =  postab(3)-h.mg-h.mg/2-wbut1-h.mg/2-wbut0-h.mg;

y = postab(4)-h.mgtab;

if strcmp(dat2import,'trajectories')
    
    x = h.mg;
    y = y-h.hedit+(h.hedit-h.htxt)/2;

    h.text_impTrajFiles = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str1,...
        'horizontalalignment','left','position',[x,y,wtxt0b,h.htxt]);
    
    x = x+wtxt0b+h.mg/2;
    y = y-(h.hedit-h.htxt)/2;

    h.push_impTrajFiles = uicontrol('parent',h_tab,'style','pushbutton',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,...
        'position',[x,y,wbut0,h.hedit],'callback',...
        {@push_setExpSet_impTrajFiles,h_fig,h_fig0});
    
    x = h.mg;
    y = y-h.mg/2-hlst;
    
    h.list_impTrajFiles = uicontrol('parent',h_tab,'style','listbox',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',...
        blue,'horizontalalignment','right','position',[x,y,wlst,hlst]);
    
    y = y-h.mg;
end

x = h.mg;
y = y-h.hedit+(h.hedit-h.htxt)/2;

h.text_impOptional = uicontrol('parent',h_tab,'style','text','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str0c,...
    'horizontalalignment','left','position',[x,y,wtxt0c,h.htxt]);

x = x+wtxt0c+h.mg;
y = y-(h.hedit-h.htxt)/2;

h.radio_impFileMulti = uicontrol('parent',h_tab,'style','radiobutton',...
    'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str0a,...
    'position',[x,y,wrb0a,h.hedit],'value',1,'callback',...
    {@radio_setExpSet_impFile,h_fig});

x = x+wrb0a+h.mg/2;

h.radio_impFileSingle = uicontrol('parent',h_tab,'style','radiobutton',...
    'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str0b,...
    'position',[x,y,wrb0b,h.hedit],'value',0,'callback',...
    {@radio_setExpSet_impFile,h_fig});

x = h.mg;
y = y-h.mg/2-h.hedit;

h.edit_impFileMulti = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',blue,...
    'horizontalalignment','right','position',[x,y,wedit0,h.hedit],...
    'callback',{@edit_setExpSet_impFile,h_fig});

x = x+wedit0+h.mg/2;

h.push_impFileMulti = uicontrol('parent',h_tab,'style','pushbutton',...
    'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,...
    'position',[x,y,wbut0,h.hedit],'callback',...
    {@push_setExpSet_impFile,h_fig,h_fig0});

h = setExpSet_buildVideoArea(h,nChan,h_fig0);

if strcmp(dat2import,'trajectories')
%     h.push_impOpt = uicontrol('parent',h_tab,'style','pushbutton','units',...
%         h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,'position',...
%         [x,y,wbut1,h.hedit],'callback',...
%         {@push_setExpSet_impOpt,h_fig,h_fig0});
    x = h.mg;
    y = y-h.mg-h.htxt;

    h.text_impCoordFile = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str4,...
        'horizontalalignment','left','position',[x,y,wtxt0a,h.htxt]);

    y = y-h.mg/2-h.hedit;

    h.edit_impCoordFile = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',blue,...
        'horizontalalignment','right','position',[x,y,wedit2,h.hedit],...
        'callback',{@edit_setExpSet_impFile,h_fig});

    x = x+wedit2+h.mg/2;

    h.push_impCoordFile = uicontrol('parent',h_tab,'style','pushbutton',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,...
        'position',[x,y,wbut0,h.hedit],'callback',...
        {@push_setExpSet_impCoordFile,h_fig,h_fig0});

    x = x+wbut0+h.mg/2;

    h.push_impCoordOpt = uicontrol('parent',h_tab,'style','pushbutton',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str3,...
        'position',[x,y,wbut1,h.hedit],'callback',...
        {@push_setExpSet_impCoordOpt,h_fig,h_fig0});
    
    x = h.mg;
    y = y-h.mg-h.htxt;

    h.text_impGammaFile = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str5,...
        'horizontalalignment','left','position',[x,y,wtxt1,h.htxt]);
    
    x = x+wtxt1+2*h.mg;

    h.text_impBetaFile = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str6,...
        'horizontalalignment','left','position',[x,y,wtxt1,h.htxt]);
    
    x = h.mg;
    y = y-h.mg/2-h.hedit;

    h.edit_impGammaFile = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',blue,...
        'horizontalalignment','right','position',[x,y,wedit1,h.hedit],...
        'callback',{@edit_setExpSet_impFile,h_fig});

    x = x+wedit1+h.mg/2;

    h.push_impGammaFile = uicontrol('parent',h_tab,'style','pushbutton',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,...
        'position',[x,y,wbut0,h.hedit],'callback',...
        {@push_setExpSet_impGammaFile,h_fig,h_fig0});
    
    x = x+wbut0+2*h.mg;

    h.edit_impBetaFile = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',blue,...
        'horizontalalignment','right','position',[x,y,wedit1,h.hedit],...
        'callback',{@edit_setExpSet_impFile,h_fig});

    x = x+wedit1+h.mg/2;

    h.push_impBetaFile = uicontrol('parent',h_tab,'style','pushbutton',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,...
        'position',[x,y,wbut0,h.hedit],'callback',...
        {@push_setExpSet_impBetaFile,h_fig,h_fig0});
end

y = h.mg;
x = postab(3)-h.mg-wbut2;

h.push_nextImp = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str7,'position',...
    [x,y,wbut2,h.hedit],'callback',{@push_setExpSet_next,h_fig,1});
