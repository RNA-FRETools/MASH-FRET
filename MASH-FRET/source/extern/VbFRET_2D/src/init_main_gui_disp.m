function handles = init_main_gui_disp(handles)
%initialize the main gui displays
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% use analysis parameters to update main gui 'Analysis box' display
set(handles.minK_editText,'String',handles.analysis.minK);
set(handles.maxK_editText,'String',handles.analysis.maxK);
set(handles.numrestarts_editText,'String',handles.analysis.numrestarts);
set(handles.guessFRETstates_checkbox,'Value',handles.analysis.use_guess);

if handles.analysis.use_guess
    set(handles.guessFRETstates_editText,'Enable','on');
else
    set(handles.guessFRETstates_editText,'Enable','off');
end

% use handles.analysis parameters to update main gui 'Plot Data' display
if handles.plot.dim == 1
    set(handles.plot1D_radiobutton,'Value',1)
    set(handles.plot2D_radiobutton,'Value',0)
else
    set(handles.plot1D_radiobutton,'Value',0)
    set(handles.plot2D_radiobutton,'Value',1)
end

if isequal(handles.plot.type,'r')
    set(handles.plotRaw_radiobutton,'Value',1)
    set(handles.plotAnalyzed_radiobutton,'Value',0)
else
    set(handles.plotRaw_radiobutton,'Value',0)
    set(handles.plotAnalyzed_radiobutton,'Value',1)
end

set(handles.showDataPoints_checkbox,'Value',handles.plot.data_pts)
set(handles.showFitPoints_checkbox,'Value',handles.plot.fit_pts)

% autosave in the File menu
if handles.analysis.auto_save == 0
    set(handles.autosaveFile,'Label','Enable Autosave');
else
    set(handles.autosaveFile,'Label','Disable Autosave');
end
