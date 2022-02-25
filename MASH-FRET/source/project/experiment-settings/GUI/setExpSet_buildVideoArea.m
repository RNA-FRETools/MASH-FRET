function h = setExpSet_buildVideoArea(h,nChan,h_fig0)
% h = setExpSet_buildVideoArea(h,nChan,h_fig0)
%
% Creates adjustable control area of tabbed panel "Import".
%
% h: structure containing handles to all figure's children
% nChan: number of channels
% h_fig0: handle to main figure

% defaults
fact = 5;
blue = [0,0,1];
str0 = '...';
file_icon0 = 'add.png';
file_icon1 = 'remove.png';
ttstr0 = wrapHtmlTooltipString('<b>Add</b> a channel.');
ttstr1 = wrapHtmlTooltipString('<b>Remove</b> a channel.');
ttstr2 = 'Import video file for <b>channel %i</b>.';

% parents
h_fig = h.figure;
h_tab = h.tab_imp;

% dimensions
prevun = h_tab.Units;
setProp([h_fig,h_fig.Children],'units','pixels');
postab = h_tab.Position;
wbut1 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wbut0 = h.hedit;
wedit0 = ((postab(3)-2*h.mg)-2*wbut0-h.mg/fact-h.mg-...
    nChan*(h.mg/fact+wbut1)-(nChan-1)*h.mg)/nChan;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep,'..',...
    filesep,'..',filesep,'GUI',filesep];
img0 = imread([pname,file_icon0]);
img1 = imread([pname,file_icon1]);

% delete previous controls
h = delControlIfHandle(h,{'push_addChan','push_remChan',...
    'edit_impFileSingle','push_impFileSingle'});

x = h.mg;
y = h.edit_impFileMulti.Position(2);

h.push_addChan = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wbut0,h.hedit],...
    'string','','callback',{@push_setExpSet_addchan,h_fig,h_fig0},...
    'tooltipstring',ttstr0,'cdata',img0);

x = x+wbut0+h.mg/fact;

h.push_remChan = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wbut0,h.hedit],...
    'string','','callback',{@push_setExpSet_remChan,h_fig,h_fig0},...
    'tooltipstring',ttstr1,'cdata',img1);

x = x+wbut0+h.mg;

for c = 1:nChan
    h.edit_impFileSingle(c) = uicontrol('parent',h_tab,'style','edit',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'foregroundcolor',...
        blue,'horizontalalignment','right','position',[x,y,wedit0,h.hedit],...
        'callback',{@edit_setExpSet_impFileSingle,h_fig});
    
    x = x+wedit0+h.mg/fact;
    
    h.push_impFileSingle(c) = uicontrol('parent',h_tab,'style',...
        'pushbutton','units',h.un,'fontunits',h.fun,'fontsize',h.fsz,...
        'string',str0,'position',[x,y,wbut1,h.hedit],'callback',...
        {@push_setExpSet_impFile,h_fig,h_fig0,c},'tooltipstring',...
        wrapHtmlTooltipString(sprintf(ttstr2,c)));
    
    x = x+wbut1+h.mg;
end

setProp([h_fig,h_fig.Children],'units',prevun);

