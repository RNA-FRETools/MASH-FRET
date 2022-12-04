function h = setExpSet_buildIntensityArea(h,exc)
% h = setExpSet_buildIntensityArea(h,exc)
%
% Creates adjustable intensity columns area of tabbed panel "File structure".
%
% h: structure containing handles to all figure's children
% exc: laser wavelengths

% defaults
str0 = '999nm:';
str1 = 'to';
str2 = '(0=end)';

% parents
h_fig = h.figure;
h_tab = h.tab_fstrct;
h_txt = h.text_intDat;

% dimensions
prevun = h_tab.Units;
setProp([h_fig,h_fig.Children],'units','pixels');
postxt = h_txt.Position;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl);
wtxt1 = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl);
wtxt2 = getUItextWidth(str2,h.fun,h.fsz,'normal',h.tbl);

% delete previous controls
if isfield(h,'text_intExcCol') && sum(ishandle(h.text_intExcCol))
    delete(h.text_intExcCol);
    h = rmfield(h,'text_intExcCol');
end
if isfield(h,'edit_intExcCol1') && sum(ishandle(h.edit_intExcCol1))
    delete(h.edit_intExcCol1);
    h = rmfield(h,'edit_intExcCol1');
end
if isfield(h,'text_intExcTo') && sum(ishandle(h.text_intExcTo))
    delete(h.text_intExcTo);
    h = rmfield(h,'text_intExcTo');
end
if isfield(h,'edit_intExcCol2') && sum(ishandle(h.edit_intExcCol2))
    delete(h.edit_intExcCol2);
    h = rmfield(h,'edit_intExcCol2');
end
if isfield(h,'text_intExcZero') && sum(ishandle(h.text_intExcZero))
    delete(h.text_intExcZero);
    h = rmfield(h,'text_intExcZero');
end

% GUI
x = postxt(1)+postxt(3);
y = postxt(2);

nExc = numel(exc);
for l = 1:nExc
    
    h.text_intExcCol(l) = uicontrol('parent',h_tab,'style','text',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',...
        [x,y,wtxt0,h.htxt],'string',sprintf('%inm:',exc(l)));
    
    x = x+wtxt0;
    y = y-(h.hedit-h.htxt)/2;
    
    h.edit_intExcCol1(l) = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold',...
        'foregroundcolor',h_txt.ForegroundColor,'position',...
        [x,y,h.wedit0,h.hedit],'callback',...
        {@edit_setExpSet_intExcCol1,l,h_fig});
    
    x = x+h.wedit0;
    y = y+(h.hedit-h.htxt)/2;
    
    h.text_intExcTo(l) = uicontrol('parent',h_tab,'style','text',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',...
        [x,y,wtxt1,h.htxt],'string',str1);
    
    x = x+wtxt1;
    y = y-(h.hedit-h.htxt)/2;
    
    h.edit_intExcCol2(l) = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold',...
        'foregroundcolor',h_txt.ForegroundColor,'position',...
        [x,y,h.wedit0,h.hedit],'callback',...
        {@edit_setExpSet_intExcCol2,l,h_fig});

    x = x+h.wedit0;
    y = y+(h.hedit-h.htxt)/2;

    h.text_intExcZero(l) = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,'position',...
        [x,y,wtxt2,h.htxt]);
    
    x = x+wtxt2+h.mg/2;
end

setProp([h_fig,h_fig.Children],'units',prevun);
