function h = build_setExpSetTabFstrct(h,dat2import,exc)
% h = build_setExpSetTabFstrct(h,dat2import,exc)
%
% Builds tab "File structure" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% exc: laser wavelengths

% defaults
str0 = 'header lines';
str1 = 'column delimiter';
str2 = {'blanks (tab,spaces)','tab',',',';','space'};
str3 = 'sample';
str4 = {'one molecule','multiple molecules'};
str5 = 'ALEX data';
str6 = {'row-wise','column-wise'};
str7 = 'Time column:';
str8 = '(0=end)';
istraj = strcmp(dat2import,'trajectories');
if istraj
    str9 = 'Intensity columns:';
else
    str9a = 'Histogram bins column:';
    str9b = 'Histogram counts column:';
end
str10 = 'FRET state columns:';
str11 = ['Next ',char(9658)];
str12 = 'data';
str13 = 'from';
str14 = 'to';
str15 = 'skip';
str16 = 'File preview:';
pink = [212,0,187]/255;
black = [0,0,0];

% parents
h_fig = h.figure;
h_tab = h.tab_fstrct;

% dimensions
postab = h_tab.Position;
wtxt1 = getUItextWidth(str0,h.fun,h.fsz,'bold',h.tbl);
wtxt2 = getUItextWidth(str2{1},h.fun,h.fsz,'normal',h.tbl)+h.warr;
wtxt3 = getUItextWidth(str4{2},h.fun,h.fsz,'normal',h.tbl)+h.warr;
wtxt4 = getUItextWidth(str6{2},h.fun,h.fsz,'bold',h.tbl)+h.warr;
wcb0 = getUItextWidth(str7,h.fun,h.fsz,'bold',h.tbl)+h.wbox;
wtxt5 = getUItextWidth(str8,h.fun,h.fsz,'bold',h.tbl);
if istraj
    wtxt6 = getUItextWidth(str9,h.fun,h.fsz,'bold',h.tbl);
else
    wtxt6a = getUItextWidth(str9a,h.fun,h.fsz,'bold',h.tbl);
    wtxt6b = getUItextWidth(str9b,h.fun,h.fsz,'bold',h.tbl);
end
wtxt7 = getUItextWidth(str16,h.fun,h.fsz,'normal',h.tbl);
wcb1 = getUItextWidth(str10,h.fun,h.fsz,'bold',h.tbl)+h.wbox;
wtbl0 = (postab(3)-3*h.mg)/2;
wtbl1 = postab(3)-2*h.mg;
htbl0 = (postab(4)-h.mgtab-h.htxt-h.hpop-h.mg-h.hedit-h.mg-h.hedit-h.mg/2-...
    h.mg-h.htxt-h.mg/2-h.mg-h.hedit-h.mg)/3;
htbl1 = htbl0*2;
wcol = [getUItextWidth(str12,h.fun,h.fsz,'normal',h.tbl),...
    repmat({max([getUItextWidth(str13,h.fun,h.fsz,'normal',h.tbl),...
    getUItextWidth(str14,h.fun,h.fsz,'normal',h.tbl),...
    getUItextWidth(str15,h.fun,h.fsz,'normal',h.tbl)])},1,3)];
wbut0 = getUItextWidth(str11,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;

% font colors
tclr = pink;
pclr = black;

% GUI
x = h.mg;
y = postab(4)-h.mgtab-h.htxt;

h.text_hLines = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str0,...
    'horizontalalignment','center','position',[x,y,wtxt1,h.htxt]);

x = x+wtxt1+h.mg;

h.text_delim = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',str1,...
    'horizontalalignment','center','position',[x,y,wtxt2,h.htxt]);

if istraj
    x = x+wtxt2+h.mg;

    h.text_oneMol = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        str3,'horizontalalignment','center','position',[x,y,wtxt3,h.htxt]);

    x = x+wtxt3+h.mg;

    h.text_alexDat = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        str5,'horizontalalignment','center','position',[x,y,wtxt4,h.htxt]);
end

x = h.mg;
y = y-h.hpop+(h.hpop-h.hedit)/2;

h.edit_hLines = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wtxt1,h.hedit],...
    'callback',{@edit_setExpSet_hLines,h_fig});

x = x+wtxt1+h.mg;
y = y-(h.hpop-h.hedit)/2;

h.pop_delim = uicontrol('parent',h_tab,'style','popupmenu','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wtxt2,h.hpop],...
    'callback',{@pop_setExpSet_delim,h_fig},'string',str2);

if istraj
    x = x+wtxt2+h.mg;

    h.pop_oneMol = uicontrol('parent',h_tab,'style','popupmenu','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wtxt3,...
        h.hpop],'string',str4,'callback',{@pop_setExpSet_oneMol,h_fig});

    x = x+wtxt3+h.mg;

    h.pop_alexDat = uicontrol('parent',h_tab,'style','popupmenu','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wtxt4,...
        h.hpop],'string',str6,'callback',{@pop_setExpSet_alexDat,h_fig});

    x = h.mg;
    y = y-h.mg-h.hedit;

    h.check_timeDat = uicontrol('parent',h_tab,'style','checkbox','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold',...
        'string',str7,'foregroundcolor',pink,'position',[x,y,wcb0,h.hedit],...
        'callback',{@check_setExpSet_timeDat,h_fig},'foregroundcolor',...
        tclr);

    x = x+wcb0;

    h.edit_timeCol = uicontrol('parent',h_tab,'style','edit','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,...
        h.hedit],'callback',{@edit_setExpSet_timeCol,h_fig},...
        'foregroundcolor',tclr,'fontweight','bold');

    x = x+h.wedit0;
    y = y+(h.hedit-h.htxt)/2;

    h.text_timeZero = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'string',str8,'position',...
        [x,y,wtxt5,h.htxt]);

    h = setExpSet_buildTimeArea(h,exc);

    x = h.mg;
    y = y-(h.hedit-h.htxt)/2-h.mg-h.hedit+(h.hedit-h.htxt)/2;

    h.text_intDat = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        str9,'horizontalalignment','left','position',[x,y,wtxt6,h.htxt]);

    y = y-(h.hedit-h.htxt)/2-h.mg/2-htbl0;

    h.tbl_intCol = uitable('parent',h_tab,'units',h.un,'fontunits',h.fun,...
        'fontsize',h.fsz,'position',[x,y,wtbl0,htbl0],'rowstriping','off',...
        'rowname',[],'columnwidth',wcol,'celleditcallback',...
        {@tbl_intCol_CellEdit,h_fig},'userdata',htbl0);

    x = x+wtbl0+h.mg;
    y = y+htbl0+h.mg/2;

    h.check_FRETseq = uicontrol('parent',h_tab,'style','checkbox','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold',...
        'string',str10,'position',[x,y,wcb1,h.hedit],'callback',...
        {@check_setExpSet_FRETseq,h_fig});

    y = y-h.mg/2-htbl0;

    h.tbl_seqCol = uitable('parent',h_tab,'units',h.un,'fontunits',h.fun,...
        'fontsize',h.fsz,'position',[x,y,wtbl0,htbl0],'rowstriping','off',...
        'rowname',[],'columnwidth',wcol,'celleditcallback',...
        {@tbl_seqCol_CellEdit,h_fig},'userdata',htbl0);
else
    x = h.mg;
    y = y-h.mg-h.hedit;
    
    h.text_xval = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        str9a,'position',[x,y,wtxt6a,h.htxt]);
    
    x = x+wtxt6a;
    y = y-(h.hedit-h.htxt)/2;
    
    h.edit_xval = uicontrol('parent',h_tab,'style','edit','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,...
        h.hedit],'callback',{@edit_setExpSet_xval,h_fig},...
        'foregroundcolor',tclr,'fontweight','bold');
    
    x = x+h.wedit0+h.mg;
    y = y+(h.hedit-h.htxt)/2;
    
    h.text_countval = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        str9b,'position',[x,y,wtxt6b,h.htxt]);
    
    x = x+wtxt6b;
    y = y-(h.hedit-h.htxt)/2;
    
    h.edit_countval = uicontrol('parent',h_tab,'style','edit','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,...
        h.hedit],'callback',{@edit_setExpSet_countval,h_fig},...
        'foregroundcolor',pclr,'fontweight','bold');
end

x = h.mg;
y = y-h.mg-h.htxt;

h.text_preview = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str16,...
    'horizontalalignment','left','position',[x,y,wtxt7,h.htxt]);

y = y-h.mg/2-htbl1;

h.table_fstrct = uitable('parent',h_tab,'units',h.un,'fontunits',h.fun,...
    'fontsize',h.fsz,'position',[x,y,wtbl1,htbl1],'rowstriping','off');

y = h.mg;
x = postab(3)-h.mg-wbut0;

h.push_nextFstrct = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str11,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_next,h_fig,5});
