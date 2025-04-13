function popup_emitter_Callback(obj,evd,fig)

h = guidata(fig);
h.axes_bleachstats.UserData = [];
h.axes_blinkstats.UserData = [];
ud_pbstats([],[],fig,'all');