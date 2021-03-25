function clearAnalysisFxn()
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all vbFRET_data inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

% clear vbFRET_data
N = length(vbFRET_data.dat.raw);
vbFRET_data.dat.x_hat = cell(2,N);
vbFRET_data.dat.z_hat = cell(1,N);
vbFRET_data.dat.x_hat_db = {};
vbFRET_data.dat.z_hat_db = {};
vbFRET_data.dat.raw_db = {};
vbFRET_data.dat.FRET_db = {};

vbFRET_data.fit_par = [];
vbFRET_data.analysis.cur_trace = -1;
vbFRET_data.analysis.auto_name = {};

% reset plot
vbFRET_data.plot.type = 'r';
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, 1);
%update slider and fraction box
set(vbFRET_data.plot1_slider,'Value',1)
set(vbFRET_data.plot1SliderFraction_editText,'String',sprintf('%d of %d',1,N));
set(vbFRET_data.plot1Slider_editText,'String',vbFRET_data.dat.labels{1});


% reset analyze data pushbutton
set(vbFRET_data.analyzeData_pushbutton,'String','Analyze Data!')
set(vbFRET_data.msgBox_staticText,'String','')

% reactivate analysis settings fields 
freezeSettings(0)

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);
