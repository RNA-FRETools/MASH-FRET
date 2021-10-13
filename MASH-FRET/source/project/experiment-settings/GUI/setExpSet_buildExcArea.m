function h = setExpSet_buildExcArea(h,nExc,h_fig0)
% h = setExpSet_buildExcArea(h,nExc)
%
% Creates adjustable control area of tabbed panel "Lasers".
%
% h: structure containing handles to all figure's children
% nExc: number of alternating lasers
% h_fig0: handle to main figure

% defaults
str0 = 'wavelength(nm)';
str1 = 'emitter';
str2 = 'average image over video frames illuminated by laser %i';

% parents
h_fig = h.figure;
h_tab = h.tab_exc;
h0 = guidata(h_fig0);

% dimensions
prevun = h_tab.Units;
setProp([h_fig,h_fig.Children],'units','pixels');
postab = h_tab.Position;
hare = postab(4)-h.mgtab-h.hedit-2*h.mg-h.hedit-h.mg;
wtxt0 = (postab(3)-2*h.mg-(nExc-1)*2*h.mg)/nExc;
[str,~] = wrapStrToWidth(str2,h.fun,h.fsz,'normal',wtxt0,'gui',...
    [h0.figure_dummy,h0.text_dummy]);
n = numel(str);
% wtxt1 = getUItextWidth(str2,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
% n = ceil(wtxt1/wtxt0);
haxe = hare-n*h.htxt-h.mg-h.htxt-h.hpop-h.mg-h.htxt;
wedit1 = (wtxt0-h.mg)/2;
wpop0 = wedit1;

% delete previous controls
if isfield(h,'text_exc') && sum(ishandle(h.text_exc))
    delete(h.text_exc);
    h = rmfield(h,'text_exc');
end
if isfield(h,'text_excWl') && sum(ishandle(h.text_excWl))
    delete(h.text_excWl);
    h = rmfield(h,'text_excWl');
end
if isfield(h,'text_excEm') && sum(ishandle(h.text_excEm))
    delete(h.text_excEm);
    h = rmfield(h,'text_excEm');
end
if isfield(h,'edit_excWl') && sum(ishandle(h.edit_excWl))
    delete(h.edit_excWl);
    h = rmfield(h,'edit_excWl');
end
if isfield(h,'popup_excEm') && sum(ishandle(h.popup_excEm))
    delete(h.popup_excEm);
    h = rmfield(h,'popup_excEm');
end
if isfield(h,'axes_exc') && sum(ishandle(h.axes_exc))
    delete(h.axes_exc);
    h = rmfield(h,'axes_exc');
end
if isfield(h,'text_excLgd') && sum(ishandle(h.text_excLgd))
    delete(h.text_excLgd);
    h = rmfield(h,'text_excLgd');
end

x = h.mg;
y = h.mg+h.hedit+h.mg;

for l = 1:nExc
    y = y+n*h.htxt+haxe+h.mg+h.hpop+h.htxt+h.mg;
    
    h.text_exc(l) = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        num2str(l),'position',[x,y,wtxt0,h.htxt],'backgroundcolor',h.bgclr,...
        'foregroundcolor',h.fgclr);
    
    y = y-h.mg-h.htxt;
    
    h.text_excWl(l) = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
        [x,y,wedit1,h.htxt]);
    
    x = x+wedit1+h.mg;
    
    h.text_excEm(l) = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
        [x,y,wpop0,h.htxt]);
    
    x = x-h.mg-wedit1;
    y = y-h.hpop+(h.hpop-h.hedit)/2;
    
    h.edit_excWl(l) = uicontrol('parent',h_tab,'style','edit','units',h.un,...
        'position',[x,y,wedit1,h.hedit],'callback',...
        {@edit_setExpSet_excWl,h_fig,l});
    
    x = x+wedit1+h.mg;
    y = y-(h.hpop-h.hedit)/2;
    
    h.popup_excEm(l) = uicontrol('parent',h_tab,'style','popup','units',...
        h.un,'string',{'Select an emitter'},'position',[x,y,wpop0,h.hpop],...
        'callback',{@popup_setExpSet_excEm,h_fig,l});

    x = x-h.mg-wedit1;
    y = y-h.mg-haxe;

    h.axes_exc(l) = axes('parent',h_tab,'units',h.un,'fontunits',h.fun,...
        'fontsize',h.fsz,'position',[x,y,wtxt0,haxe],'xtick',[],'ytick',[],...
        'nextplot','replacechildren');
    
    y = y-n*h.htxt;

    h.text_excLgd(l) = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',sprintf(str2,l),...
        'position',[x,y,wtxt0,n*h.htxt]);
    
    x = x+wtxt0+2*h.mg;
end

setProp([h_fig,h_fig.Children],'units',prevun);

