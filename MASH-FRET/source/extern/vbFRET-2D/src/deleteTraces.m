function varargout = deleteTraces(varargin)
% DELETETRACES M-file for deleteTraces.fig
%      DELETETRACES, by itself, creates a new DELETETRACES or raises the existing
%      singleton*.
%
%      H = DELETETRACES returns the handle to a new DELETETRACES or the handle to
%      the existing singleton*.
%
%      DELETETRACES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETETRACES.M with the given input arguments.
%
%      DELETETRACES('Property','Value',...) creates a new DELETETRACES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before deleteTraces_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to deleteTraces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help deleteTraces

% Last Modified by GUIDE v2.5 23-Jan-2009 13:26:19
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deleteTraces_OpeningFcn, ...
                   'gui_OutputFcn',  @deleteTraces_OutputFcn, ...
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

% --- Executes just before deleteTraces is made visible.
function deleteTraces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to deleteTraces (see VARARGIN)

% Choose default command line output for deleteTraces
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

%use try/catch to make sure initialization only happens once
try 
    foo = handles.no_photobleachs;
catch
    % reload the names of data files, if applicable
    if ~isempty(vbFRET_data.dat.inputFileNames)
        set(handles.currentTraces_listbox,'String',vbFRET_data.dat.labels);
    end

    % initialize relabel checkboxes
    handles.plot = vbFRET_data.plot;
    set(handles.relabelTraces_checkbox,'Value', handles.plot.delete_sort_checkbox);
end

% flag to prevent multiple initializations
handles.no_photobleach = isequal(vbFRET_data.dat.raw,vbFRET_data.dat.raw_bkup);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes deleteTraces wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = deleteTraces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function currentTraces_listbox_Callback(hObject, eventdata, handles)
% no code needed for this callback, the listbox is only used as a visual

%%
function currentTraces_listbox_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function deleteTraces_listbox_Callback(hObject, eventdata, handles)
% no code needed for this callback, the listbox is only used as a visual


%%
function deleteTraces_listbox_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function delete_pushbutton_Callback(hObject, eventdata, handles)

%get the current list of file names from the currentTraces listbox
deleteTraceNames = get(handles.deleteTraces_listbox,'String');

%is there is nothing to delete, nothing happens unless user just wants to
%relabel traces
if get(handles.relabelTraces_checkbox,'Value')

elseif isempty(deleteTraceNames)*handles.no_photobleach
    return
end

%disables the button while data is processing
disableButtons(handles);

% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% make hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','watch');

% don't allow changes to be saved if analysis is running/paused
if ~isempty(vbFRET_data.dat.x_hat{1}) && vbFRET_data.analysis.cur_trace ~= -1
    flag.type = 'pushed during analysis';
    flag.problem = 'delete traces';
    vbFRETerrors(flag) 
    %disables the button while data is processing
    enableButtons(handles);
    % refresh the figure to reflect changes
    refresh(deleteTraces);
    % for some reason traces in the 'to delete' column appear in the
    % 'current traces' column as well and have to be removed
    currentTraceNames = get(handles.currentTraces_listbox,'String');
    del = intersect(currentTraceNames,deleteTraceNames);
    for i = 1:length(del)
        del_cur = strmatch(del(i),currentTraceNames,'exact');
        currentTraceNames(del_cur) = [];
    end
    set(handles.currentTraces_listbox,'String',currentTraceNames);
    % needed to prevent error
    set(handles.currentTraces_listbox,'Value',length(currentTraceNames));
    
    % unmake hourglass pointer for main gui
    set(vbFRET_data.figure1,'Pointer','arrow');
    return
end


vbFRET_data.dat = remove_traces(deleteTraceNames,vbFRET_data.dat);

%relabel traces if user desires
if get(handles.relabelTraces_checkbox,'Value')
    for n=1:length(vbFRET_data.dat.labels)
        vbFRET_data.dat.labels{n} = num2str(n);
        vbFRET_data.dat.labels_bkup{n} = num2str(n);
    end
end

%update plot slider 
update_plot_slidebar(vbFRET_data.dat);

% remember relabel checkbox setting
vbFRET_data.plot = handles.plot;

% unmake hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','arrow');

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% close load data gui
close(deleteTraces);

%%
function moveRight_pushbutton_Callback(hObject, eventdata, handles)
%get the current list of file names from the currentTraces listbox
currentTraceNames = get(handles.currentTraces_listbox,'String');
 
%get the values for the selected file names
option = get(handles.currentTraces_listbox,'Value');

%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 )
    return
end

% add selected items to the deleteTraces listbox
deleteTraceNames = get(handles.deleteTraces_listbox, 'String');
deleteTraceNames = [deleteTraceNames; currentTraceNames(option)];
deleteTraceNames = sortTraces(deleteTraceNames);
set(handles.deleteTraces_listbox, 'String', deleteTraceNames);
%moves the highlighted item to an appropiate value or else will get error
if max(get(handles.deleteTraces_listbox,'Value')) > length(deleteTraceNames) || get(handles.deleteTraces_listbox,'Value') == 0
    set(handles.deleteTraces_listbox,'Value',length(deleteTraceNames));
end


%erases the contents of highlighted item in data array
currentTraceNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.currentTraces_listbox,'String',currentTraceNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(currentTraceNames)
    set(handles.currentTraces_listbox,'Value',length(currentTraceNames));
end
 
% Update handles structure
guidata(hObject, handles);


%%
function moveLeft_pushbutton_Callback(hObject, eventdata, handles)
%get the current list of file names from the currentTraces listbox
deleteTraceNames = get(handles.deleteTraces_listbox,'String');
 
%get the values for the selected file names
option = get(handles.deleteTraces_listbox,'Value');

%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 )
    return
end

% add selected items to the deleteTraces listbox
currentTraceNames = get(handles.currentTraces_listbox, 'String');
currentTraceNames = [currentTraceNames; deleteTraceNames(option)];
currentTraceNames = sortTraces(currentTraceNames);
set(handles.currentTraces_listbox, 'String', currentTraceNames);
if max(get(handles.currentTraces_listbox,'Value')) > length(currentTraceNames) || get(handles.currentTraces_listbox,'Value') == 0
    set(handles.currentTraces_listbox,'Value',length(currentTraceNames));
end

%erases the contents of highlighted item in data array
deleteTraceNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.deleteTraces_listbox,'String',deleteTraceNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(deleteTraceNames)
    set(handles.deleteTraces_listbox,'Value',length(deleteTraceNames));
end
 
% Update handles structure
guidata(hObject, handles);


%%
function close_pushbutton_Callback(hObject, eventdata, handles)

% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% remember relabel checkbox setting
vbFRET_data.plot = handles.plot;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% close this gui 
close(deleteTraces);

%%
function relabelTraces_checkbox_Callback(hObject, eventdata, handles)
handles.plot.delete_sort_checkbox = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

%%
function [labels] = sortTraces(labels)
%this function arranges the traces in the listboxes in numerical/alphabetical order.

N = length(labels);
% sort strings and numbers separately
str_traces = cell(1,N);
str_traces_idx = zeros(1,N);
num_traces = zeros(1,N);
num_traces_idx = zeros(1,N);

count = 0;
for n=1:N
    count = count + 1;
    num = str2num(labels{n});
    if isempty(num)
        str_traces{count} = labels{n};
        str_traces_idx(count) = n;
    else        
        num_traces(count) = num;
        num_traces_idx(count) = n;
    end
end

%remove empty cells
del = find(str_traces_idx == 0);
str_traces(del) = [];
str_traces_idx(del) = [];
del = find(num_traces_idx == 0);
num_traces(del) = [];
num_traces_idx(del) = [];

% alphabetize
[ig str_sort_order] = sort(str_traces);
[ig num_sort_order] = sort(num_traces);

sorted_order = [num_traces_idx(num_sort_order) str_traces_idx(str_sort_order)];
labels = labels(sorted_order);

%%
function disableButtons(handles)
set(handles.figure1,'Pointer','watch');
set(handles.close_pushbutton,'Enable','off');
set(handles.delete_pushbutton,'Enable','off');
set(handles.moveRight_pushbutton,'Enable','off');
set(handles.moveLeft_pushbutton,'Enable','off');
set(handles.relabelTraces_checkbox,'Enable','off');

%%
function enableButtons(handles)
set(handles.figure1,'Pointer','arrow');
set(handles.close_pushbutton,'Enable','on');
set(handles.delete_pushbutton,'Enable','on');
set(handles.moveRight_pushbutton,'Enable','on');
set(handles.moveLeft_pushbutton,'Enable','on');
set(handles.relabelTraces_checkbox,'Enable','on');

%%
function dat = remove_traces(deleteTraceNames,dat)

% lock in any changes made during photobleaching removal (too complicated
% to deal with otherwise)
dat.raw_bkup = dat.raw;
dat.labels_bkup = dat.labels;

% get names of traces to delete
M = length(deleteTraceNames);
del = zeros(1,M);
for m = 1:M
    tmp = strmatch(deleteTraceNames{m},dat.labels,'exact');
    del(m) = tmp(1);
end
% remove traces from raw_bkup, raw, labels_bkup, labels and FRET
dat.raw_bkup(del) = [];
dat.labels_bkup(del) = [];
dat.raw(del) = [];
dat.labels(del) = [];
dat.FRET(del) = [];

% remove traces from analysis if applicable
N = length(del);

for n = N:-1:1 
    if length(dat.z_hat) >= del(n)
        dat.x_hat(:,del(n)) = [];
        dat.z_hat(del(n)) = [];
    end
    
    if length(dat.z_hat_db) >= del(n)
        dat.x_hat_db(:,del(n)) = [];
        dat.z_hat_db(del(n)) = [];
    end
    
    if length(dat.raw_db) >= del(n)
        dat.raw_db(del(n)) = [];
        dat.FRET_db(del(n)) = [];
    end
end