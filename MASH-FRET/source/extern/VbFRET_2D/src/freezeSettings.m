function freezeSettings(flag)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);


if flag
    set(vbFRET_data.minK_editText,'Enable','inactive')
    set(vbFRET_data.maxK_editText,'Enable','inactive')
    set(vbFRET_data.numrestarts_editText,'Enable','inactive')
    set(vbFRET_data.guessFRETstates_checkbox,'Enable','inactive')
    set(vbFRET_data.guessFRETstates_editText,'Enable','inactive')
else
    set(vbFRET_data.minK_editText,'Enable','on')
    set(vbFRET_data.maxK_editText,'Enable','on')
    set(vbFRET_data.numrestarts_editText,'Enable','on')
    set(vbFRET_data.guessFRETstates_checkbox,'Enable','on')
    set(vbFRET_data.guessFRETstates_editText,'Enable','on')
end

if vbFRET_data.analysis.use_guess == 0
    set(vbFRET_data.guessFRETstates_editText,'Enable','off');
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);
