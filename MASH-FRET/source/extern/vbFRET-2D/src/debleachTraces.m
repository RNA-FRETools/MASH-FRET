function varargout = debleachTraces(varargin)
% DEBLEACHTRACES M-file for debleachTraces.fig
%      DEBLEACHTRACES, by itself, creates a new DEBLEACHTRACES or raises the existing
%      singleton*.
%
%      H = DEBLEACHTRACES returns the handle to a new DEBLEACHTRACES or the handle to
%      the existing singleton*.
%
%      DEBLEACHTRACES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEBLEACHTRACES.M with the given input arguments.
%
%      DEBLEACHTRACES('Property','Value',...) creates a new DEBLEACHTRACES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before debleachTraces_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to debleachTraces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help debleachTraces

% Last Modified by GUIDE v2.5 18-Feb-2009 17:10:29
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @debleachTraces_OpeningFcn, ...
                   'gui_OutputFcn',  @debleachTraces_OutputFcn, ...
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
% --- Executes just before debleachTraces is made visible.
function debleachTraces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to debleachTraces (see VARARGIN)

% Choose default command line output for debleachTraces
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%use try/catch to make sure initialization only happens once
try 
    foo = handles.debleach;
catch
    % import data structures from main gui
    handles.debleach = vbFRET_data.debleach;
%     handles.dat = vbFRET_data.dat;
    % initialize edit text boxes with current photobleach removal settings
    handles = initialize_bleach_settings(handles);
    % set a flag to determine if traces are being/have been analyzed
%     handles.active_analysis = ~(analysis.cur_trace == -1 && isempty(handles.dat.z_hat{1}));
end

guidata(hObject, handles);


% UIWAIT makes debleachTraces wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = debleachTraces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function popupmenu1_Callback(hObject, eventdata, handles)
%1 = 1D transformed 
%2 = Single channel 
%3 = Summed channel

%update handle
handles.debleach.type = get(handles.popupmenu1, 'Value');
%update static text for popup menu
popup_text = popup_staticText(get(handles.popupmenu1,'Value'));
truncateWhen_string = popup_threshold_value(handles.debleach);
%update static text label
set(handles.truncateInput1_staticText,'String',popup_text);
%update editText box
set(handles.truncateWhen_editText, 'String', truncateWhen_string);

guidata(hObject, handles);

%%
function popupmenu1_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function truncateWhen_editText_Callback(hObject, eventdata, handles)

%checks to see if input is empty. if so, default input1_editText to zero
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String','0')
elseif length(input) > 1
     set(hObject,'String',num2str(input(1)))
end

%update handles containing truncateWhen_editText value so its there even
%when the popup menu changes values
switch get(handles.popupmenu1,'Value')
    case 1
        handles.debleach.cutoff_1D = str2num(get(handles.truncateWhen_editText, 'String'));
    case 2
        handles.debleach.cutoff_either = str2num(get(handles.truncateWhen_editText, 'String'));
    case 3
        handles.debleach.cutoff_sum = str2num(get(handles.truncateWhen_editText, 'String'));
end

guidata(hObject, handles);


%%
function truncateWhen_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%
function extraSteps_editText_Callback(hObject, eventdata, handles)

% make sure input is an allowed value
input = round(str2num(get(hObject,'String')));

if (isempty(input))
     set(hObject,'String','0');
else
    set(hObject,'String',num2str(input(1)));
end

%update handles
% handles.debleachTraces.xtra = str2num(get(handles.extraSteps_editText, 'String'));
handles.debleach.xtra = str2num(get(hObject, 'String'));

guidata(hObject, handles);

%%
function extraSteps_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function minLength_editText_Callback(hObject, eventdata, handles)

% make sure input is an allowed value
input = round(str2num(get(hObject,'String')));

if (isempty(input))
     set(hObject,'String','1');
else
     % value must be >= 1
     set(hObject,'String',num2str(max(1,input(1))));
end

%update handles
% handles.debleachTraces.min_length = str2num(get(handles.minLength_editText, 'String'));
handles.debleach.min_length = str2num(get(hObject, 'String'));

guidata(hObject, handles);


%%
function minLength_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function debleachTraces_pushbutton_Callback(hObject, eventdata, handles)

% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% get data handles
handles.dat = vbFRET_data.dat;

% if there's no data, do nothing
if isempty(handles.dat.raw_bkup)
    % save settings
    saveDebleachTracesSettings(handles.debleach);
    return
end

% do not remove photobleaching if traces are/have been analyzed
if ~isempty(handles.dat.x_hat{1}) 
    flag.type = 'pushed during analysis';
    flag.problem = 'debleach';
    vbFRETerrors(flag) 
    saveDebleachTracesSettings(handles.debleach);
    return
end    
 
% disable buttons while working 
% disableButtons(handles);
% refresh(vbFRETgui);

%remove photobleach
handles.dat = remove_photobleach(handles.dat,handles.debleach);

%update plot slidebar
update_plot_slidebar(handles.dat);

%update vbFRET with all photobleach parameter settings
vbFRET_data.debleach = handles.debleach;
vbFRET_data.dat = handles.dat;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);


% enable buttons
% enableButtons(handles);

% close this gui 
close(debleachTraces);

%%
function close_pushbutton_Callback(hObject, eventdata, handles)
% close this gui 
close(debleachTraces);

%%
function saveSettings_pushbutton_Callback(hObject, eventdata, handles)
% save settings
saveDebleachTracesSettings(handles.debleach);

%%
function default_pushbutton_Callback(hObject, eventdata, handles)

%get default settings for photobleach removal
handles.debleach = debleach_defaults();

handles = initialize_bleach_settings(handles);

%update
guidata(hObject, handles);

%%
function popup_text = popup_staticText(popup_value)

%short little function to update truncateWhen_staticText
switch popup_value   
    case 1
        popup_text = sprintf('Truncate data when FRET exceeds\n1 or 0 by more than:');
    case 2
        popup_text = sprintf('Truncate data when Channel 1 or\nChannel 2 is less than:');
    case 3
        popup_text = sprintf('Truncate data when Channel 1 +\nChannel 2 is less than:');
    otherwise
end


%%
function truncateWhen_string = popup_threshold_value(debleach)

%short little function to update truncateWhen_editText
switch debleach.type
    case 1
        truncateWhen_string = num2str(debleach.cutoff_1D);
    case 2
        truncateWhen_string = num2str(debleach.cutoff_either);
    case 3
        truncateWhen_string = num2str(debleach.cutoff_sum);
end

%%
function smoothing_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = round(str2num(get(hObject,'String')));

if (isempty(input))
     set(hObject,'String','1');
else
     % value must be >= 1
     set(hObject,'String',num2str(max(1,input(1))));
end

%update handles
% handles.debleachTraces.smooth_steps = str2num(get(handles.smoothing_editText, 'String'));
handles.debleach.smooth_steps = str2num(get(hObject, 'String'));

guidata(hObject, handles);

%%
function smoothing_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function smoothing_checkbox_Callback(hObject, eventdata, handles)
%checkboxStatus = 0, if the box is unchecked, 
%checkboxStatus = 1, if the box is checked
checkboxStatus = get(handles.smoothing_checkbox,'Value');

if checkboxStatus
    set(handles.smoothing_editText,'Enable','on');
    set(handles.smoothOver_staticText, 'Enable', 'on')
else
    set(handles.smoothing_editText,'Enable','off');
    set(handles.smoothOver_staticText, 'Enable', 'off')
end  

%update handles
handles.debleach.smooth  = checkboxStatus;
guidata(hObject, handles);

%%
function handles = initialize_bleach_settings(handles);
%load popup menu status
set(handles.popupmenu1, 'Value', handles.debleach.type);
%update static text for popup menu
popup_text = popup_staticText(handles.debleach.type);
set(handles.truncateInput1_staticText,'String',popup_text);
%update data truncation criterion
truncateWhen_string = popup_threshold_value(handles.debleach);
set(handles.truncateWhen_editText, 'String', truncateWhen_string);
%update smoothing info
set(handles.smoothing_editText, 'String', num2str(handles.debleach.smooth_steps));
set(handles.smoothing_checkbox,'Value',handles.debleach.smooth)
checkboxStatus = get(handles.smoothing_checkbox,'Value');
if checkboxStatus
    set(handles.smoothing_editText,'Enable','on');
    set(handles.smoothOver_staticText, 'Enable', 'on');
else
    set(handles.smoothing_editText,'Enable','off');
    set(handles.smoothOver_staticText, 'Enable', 'off');
end    

%update truncate extra time steps 
set(handles.extraSteps_editText, 'String', num2str(handles.debleach.xtra));
%update min trace length
set(handles.minLength_editText, 'String', num2str(handles.debleach.min_length));
%end load data from vbFRET.

%%
function saveDebleachTracesSettings(debleach);

% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%update vbFRET with all photobleach parameter settings
vbFRET_data.debleach = debleach;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

%put debleachTraces back on top
debleachTraces();
