function updatePanel_VV(h_fig)

% defaults
fntS = 10.666666;
w_cb = 200;
w_edit = 60;
w_txt = w_cb - w_edit;
h_cb = 20;
mg = 10;

h = guidata(h_fig);
tagNames = h.tm.molTagNames;
nTag = numel(tagNames);

% reset old controls
if isfield(h.tm, 'checkbox_VV_tag')
    for t = 1:size(h.tm.checkbox_VV_tag,2)
        if ishandle(h.tm.checkbox_VV_tag(t))
            delete([h.tm.checkbox_VV_tag(t),h.tm.edit_VV_tag(t)]);
        end
    end
    h.tm = rmfield(h.tm,{'checkbox_VV_tag','edit_VV_tag'});
end

edit_units = get(h.tm.edit_VV_tag0,'units');
set(h.tm.edit_VV_tag0,'units','pixels');
pos_edit = get(h.tm.edit_VV_tag0,'position');
set(h.tm.edit_VV_tag0,'units',edit_units);

xNext = 2*mg;
yNext = pos_edit(2) - mg - h_cb;

str_tag = colorTagNames(h_fig);
for t = 1:nTag
    h.tm.checkbox_VV_tag(t) = uicontrol('style','checkbox','parent',...
        h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
        'fontsize',fntS,'position',[xNext,yNext,w_edit,h_cb],'string',...
        'show','callback',{@checkbox_VV_tag_Callback,h_fig,t});
    
    xNext = xNext + w_edit + mg;
    
    h.tm.edit_VV_tag(t) = uicontrol('style','edit','parent',...
        h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
        'fontsize',fntS,'position',[xNext,yNext,w_txt,h_cb],'string',...
        removeHtml(str_tag{t+1}),'enable','off');
    
    xNext = 2*mg;
    yNext = yNext - mg - h_cb;
end

setProp(get(h.tm.uipanel_videoView, 'children'),'units','normalized');

guidata(h_fig,h);

