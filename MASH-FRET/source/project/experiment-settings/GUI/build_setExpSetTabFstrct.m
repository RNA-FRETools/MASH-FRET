function h = build_setExpSetTabFstrct(h,exc)
% h = build_setExpSetTabFstrct(h,exc)
%
% Builds tab "File structure" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% exc: laser wavelengths

% defaults
str0 = 'Header lines:';
str1 = 'Column delimiter:';
str2 = {'blanks (tab,spaces)','tab',',',';','space'};
str3 = 'ALEX data:';
str4 = {'row-wise','column-wise'};
str5 = 'Intensity columns:';
str6 = 'from';
str7 = 'to';
str8 = '(0=end)';
str9 = 'Time column:';
str10 = 'FRET state columns:';
str11 = 'skip';
str12 = ['Next ',char(9658)];
blue = [0,0,1];
pink = [212,0,187]/255;
orange = [1,0.5,0];

% parents
h_fig = h.figure;
h_tab = h.tab_fstrct;

% dimensions
postab = h_tab.Position;
wtxt1 = getUItextWidth(str0,h.fun,h.fsz,'bold',h.tbl);
wtxt2 = getUItextWidth(str1,h.fun,h.fsz,'bold',h.tbl);
wtxt3 = getUItextWidth(str5,h.fun,h.fsz,'bold',h.tbl);
wcb0 = getUItextWidth(str9,h.fun,h.fsz,'bold',h.tbl)+h.wbox;
wtxt4 = getUItextWidth(str3,h.fun,h.fsz,'bold',h.tbl);
wpop1 = getUItextWidth(str4{2},h.fun,h.fsz,'normal',h.tbl)+h.warr;
wtxt5 = getUItextWidth(str6,h.fun,h.fsz,'normal',h.tbl);
wtxt6 = getUItextWidth(str7,h.fun,h.fsz,'normal',h.tbl);
wtxt7 = getUItextWidth(str8,h.fun,h.fsz,'normal',h.tbl);
wtxt8 = getUItextWidth(str11,h.fun,h.fsz,'normal',h.tbl);
wcb1 = getUItextWidth(str10,h.fun,h.fsz,'bold',h.tbl)+h.wbox;
wbut0 = getUItextWidth(str12,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wpop0 = postab(3)-h.mg-wtxt1-h.wedit0-h.mg-wtxt2-h.mg-wtxt4-wpop1-h.mg;
htbl = postab(4)-h.mgtab-h.hpop-h.mg-h.hedit-h.mg-h.hedit-h.mg-h.hedit-...
    2*h.mg-h.hedit-h.mg;
wtbl = postab(3)-2*h.mg;

% font colors
iclr = blue;
tclr = pink;
fretclr = orange;

% GUI
x = h.mg;
y = postab(4)-h.mgtab-h.hpop+(h.hpop-h.htxt)/2;

h.text_hLines = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str0,...
    'horizontalalignment','left','position',[x,y,wtxt1,h.htxt]);

x = x+wtxt1;
y = y-(h.hedit-h.htxt)/2;

h.edit_hLines = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_hLines,h_fig});

x = x+h.wedit0+h.mg;
y = y+(h.hedit-h.htxt)/2;

h.text_delim = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str1,...
    'horizontalalignment','left','position',[x,y,wtxt2,h.htxt]);

x = x+wtxt2;
y = y-(h.hpop-h.htxt)/2;

h.pop_delim = uicontrol('parent',h_tab,'style','popupmenu','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wpop0,h.hpop],...
    'callback',{@pop_setExpSet_delim,h_fig},'string',str2);

x = x+wpop0+h.mg;
y = y+(h.hpop-h.htxt)/2;

h.text_alexDat = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
    str3,'horizontalalignment','left','position',[x,y,wtxt4,h.htxt]);

x = x+wtxt4;
y = y-(h.hpop-h.htxt)/2;

h.pop_alexDat = uicontrol('parent',h_tab,'style','popupmenu','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',...
    [x,y,wpop1,h.hpop],'string',str4,'callback',...
    {@pop_setExpSet_alexDat,h_fig});

x = h.mg;
y = y-h.mg-h.hedit+(h.hedit-h.htxt)/2;

h.text_intDat = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str5,...
    'horizontalalignment','left','position',[x,y,wtxt3,h.htxt],...
    'foregroundcolor',iclr);

x = x+wtxt3;

h.text_intFrom = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str6,'position',...
    [x,y,wtxt5,h.htxt]);

x = x+wtxt5;
y = y-(h.hedit-h.htxt)/2;

h.edit_intFrom = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_intFrom,h_fig},'foregroundcolor',iclr,...
    'fontweight','bold');

y = y+(h.hedit-h.htxt)/2;
x = x+h.wedit0;

h.text_intTo = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str7,'position',...
    [x,y,wtxt6,h.htxt]);

x = x+wtxt6;
y = y-(h.hedit-h.htxt)/2;

h.edit_intTo = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_intTo,h_fig},'foregroundcolor',iclr,...
    'fontweight','bold');

x = x+h.wedit0;
y = y+(h.hedit-h.htxt)/2;

h.text_intZero = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str8,'position',...
    [x,y,wtxt7,h.htxt]);

h = setExpSet_buildIntensityArea(h,exc);

x = h.mg;
y = y-(h.hedit-h.htxt)/2-h.mg-h.hedit;

h.check_timeDat = uicontrol('parent',h_tab,'style','checkbox','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str9,...
    'foregroundcolor',pink,'position',[x,y,wcb0,h.hedit],'callback',...
    {@check_setExpSet_timeDat,h_fig},'foregroundcolor',tclr);

x = x+wcb0;

h.edit_timeCol = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_timeCol,h_fig},'foregroundcolor',...
    tclr,'fontweight','bold');

x = x+h.wedit0;
y = y+(h.hedit-h.htxt)/2;

h.text_timeZero = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str8,'position',...
    [x,y,wtxt7,h.htxt]);

h = setExpSet_buildTimeArea(h,exc);

x = h.mg;
y = y-(h.hedit-h.htxt)/2-h.mg-h.hedit;

h.check_FRETseq = uicontrol('parent',h_tab,'style','checkbox','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str10,...
    'foregroundcolor',blue,'position',[x,y,wcb1,h.hedit],'callback',...
    {@check_setExpSet_FRETseq,h_fig},'foregroundcolor',fretclr);

x = x+wcb1;
y = y+(h.hedit-h.htxt)/2;

h.text_FRETseqFrom = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str6,'position',...
    [x,y,wtxt5,h.htxt]);

x = x+wtxt5;
y = y-(h.hedit-h.htxt)/2;

h.edit_FRETseqCol1 = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_FRETseqCol1,h_fig},'foregroundcolor',...
    fretclr,'fontweight','bold');

x = x+h.wedit0;
y = y+(h.hedit-h.htxt)/2;

h.text_FRETseqTo = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str7,'position',...
    [x,y,wtxt6,h.htxt]);

x = x+wtxt6;
y = y-(h.hedit-h.htxt)/2;

h.edit_FRETseqCol2 = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_FRETseqCol2,h_fig},'foregroundcolor',...
    fretclr,'fontweight','bold');

x = x+h.wedit0;
y = y+(h.hedit-h.htxt)/2;

h.text_FRETseqZero = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str8,'position',...
    [x,y,wtxt7,h.htxt]);

x = x+wtxt7+h.mg;

h.text_FRETseqSkip = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str11,'position',...
    [x,y,wtxt8,h.htxt]);

x = x+wtxt8;
y = y-(h.hedit-h.htxt)/2;

h.edit_FRETseqSkip = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_FRETseqSkip,h_fig},'foregroundcolor',...
    fretclr,'fontweight','bold');

x = h.mg;
y = y-h.mg-htbl;

h.table_fstrct = uitable('parent',h_tab,'units',h.un,'fontunits',h.fun,...
    'fontsize',h.fsz,'position',[x,y,wtbl,htbl],'rowstriping','off');

y = h.mg;
x = postab(3)-h.mg-wbut0;

h.push_nextFstrct = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str12,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_next,h_fig,5});
