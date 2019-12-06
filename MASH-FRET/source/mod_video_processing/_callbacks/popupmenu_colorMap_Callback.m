function popupmenu_colorMap_Callback(obj, evd, h_fig)
contents = get(obj,'String');
selectedText = contents{get(obj, 'Value')};

h = guidata(h_fig);
h.param.movPr.cmap = get(obj, 'Value');
guidata(h_fig, h);

colormap(selectedText);
updateActPan([selectedText ' colormap applied.'], h_fig);
updateFields(h_fig, 'imgAxes');