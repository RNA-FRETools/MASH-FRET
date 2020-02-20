function set_TP_subImg(contrast,brightness,h_fig)
% set_TP_subImg(contrast,brightness,h_fig)
%
% Set sub-image settings
%
% opt: structure containing export options as set in getDefault_TP (see p.expOpt)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

exc_str = get(h.popupmenu_subImg_exc,'string');
nExc = numel(exc_str);
exc = [];
for l = 1:nExc
    exc = cat(2,exc,sscanf(exc_str{l},'%inm'));
end
[o,exc] = min(exc);
set(h.popupmenu_subImg_exc,'value',exc);
popupmenu_subImg_exc_Callback(h.popupmenu_subImg_exc,[],h_fig);

min_sld = get(h.slider_brightness,'min');
max_sld = get(h.slider_brightness,'max');
pos_brght = min_sld+(max_sld-min_sld)*brightness/100;
set(h.slider_brightness,'value',pos_brght);
slider_brightness_Callback(h.slider_brightness,[],h_fig);

min_sld = get(h.slider_contrast,'min');
max_sld = get(h.slider_contrast,'max');
pos_ctrst = min_sld+(max_sld-min_sld)*contrast/100;
set(h.slider_contrast,'value',pos_ctrst);
slider_contrast_Callback(h.slider_contrast,[],h_fig);
