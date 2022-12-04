function varargout = advancedAnalysisSettings(varargin)
% ADVANCEDANALYSISSETTINGS M-file for advancedAnalysisSettings.fig
%      ADVANCEDANALYSISSETTINGS, by itself, creates a new ADVANCEDANALYSISSETTINGS or raises the existing
%      singleton*.
%
%      H = ADVANCEDANALYSISSETTINGS returns the handle to a new ADVANCEDANALYSISSETTINGS or the handle to
%      the existing singleton*.
%
%      ADVANCEDANALYSISSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCEDANALYSISSETTINGS.M with the given input arguments.
%
%      ADVANCEDANALYSISSETTINGS('Property','Value',...) creates a new ADVANCEDANALYSISSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before advancedAnalysisSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to advancedAnalysisSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help advancedAnalysisSettings

% Last Modified by GUIDE v2.5 03-Jul-2009 19:41:29
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @advancedAnalysisSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @advancedAnalysisSettings_OutputFcn, ...
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
% --- Executes just before advancedAnalysisSettings is made visible.
function advancedAnalysisSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to advancedAnalysisSettings (see VARARGIN)

% Choose default command line output for advancedAnalysisSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%use try/catch to make sure initialization only happens once
try 
    foo = handles.analysis.minK;
catch
    %store analysis info in advancedAnalysisSettings- necessary because
    %data is used in multiple functions. 
    handles.analysis = vbFRET_data.analysis;
    handles.plot = vbFRET_data.plot;
    handles.axes1 = vbFRET_data.axes1;
    % initialize everything
    handles = initialize_analysis_settings(handles);
        
    % make the plot dimension button group
    % set(handles.analysisDimension_buttongroup,'SelectionChangeFcn',@analysisDimension_buttongroup_SelectionChangeFcn);

    % do not allow analysis settings to be changed while analysis is going
    % on
%     if ~isempty(vbFRET_data.dat.x_hat)
%     if ~isempty(vbFRET_data.dat.x_hat{1}) && vbFRET_data.analysis.cur_trace ~= -1
%         set(handles.maxIter_editText,'Enable','inactive')
%         set(handles.threshold_editText,'Enable','inactive')
%         set(handles.analyze1D_radiobutton,'Enable','inactive')
%         set(handles.analyze2D_radiobutton,'Enable','inactive')
%         set(handles.upi_editText,'Enable','inactive')
%         set(handles.mu_editText,'Enable','inactive')
%         set(handles.beta_editText,'Enable','inactive')
%         set(handles.W_editText,'Enable','inactive')
%         set(handles.v_editText,'Enable','inactive')
%         set(handles.ua_editText,'Enable','inactive')
%         set(handles.uad_editText,'Enable','inactive')
%     end
%     end
            
    % Update handles structure
    guidata(hObject, handles);
end


% UIWAIT makes advancedAnalysisSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = advancedAnalysisSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function maxIter_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = round(str2num(get(hObject,'String')));

if (isempty(input))
     set(hObject,'String','1');
else
     % value must be >= 1
     set(hObject,'String',num2str(max(1,input(1))));
end

%update handles
handles.analysis.maxIter = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function maxIter_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function threshold_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

% value must be > 1
if (isempty(input)) | input <=0
     set(hObject,'String',num2str(handles.analysis.threshold));
else
     set(hObject,'String',num2str(input(1)));
end
%update handles
handles.analysis.threshold = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function threshold_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function plotResults_checkbox_Callback(hObject, eventdata, handles)
% update setting handle
handles.analysis.plot = get(hObject, 'Value');
guidata(hObject, handles);

%%
function displayProgress_checkbox_Callback(hObject, eventdata, handles)
% update setting handle
handles.analysis.display_progress = get(hObject, 'Value');
guidata(hObject, handles);

%%
function removeBlur_checkbox_Callback(hObject, eventdata, handles)
% update setting handle
handles.analysis.remove_blur = get(hObject, 'Value');

if handles.analysis.remove_blur
    set(handles.plotBlurRemoved_checkbox,'Enable', 'on');
else
    set(handles.plotBlurRemoved_checkbox,'Enable', 'off');
end

% update handles
guidata(hObject, handles);


%%
function plotBlurRemoved_checkbox_Callback(hObject, eventdata, handles)
% clicking button to quickly causes an error
set(hObject,'Enable','inactive');

% update setting handle
handles.plot.blur_rm = get(hObject, 'Value');
guidata(hObject, handles);

%update plot
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

%update vbFRET with all photobleach parameter settings
vbFRET_data.plot.blur_rm = handles.plot.blur_rm;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

plotFRET(vbFRET_data.axes1, vbFRET_data.dat, vbFRET_data.plot, get(vbFRET_data.plot1_slider,'Value'));

%put current gui back on top
advancedAnalysisSettings();

set(hObject,'Enable','on');

%%
function upi_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.upi));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.upi = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function upi_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function mu_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.mu));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.mu = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function mu_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function beta_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.beta));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.beta = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function beta_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function W_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.W));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.W = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function W_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function v_editText_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.v));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.v = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function v_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function ua_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.ua));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.ua = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function ua_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function uad_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = str2num(get(hObject,'String'));

if (isempty(input))
     set(hObject,'String',num2str(handles.analysis.PriorPar.uad));
else
     set(hObject,'String',num2str(input(1)));
end

%update handles
handles.analysis.PriorPar.uad = str2num(get(hObject, 'String'));
guidata(hObject, handles);

%%
function uad_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%
function autosave_editText_Callback(hObject, eventdata, handles)
% make sure input is an allowed value
input = round(str2num(get(hObject,'String')));

if (isempty(input))
     set(hObject,'String','-1');
else
     set(hObject,'String',num2str(max(-1,input(1))));
end


%update handles
handles.analysis.auto_rate = str2num(get(hObject, 'String'));
guidata(hObject, handles);


function autosave_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%
function OK_pushbutton_Callback(hObject, eventdata, handles)
% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% don't allow changes to be saved if analysis is running/paused
if ~isempty(vbFRET_data.dat.x_hat) 
    if ~isempty(vbFRET_data.dat.x_hat{1}) && vbFRET_data.analysis.cur_trace ~= -1
        allow_save = check_changes(vbFRET_data.analysis, handles.analysis);

        if allow_save == 0
            flag.type = 'pushed during analysis';
            flag.problem = 'advanced analysis settings';
            vbFRETerrors(flag) 
            return
        end
    end
end
%update vbFRET with all photobleach parameter settings
vbFRET_data.analysis = handles.analysis;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

% close this gui 
close(advancedAnalysisSettings);

%%
function apply_pushbutton_Callback(hObject, eventdata, handles)
% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% don't allow changes to be saved if analysis is running
if ~isempty(vbFRET_data.dat.x_hat)
    if ~isempty(vbFRET_data.dat.x_hat{1}) && vbFRET_data.analysis.cur_trace ~= -1
        allow_save = check_changes(vbFRET_data.analysis, handles.analysis);

        if allow_save == 0
            flag.type = 'pushed during analysis';
            flag.problem = 'advanced analysis settings';
            vbFRETerrors(flag) 
            return
        end
    end
end

%update vbFRET with all photobleach parameter settings
vbFRET_data.analysis = handles.analysis;

% save changed data back into main_gui
guidata(vbFRET, vbFRET_data);

%put advancedAnalysisSettings back on top
advancedAnalysisSettings();

%%
function default_pushbutton_Callback(hObject, eventdata, handles)
%get default settings for photobleach removal except for settings that are
%set up on main gui
minK = handles.analysis.minK;
maxK = handles.analysis.maxK;
numrestarts = handles.analysis.numrestarts;
use_guess = handles.analysis.use_guess;
exist_guess = handles.analysis.exist_guess;
guess = handles.analysis.guess;

% this restores defaults
handles.analysis = analysis_defaults();

% reload main gui settings
handles.analysis.minK = minK;
handles.analysis.maxK = maxK;
handles.analysis.numrestarts = numrestarts;
handles.analysis.use_guess = use_guess;
handles.analysis.exist_guess = exist_guess;
handles.analysis.guess = guess;


handles = initialize_analysis_settings(handles);

%update
guidata(hObject, handles);

%%
function cancel_pushbutton_Callback(hObject, eventdata, handles)
% close this gui 
close(advancedAnalysisSettings);

%%
% function analysisDimension_buttongroup_SelectionChangeFcn(hObject, eventdata)
% 
% %retrieve GUI data, i.e. the handles structure
% handles = guidata(hObject); 
%  
% switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
%     case 'analyze1D_radiobutton'
%         handles.analysis.dim = 1;
%     case 'analyze2D_radiobutton'
%         handles.analysis.dim = 2;
%     otherwise
%        % Code for when there is no match.
% end
% 
% %updates the handles structure
% guidata(hObject, handles);

%%
function handles = initialize_analysis_settings(handles)

% % initialize 'Analyze data in' box
% if handles.analysis.dim == 1
%     set(handles.analyze1D_radiobutton,'Value',1);
%     set(handles.analyze2D_radiobutton,'Value',0);
% else
%     set(handles.analyze1D_radiobutton,'Value',0);
%     set(handles.analyze2D_radiobutton,'Value',1);
% end    

%initialize 'VBEM Options' box
set(handles.maxIter_editText,'String',num2str(handles.analysis.maxIter));
set(handles.threshold_editText,'String',num2str(handles.analysis.threshold));
set(handles.plotResults_checkbox,'Value',handles.analysis.plot);
set(handles.displayProgress_checkbox,'Value',handles.analysis.display_progress);

%initialize 'Blur State Removal Options' box
set(handles.removeBlur_checkbox,'Value', handles.analysis.remove_blur);
set(handles.plotBlurRemoved_checkbox,'Value', handles.plot.blur_rm);
if handles.analysis.remove_blur
    set(handles.plotBlurRemoved_checkbox,'Enable', 'on');
else
    set(handles.plotBlurRemoved_checkbox,'Enable', 'off');
end

%initialize 'hyperparameters' box
set(handles.upi_editText,'String',num2str(handles.analysis.PriorPar.upi));
set(handles.mu_editText,'String',num2str(handles.analysis.PriorPar.mu));
set(handles.beta_editText,'String',num2str(handles.analysis.PriorPar.beta));
set(handles.W_editText,'String',num2str(handles.analysis.PriorPar.W));
set(handles.v_editText,'String',num2str(handles.analysis.PriorPar.v));
set(handles.ua_editText,'String',num2str(handles.analysis.PriorPar.ua));
set(handles.uad_editText,'String',num2str(handles.analysis.PriorPar.uad));

% initialize autosave frequency
set(handles.autosave_editText,'String',num2str(handles.analysis.auto_rate));

%%
function allow_save = check_changes(old, new)
% check to see if any parameters that VBEM uses have been changed
allow_save = isequal(old.dim,new.dim)*isequal(old.maxIter,new.maxIter)*...
    isequal(old.threshold,new.threshold)*isequal(old.PriorPar,new.PriorPar);


