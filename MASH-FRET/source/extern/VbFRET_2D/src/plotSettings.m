function varargout = plotSettings(varargin)
% PLOTSETTINGS M-file for plotSettings.fig
%      PLOTSETTINGS, by itself, creates a new PLOTSETTINGS or raises the existing
%      singleton*.
%
%      H = PLOTSETTINGS returns the handle to a new PLOTSETTINGS or the handle to
%      the existing singleton*.
%
%      PLOTSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSETTINGS.M with the given input arguments.
%
%      PLOTSETTINGS('Property','Value',...) creates a new PLOTSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotSettings

% Last Modified by GUIDE v2.5 01-Sep-2009 14:18:07

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @plotSettings_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%
% --- Executes just before plotSettings is made visible.
function plotSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotSettings (see VARARGIN)

% Choose default command line output for plotSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%use try/catch to make sure initialization only happens once
try 
    foo = handles.bar;
catch
    handles.bar = 1;
    % get the main_gui handle (access to the gui)
    vbFRET_handle       = vbFRET;       
    % get the data from the gui (all handles inside gui_main)
    vbFRET_data         = guidata(vbFRET_handle);
    % initialize GUI with current display settings
    handles = init_GUI(vbFRET_data.plot.cur_lineType,vbFRET_data.plot,handles);
end

% reupdate handles structure
guidata(hObject, handles);

% UIWAIT makes plotSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = plotSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function backgroundColor_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');
str = get(hObject, 'String');
sel = get(hObject, 'Value');

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
vbFRET_data.plot.background = get_color(str{sel});

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');

% Update handles structure
guidata(hObject, handles);

function backgroundColor_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function grids_checkbox_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%if checked
if get(hObject,'Value')
    vbFRET_data.plot.grids = 'on';
else
    vbFRET_data.plot.grids = 'off';
end

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% put current gui back on top
plotSettings();

% Update handles structure
guidata(hObject, handles);

set(hObject,'Enable','on');

%%
function fixY_checkbox_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%if checked
if get(hObject,'Value')
    vbFRET_data.plot.fixy = 'on';
else
    vbFRET_data.plot.fixy = 'off';
end

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% put current gui back on top
plotSettings();

% Update handles structure
guidata(hObject, handles);

set(hObject,'Enable','on');



%%
function plotLine_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');
sel = get(hObject, 'Value');
%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% remember current line in case gui is closed
vbFRET_data.plot.cur_lineType = sel;

% update GUI display
handles = init_GUI(sel,vbFRET_data.plot,handles);

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');


function plotLine_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function lineColor_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

% get popup item selected
str = get(hObject, 'String');
sel = get(hObject, 'Value');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.color = get_color(str{sel});
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.color = get_color(str{sel});
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.color = get_color(str{sel});
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.color = get_color(str{sel});
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.color = get_color(str{sel});
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.color = get_color(str{sel});
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));


% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');

%%
function lineColor_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function lineStyle_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

% get popup item selected
str = get(hObject, 'String');
sel = get(hObject, 'Value');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.lineStyle = get_lineStyle(str{sel});
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.lineStyle = get_lineStyle(str{sel});
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.lineStyle = get_lineStyle(str{sel});
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.lineStyle = get_lineStyle(str{sel});
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.lineStyle = get_lineStyle(str{sel});
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.lineStyle = get_lineStyle(str{sel});
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');

%%
function lineStyle_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lineThickness_editText_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
% set(hObject,'Enable','inactive');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

% get line thickness entered by user
line_thickness = str2num(get(hObject,'String'));

% set to 1 if non-numeric entered, take first number is several are input
if (isempty(line_thickness))
    line_thickness = 1;
else
    line_thickness = line_thickness(1);
end

% make sure line thickness is a reasonable number
if line_thickness < 0.25
    line_thickness = 0.25;
elseif line_thickness > 100
    line_thickness = 100;
end


% update linethickness value
set(hObject,'String',num2str(line_thickness))


%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.lineThickness = line_thickness;
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.lineThickness = line_thickness;
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.lineThickness = line_thickness;
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.lineThickness = line_thickness;
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.lineThickness = line_thickness;
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.lineThickness = line_thickness;
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

% set(hObject,'Enable','on');

%%
function lineThickness_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function marker_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

% get popup item selected
str = get(hObject, 'String');
sel = get(hObject, 'Value');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.marker = get_symbol(str{sel});
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.marker = get_symbol(str{sel});
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.marker = get_symbol(str{sel});
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.marker = get_symbol(str{sel});
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.marker = get_symbol(str{sel});
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.marker = get_symbol(str{sel});
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');


function marker_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function markerSize_editText_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
% set(hObject,'Enable','inactive');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

% get line thickness entered by user
marker_size = str2num(get(hObject,'String'));

% set to 1 if non-numeric entered, take first number is several are input
if (isempty(marker_size))
    marker_size = 1;
else
    marker_size = marker_size(1);
end

% make sure marker size is a reasonable number
if marker_size < 0.25
    marker_size = 0.25;
elseif marker_size > 100
    marker_size = 100;
end

% update linethickness value
set(hObject,'String',num2str(marker_size))

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.markerSize = marker_size;
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.markerSize = marker_size;
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.markerSize = marker_size;
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.markerSize = marker_size;
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.markerSize = marker_size;
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.markerSize = marker_size;
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

% set(hObject,'Enable','on');

%%
function markerSize_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function markerColor_popupmenu_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

% get popup item selected
str = get(hObject, 'String');
sel = get(hObject, 'Value');

% get the line type
line_type_str = get(handles.plotLine_popupmenu, 'String');
line_type_sel = get(handles.plotLine_popupmenu, 'Value');
line_type = line_type_str{line_type_sel};

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% convert selection into a matlab plot option
switch line_type
    case 'FRET Data (1D)'
        vbFRET_data.plot.FRET.markerColor = get_color(str{sel});
    case 'FRET Fit (1D)'
        vbFRET_data.plot.FRETfit.markerColor = get_color(str{sel});
    case 'Donor Data (2D)'
        vbFRET_data.plot.donor.markerColor = get_color(str{sel});
    case 'Acceptor Data (2D)'
        vbFRET_data.plot.acceptor.markerColor = get_color(str{sel});
    case 'Donor Fit (2D)'
        vbFRET_data.plot.donorFit.markerColor = get_color(str{sel});
    case 'Acceptor Fit (2D)'
        vbFRET_data.plot.acceptorFit.markerColor = get_color(str{sel});
end


% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% Update handles structure
guidata(hObject, handles);

%put current gui back on top
plotSettings();

set(hObject,'Enable','on');
    

function markerColor_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function OK_pushbutton_Callback(hObject, eventdata, handles)
close(plotSettings);


%%
function default_pushbutton_Callback(hObject, eventdata, handles)

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

temp = init_plot();

vbFRET_data.plot.grids = temp.grids;
vbFRET_data.plot.fixy = temp.fixy;
vbFRET_data.plot.background = temp.background;
vbFRET_data.plot.cur_lineType = temp.cur_lineType;
vbFRET_data.plot.FRET = temp.FRET;
vbFRET_data.plot.FRETfit = temp.FRETfit;
vbFRET_data.plot.donor = temp.donor;
vbFRET_data.plot.acceptor = temp.acceptor;
vbFRET_data.plot.donorFit = temp.donorFit;
vbFRET_data.plot.acceptorFit = temp.acceptorFit;

% update plot
plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

% update display
handles = init_GUI(vbFRET_data.plot.cur_lineType,vbFRET_data.plot,handles);

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% Update handles structure
guidata(hObject, handles);


% put current gui back on top
plotSettings();

%% 
function handles = init_GUI(sel,plot_opts,handles);

% initialize plotLine popupbox
set(handles.plotLine_popupmenu, 'Value',sel)

% needed so everything else knows which type of line is being ploted
str = get(handles.plotLine_popupmenu, 'String');
sel_str = str{sel};

% set the background color popupbox 
color_out = set_color(plot_opts.background);
str = get(handles.backgroundColor_popupmenu, 'String');
set(handles.backgroundColor_popupmenu, 'Value',strmatch(color_out,str,'exact'));

% set the grid line checkbox status
if isequal(plot_opts.grids,'on')
    set(handles.grids_checkbox,'Value',1);
else
    set(handles.grids_checkbox,'Value',0);
end

% set the fix Y-axis checkbox status
if isequal(plot_opts.fixy,'on')
    set(handles.fixY_checkbox,'Value',1);
else
    set(handles.fixY_checkbox,'Value',0);
end


% get the line type
opts = get_line_type(sel_str, plot_opts);

% initialize Line color
color_out = set_color(opts.color);    
str = get(handles.lineColor_popupmenu, 'String');
set(handles.lineColor_popupmenu, 'Value',strmatch(color_out,str,'exact'));

% initialize Line style
switch opts.lineStyle
    case '-'
        line_out = 'Solid line';
    case '--'
        line_out = 'Dashed line';       
    case ':'
        line_out = 'Dotted line';
    case '-.'
        line_out = 'Dash-dot line';
    case 'none'
        line_out = 'None';
end

str = get(handles.lineStyle_popupmenu, 'String');
set(handles.lineStyle_popupmenu, 'Value',strmatch(line_out,str,'exact'));

% initialize Line Thickness 
set(handles.lineThickness_editText, 'String',num2str(opts.lineThickness));

% initialize Marker
switch opts.marker
    case '+'
        symbol_out = 'Plus sign';
    case 'o'
        symbol_out = 'Circle';
    case '*'
        symbol_out = 'Asterisk';
    case 'x'
        symbol_out = 'Cross';
    case 's'
        symbol_out = 'Square';
    case 'd'
        symbol_out = 'Diamond';
    case '^'
        symbol_out = 'Upward-pointing triangle';
    case 'v'
        symbol_out = 'Downward-pointing triangle';
    case '>'
        symbol_out = 'Right-pointing triangle';
    case '<'
        symbol_out = 'Left-pointing triangle';
    case 'p'
        symbol_out = 'Five-pointed star';
    case 'h'
        symbol_out = 'Six-pointed star';
end 

str = get(handles.marker_popupmenu, 'String');
set(handles.marker_popupmenu, 'Value',strmatch(symbol_out,str,'exact'));

% initialize marker size
set(handles.markerSize_editText, 'String',num2str(opts.markerSize));

% initialize Line color
color_out = set_color(opts.markerColor);    
str = get(handles.markerColor_popupmenu, 'String');
set(handles.markerColor_popupmenu, 'Value',strmatch(color_out,str,'exact'));

%%
function color_out = get_color(sel)

switch sel
    case 'Yellow'
        color_out = 'y';
    case 'Magenta'
        color_out = 'm';
    case 'Cyan'
        color_out = 'c';
    case 'Red'
        color_out = 'r';
    case 'Green'
        color_out = 'g';
    case 'Blue'
        color_out = 'b';
    case 'White'
        color_out = 'w';
    case 'Black'
        color_out = 'k';
    case 'Gray'
        % will be defined as 0.5*[1 1 1] in plotFRET.m 
        color_out = 'e';
end 

%%
function line_out = get_lineStyle(sel)

switch sel
    case 'Solid line'
        line_out = '-';
    case 'Dashed line'
        line_out = '--';       
    case 'Dotted line'
        line_out = ':';
    case 'Dash-dot line'
        line_out = '-.';
    case 'None'
        line_out = 'none';
end 

%%
function symbol_out = get_symbol(sel)

switch sel
    case 'Plus sign'
        symbol_out = '+';
    case 'Circle'
        symbol_out = 'o';
    case 'Asterisk'
        symbol_out = '*';
    case 'Cross'
        symbol_out = 'x';
    case 'Square'
        symbol_out = 's';
    case 'Diamond'
        symbol_out = 'd';
    case 'Upward-pointing triangle'
        symbol_out = '^';
    case 'Downward-pointing triangle'
        symbol_out = 'v';
    case 'Right-pointing triangle'
        symbol_out = '>';
    case 'Left-pointing triangle'
        symbol_out = '<';
    case 'Five-pointed star'
        symbol_out = 'p';
    case 'Six-pointed star'
        symbol_out = 'h';
end 

%%
function color_out = set_color(color_in)
% takes the saved name color and converts it into the popupmenu color

switch color_in
    case 'y'
        color_out = 'Yellow';
    case 'm'
        color_out = 'Magenta';
    case 'c'
        color_out = 'Cyan';
    case 'r'
        color_out = 'Red';
    case 'g'
        color_out = 'Green';
    case 'b'
        color_out = 'Blue';
    case 'w'
        color_out = 'White';
    case 'k'
        color_out = 'Black';
    otherwise 'e'
        color_out = 'Gray';
end

%%
% get the line type
function opts = get_line_type(sel, plot_opts)

switch sel
    case 'FRET Data (1D)'
        opts = plot_opts.FRET;
    case 'FRET Fit (1D)'
        opts = plot_opts.FRETfit;
    case 'Donor Data (2D)'
        opts = plot_opts.donor;
    case 'Acceptor Data (2D)'
        opts = plot_opts.acceptor;
    case 'Donor Fit (2D)'
        opts = plot_opts.donorFit;
    case 'Acceptor Fit (2D)'
        opts = plot_opts.acceptorFit;
end



