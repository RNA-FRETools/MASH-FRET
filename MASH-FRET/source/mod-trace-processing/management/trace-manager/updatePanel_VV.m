function updatePanel_VV(h_fig)

h = guidata(h_fig);
q = h.tm;

% defaults
str0 = 'show';

% reset old controls
q = delControlIfHandle(q,{'checkbox_VV_tag','edit_VV_tag'});

% parents
h_pan = q.uipanel_videoView;

% pixel positions
pos_cb = getPixPos(q.checkbox_VV_tag0);
wcb = pos_cb(3);
hcb = pos_cb(4);
pos_edit = getPixPos(q.edit_VV_tag0);
wed = pos_edit(3);
mg = pos_edit(1)-(pos_cb(1)+wcb);

% font
fsz = q.checkbox_VV_tag0.FontSize;
fun = q.checkbox_VV_tag0.FontUnits;

% tags
tagNames = q.molTagNames;
nTag = numel(tagNames);
str_tag = colorTagNames(h_fig);

x = 2*mg;
y = pos_edit(2) - mg - hcb;

for t = 1:nTag
    q.checkbox_VV_tag(t) = uicontrol('style','checkbox','parent',h_pan,...
        'units','pixels','fontunits',fun,'fontsize',fsz,'position',...
        [x,y,wcb,hcb],'string',str0,'callback',...
        {@checkbox_VV_tag_Callback,h_fig,t});
    
    x = x + wcb + mg;
    
    q.edit_VV_tag(t) = uicontrol('style','edit','parent',h_pan,'units',...
        'pixels','fontunits',fun,'fontsize',fsz,'position',[x,y,wed,hcb],...
        'string',removeHtml(str_tag{t+1}),'enable','off');
    
    x = 2*mg;
    y = y - mg - hcb;
end

setProp(get(h_pan,'children'),'units','normalized');

h.tm = q;
guidata(h_fig,h);

