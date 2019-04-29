function popupmenu_colorMap_Callback(obj, evd, h)
contents = get(obj,'String');
selectedText = contents{get(obj, 'Value')};
h.param.movPr.cmap = get(obj, 'Value');
guidata(h.figure_MASH, h);
colormap(selectedText);
updateActPan([selectedText ' colormap applied.'], h.figure_MASH);
updateFields(h.figure_MASH, 'imgAxes');