function load_saved_session(filname)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

%load saved session filename
load(filname);

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);


%update all the vbFRET parameter/data handles
vbFRET_data.dat = session_settings.dat;
vbFRET_data.fit_par = session_settings.fit_par;
vbFRET_data.plot = session_settings.plot;
vbFRET_data.debleach = session_settings.debleach;
vbFRET_data.analysis = session_settings.analysis;


% needed for back compatibility
try 
    vbFRET_data.analysis.auto_save;
catch
    vbFRET_data.analysis.auto_save = 0;
    analysis.auto_name = {};
    vbFRET_data.analysis.auto_rate = -1;
end


% needed for back compatibility
try 
    vbFRET_data.plot.background;
catch
    vbFRET_data.plot = init_plot();
end



% initialize main gui display
vbFRET_data = init_main_gui_disp(vbFRET_data);

%update plot settings
update_plot_slidebar(vbFRET_data.dat);

% switch to current plot if any are loaded
N = length(vbFRET_data.dat.labels);




if N > 0    
    sliderValue = session_settings.current_plot;
    n = sliderValue;
    set(vbFRET_data.plot1_slider,'Value',sliderValue);
    % update fraction and label edit texts 
    set(vbFRET_data.plot1Slider_editText,'String',vbFRET_data.dat.labels{sliderValue});
    set(vbFRET_data.plot1SliderFraction_editText,'String',sprintf('%d of %d',n,N));
    % update plot if applicable
    plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, n);
end

% freeze if analysis active, unfreeze if not 
if vbFRET_data.analysis.cur_trace == -1
    freezeSettings(0);
    set(vbFRET_data.analyzeData_pushbutton,'String','Analyze Data!')
else
    freezeSettings(1);
    set(vbFRET_data.analyzeData_pushbutton,'String','Resume Analysis')
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);