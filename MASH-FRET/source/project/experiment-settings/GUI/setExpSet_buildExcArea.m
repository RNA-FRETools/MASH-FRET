function h = setExpSet_buildExcArea(h,nExc)
% h = setExpSet_buildExcArea(h,nExc)
%
% Creates adjustable control area of tabbed panel "Lasers".
%
% h: structure containing handles to all figure's children
% nExc: number of alternating lasers

% defaults
str0 = 'wavelength(nm)';
str1 = 'emitter';

% parents
h_fig = h.figure;
h_tab = h.tab_exc;

% dimensions
postab = h_tab.Position;
hare = postab(4)-h.mgtab-h.hedit-2*h.mg-h.hedit-h.mg;
wtxt0 = (postab(3)-2*h.mg-(nExc-1)*2*h.mg)/nExc;
haxe = hare-h.htxt-h.mg-h.htxt-h.hpop-h.mg;
wedit1 = (wtxt0-h.mg)/2;
wpop0 = wedit1;

x = h.mg;
y = h.edit_nExc.Position(2)-h.mg-h.htxt-h.mg-h.htxt-h.hpop-h.mg-haxe;

for l = 1:nExc
    y = y+haxe+h.mg+h.hpop+h.htxt+h.mg;
    
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
    
    x = x+wtxt0+2*h.mg;
end

