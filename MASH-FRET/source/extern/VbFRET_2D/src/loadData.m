function varargout = loadData(varargin)
% LOADDATA M-file for loadData.fig
%      LOADDATA, by itself, creates a new LOADDATA or raises the existing
%      singleton*.
%
%      H = LOADDATA returns the handle to a new LOADDATA or the handle to
%      the existing singleton*.
%
%      LOADDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADDATA.M with the given input arguments.
%
%      LOADDATA('Property','Value',...) creates a new LOADDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before loadData_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to loadData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help loadData

% Last Modified by GUIDE v2.5 02-Jul-2009 13:57:58

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loadData_OpeningFcn, ...
                   'gui_OutputFcn',  @loadData_OutputFcn, ...
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
% --- Executes just before loadData is made visible.
function loadData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loadData (see VARARGIN)

% Choose default command line output for loadData
handles.output = hObject;

%use try/catch to make sure initialization only happens once
try 
    foo = handles.dat.raw;
catch
    % get the main_gui handle (access to the gui)
    vbFRET_handle       = vbFRET;       
    % get the data from the gui (all handles inside gui_main)
    vbFRET_data         = guidata(vbFRET_handle);
    
    % give loadData gui the data info
    handles.dat = vbFRET_data.dat; 
    handles.plot = vbFRET_data.plot;
    
    % reload the names of data files, if applicable
    if ~isempty(handles.dat.inputFileNames)
        set(handles.inputFiles_listbox,'String',handles.dat.inputFileNames);
    end

    % initialize sort/relabel checkboxes
    set(handles.sort_checkbox,'Value', handles.plot.sort_checkbox);
    set(handles.relabelTraces_checkbox,'Value', handles.plot.relabel_checkbox);

    
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes loadData wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = loadData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function inputFiles_listbox_Callback(hObject, eventdata, handles)
% no code needed for this callback, the listbox is only used as a visual

function inputFiles_listbox_CreateFcn(hObject, eventdata, handles)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function addFiles_pushbutton_Callback(hObject, eventdata, handles)

%gets input file(s) from user. 
[input_file,pathname] = uigetfile( ...
       {'*.mat;*.dat;*.txt' 'Matlab/data files (*.mat, *.dat, *.txt)';...       
        '*.*', 'All Files (*.*)';...
        '*.mat', 'Saved Matlab Files (*.mat)';...
        '*.dat', 'Data Files (*.dat)';...
        '*.txt', 'Text Files (*.txt)'}, ...
        'Select files', ... 
        'MultiSelect', 'on');

%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end

%gets the current data file names inside the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');

%if they only select one file, then the data will not be a cell
if iscell(input_file) == 0
 
    %add the most recent data file selected to the cell containing
    %all the data file names
    inputFileNames{length(inputFileNames)+1} = fullfile(pathname,input_file);
 
%else, data will be in cell format
else
    %stores full file path into inputFileNames
    for n = 1:length(input_file)
        inputFileNames{length(inputFileNames)+1} = fullfile(pathname,input_file{n});
    end
end

%remove repeated files
[ig unique_list ig] = unique(inputFileNames,'first');
temp = inputFileNames(unique_list);
inputFileNames = temp;

%updates the gui to display all filenames in the listbox
set(handles.inputFiles_listbox,'String',inputFileNames);
 
%make sure first file is always selected so it doesn't go out of range
%the GUI will break if this value is out of range
set(handles.inputFiles_listbox,'Value',1);

% Update handles structure
guidata(hObject, handles);

%%
function deleteFiles_pushbutton_Callback(hObject, eventdata, handles)

%get the current list of file names from the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');

% return if no files are loaded
if length(inputFileNames) == 0
    return
end

%get the values for the selected file names
option = get(handles.inputFiles_listbox,'Value');
 
%return if not files are marked for deletion
if (isempty(option) == 1 || option(1) == 0 )
    return
end

%erases the contents of highlighted item in data array
inputFileNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.inputFiles_listbox,'String',inputFileNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(inputFileNames)
    set(handles.inputFiles_listbox,'Value',length(inputFileNames));
end
 
% Update handles structure
guidata(hObject, handles);

%%
function clearList_pushbutton_Callback(hObject, eventdata, handles)

%get the current list of file names from the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');
 
%is there is nothing to delete, nothing happens
if length(inputFileNames) == 0 
    return
end
 
%erases the contents of highlighted item in data array
inputFileNames = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.inputFiles_listbox,'String',inputFileNames);
 
%moves the highlighted item to an appropiate value or else will get error
set(handles.inputFiles_listbox,'Value',length(inputFileNames));
 
% Update handles structure
guidata(hObject, handles);


%%
function loadData_pushbutton_Callback(hObject, eventdata, handles)

% get the list of input file names from the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');
 
% checks to see if the user selected any input files
% if not, nothing happens
if isempty(inputFileNames)
    return
end

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

if get(vbFRET_data.analyzeData_pushbutton,'UserData') == 1
    flag.type = 'pushed during analysis';
    flag.problem = 'pushbutton';
    vbFRETerrors(flag) 
    return
end

%initialize the data structures' arrays
dat = vbFRET_data.dat;

% make hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','watch');

%disables the button while data is processing
disableButtons(handles);

%refresh the figure to reflect changes
refresh(loadData); 
 
% if user is restoring a saved session, restore data and close this gui
saved_session = is_saved_session(dat,inputFileNames);

if saved_session
    % unmake hourglass pointer for main gui
    set(vbFRET_data.figure1,'Pointer','arrow');

    close(loadData);
    return
end

% check to see if traces are already loaded
dat = append_files_query(dat);

% the FRET transform causes a lot of divide by zero warnings
warning off MATLAB:divideByZero

% length of traces before appending data
n0 = length(dat.z_hat)+1;

% load the files (adds, labels_bkup,labels,raw_bkup,raw,x_hat,z_hat)
for x = 1 : length(inputFileNames)
    dat_type = get_dat_type(inputFileNames{x});

    switch dat_type
        case 'mat'
            [dat err] = load_mat_data(inputFileNames{x}, dat);
        case 'dat'
            [dat err] = load_dat_data(inputFileNames{x}, dat);
        case 'path'
            [dat err] = load_path_data(inputFileNames{x}, dat);
        otherwise
            'ERROR'
    end

    % stop loading data if there's an error
    if err
        % unmake hourglass pointer for main gui
        set(vbFRET_data.figure1,'Pointer','arrow');
        enableButtons(handles);
        return
    end

end

% length of traces after appending data
N = length(dat.labels_bkup);


% relabel all traces from 1 to N if desired
if handles.plot.relabel_checkbox
    for n=1:N
        dat.labels_bkup{n} = num2str(n);
        dat.labels{n} = num2str(n);
    end
% sort traces alphabetically/numerically (only apply to apended data) if
% desired
elseif handles.plot.sort_checkbox
    dat = sortTraces(dat,n0,N);
end


% FRET transform data and delete undefined data points 
N = length(dat.labels);
dat.FRET = cell(1,N);
for n=1:N
    dat.FRET{n} = dat.raw{n}(:,2)./(sum(dat.raw{n},2));
    % remove non-finite FRET values from data
    del = find(isnan(dat.FRET{n}) | isinf(dat.FRET{n}));
    dat.FRET{n}(del) = [];
    dat.raw_bkup{n}(del,:) = [];
    dat.raw{n}(del,:) = [];
    if size(dat.x_hat,2) >= n && ~isempty(dat.x_hat{1,n})
        dat.x_hat{1,n}(del,:) = [];
        dat.x_hat{2,n}(del,:) = [];
        dat.z_hat{n}(del,:) = [];
    end
end

warning on MATLAB:divideByZero

%check for redundant labels
if size(dat.labels,1) ~= size(unique(dat.labels),1)
    flag.type = 'importData';
    flag.problem = 'unique traces';
    vbFRETerrors(flag);
end

% update plot slidebar with number of traces
update_plot_slidebar(dat);

% pass information to vbFRET gui

% store input file names so they're there the next time the load data gui
% is open
dat.inputFileNames = inputFileNames;

%update vbFRET with trace information
vbFRET_data.dat = dat;

% remember relabel / sort settings
vbFRET_data.plot = handles.plot;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% unmake hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','arrow');

%data is done processing, so re-enable the buttons
% enableButtons(handles);

%update gui
% guidata(hObject, handles);
 
% close load data gui
close(loadData);

%%
function close_pushbutton_Callback(hObject, eventdata, handles)
% save list of files to load

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

% get the list of input file names from the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');

vbFRET_data.dat.inputFileNames = inputFileNames;

% remember relabel / sort settings
vbFRET_data.plot = handles.plot;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% close this gui 
close(loadData);

%%
function relabelTraces_checkbox_Callback(hObject, eventdata, handles)
handles.plot.relabel_checkbox = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);


%%
function sort_checkbox_Callback(hObject, eventdata, handles)
handles.plot.sort_checkbox = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);

%%
function disableButtons(handles)
set(handles.figure1,'Pointer','watch');
set(handles.loadData_pushbutton,'Enable','off');
set(handles.addFiles_pushbutton,'Enable','off');
set(handles.deleteFiles_pushbutton,'Enable','off');
set(handles.close_pushbutton,'Enable','off');
set(handles.inputFiles_listbox,'Enable','off');
set(handles.relabelTraces_checkbox,'Enable','off');
set(handles.sort_checkbox,'Enable','off');

%%
function enableButtons(handles)
set(handles.figure1,'Pointer','arrow');
set(handles.loadData_pushbutton,'Enable','on');
set(handles.addFiles_pushbutton,'Enable','on');
set(handles.deleteFiles_pushbutton,'Enable','on');
set(handles.close_pushbutton,'Enable','on');
set(handles.inputFiles_listbox,'Enable','on');
set(handles.relabelTraces_checkbox,'Enable','on');
set(handles.sort_checkbox,'Enable','on');

%%
function saved_session = is_saved_session(dat,inputFileNames);

% check if mat file is a vbFRET saved session 

saved_session = 0;

for x = 1 : length(inputFileNames)
    %gets the filename without the extension
    [ignore,fileName,ext,ignore] = fileparts(inputFileNames{x});

    % check if mat file is a vbFRET saved session 
    if isequal(ext(2:end),'mat') && ~isempty(strmatch('vbFRET_saved_session',who('-file',inputFileNames{x}),'exact'))

        saved_session = 1;
        
        load_saved_session(inputFileNames{x});                
                
        % warn if user tried to load more than one file
        if length(inputFileNames) > 1
            flag.type = 'importData';
            flag.problem = 'saved session plus others';
            flag.filname = [fileName ext];
            vbFRETerrors(flag);
        end                
        
        return
    end
end


%%
function dat = append_files_query(dat)

% if data is currently loaded check if files should be appended or reloaded
if ~isempty(dat.raw_bkup) 
    append_query = questdlg('Some traces are already loaded. Do you want to overwrite these traces or append the new traces to the existing ones?', ...
                         'Save Data', ...
                         'Overwrite', 'Append', 'Overwrite');
    if isequal(append_query,'Overwrite')
        % reactivate analysis settings fields 
        freezeSettings(0);
        % reset vbFRET settings as if clear data were pushed
        clearAnalysisFxn()
        % initialize trace information
        dat = init_dat;
    else % if appending
        % lock in any changes made during photobleaching removal (too complicated
        % to deal with otherwise)
        dat.labels_bkup = dat.labels;
        dat.raw_bkup = dat.raw;
    end
else
    % reactivate analysis settings fields 
    freezeSettings(0);
    % initialize trace information
    dat = init_dat;
end

%%
function dat_type = get_dat_type(filname)

%gets the filename without the extension
[ignore,fileName,ext,ignore] = fileparts(filname);

%assume dat unless proved otherwise
dat_type = 'dat';

% check for mat files
if isequal(ext(2:end),'mat')
    dat_type = 'mat';
    return
end

% check for path files
if ~isempty(regexpi(filname,'path'))
    try
        path_file = load(filname);
        [r c] = size(path_file);
        if c == 5 && isequal(path_file(:,1),[path_file(1,1):path_file(end,1)]')
            dat_type = 'path';
        end
    catch
        dat_type = 'dat';
    end
end


