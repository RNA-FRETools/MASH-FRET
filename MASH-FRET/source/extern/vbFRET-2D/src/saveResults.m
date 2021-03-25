function varargout = saveResults(varargin)
% SAVERESULTS M-file for saveResults.fig
%      SAVERESULTS, by itself, creates a new SAVERESULTS or raises the existing
%      singleton*.
%
%      H = SAVERESULTS returns the handle to a new SAVERESULTS or the handle to
%      the existing singleton*.
%
%      SAVERESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAVERESULTS.M with the given input arguments.
%
%      SAVERESULTS('Property','Value',...) creates a new SAVERESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before saveResults_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to saveResults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help saveResults

% Last Modified by GUIDE v2.5 05-Mar-2009 13:41:31

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saveResults_OpeningFcn, ...
                   'gui_OutputFcn',  @saveResults_OutputFcn, ...
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
% --- Executes just before saveResults is made visible.
function saveResults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saveResults (see VARARGIN)

% Choose default command line output for saveResults
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% try 
%     foo = handles.bar;
% catch
%     handles.bar = 1;
%     % get the main_gui handle (access to the gui)
%     vbFRET_handle       = vbFRET;       
%     % get the data from the gui (all handles inside gui_main)
%     vbFRET_data         = guidata(vbFRET_handle);
% end
% 
% % reupdate handles structure
% guidata(hObject, handles);

% UIWAIT makes saveResults wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = saveResults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
function dateStamp_checkbox_Callback(hObject, eventdata, handles)
% no code needed

function timeStamp_checkbox_Callback(hObject, eventdata, handles)
% no code needed

%%
function saveType_popupmenu_Callback(hObject, eventdata, handles)

strings = get(hObject,'String');
cur_string = strings{get(hObject,'Value')};

handles = update_popups(cur_string, handles);

%updates the handles structure
guidata(hObject, handles);

%%
function saveType_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function saveExt_popupmenu_Callback(hObject, eventdata, handles)
% no code needed

function saveExt_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function nPlots_popupmenu_Callback(hObject, eventdata, handles)
% no code needed

function nPlots_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function saveName_editText_Callback(hObject, eventdata, handles)
% no code needed 

function saveName_editText_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
function browseFilname_pushbutton_Callback(hObject, eventdata, handles)
pathname = uigetdir;

%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end

save_name = fullfile(pathname,' ');

set(handles.saveName_editText,'String',save_name);

%updates the handles structure
guidata(hObject, handles);


%%
function save_pushbutton_Callback(hObject, eventdata, handles)
% get the main_gui handle (access to the gui)
vbFRET_handle       = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data         = guidata(vbFRET_handle);

% error if try to save while running analysis
if get(vbFRET_data.analyzeData_pushbutton,'UserData') == 1
    flag.type = 'pushed during analysis';
    flag.problem = 'pushbutton';
    vbFRETerrors(flag) 
    return
end

% make hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','watch');

% get what type of files will be saved
strings = get(handles.saveType_popupmenu,'String');
saveType = strings{get(handles.saveType_popupmenu,'Value')};

% get file extenstion
saveExt = get(handles.saveExt_popupmenu,'Value');

% get the name of the file/folder to save to
saveName = get(handles.saveName_editText,'String');
saveName = strtrim(saveName);
if isequal(saveName, 'Save Name')
    saveName = '';
end

% and break up into parts
[filePath,fileName,ext,ig] = fileparts(saveName);


% add date/time?
dateStamp = get(handles.dateStamp_checkbox,'Value');
timeStamp = get(handles.timeStamp_checkbox,'Value');
DTstamp = d_t_stamp(timeStamp,dateStamp);

% warnings and errors if incomplete data is attempted to be saved for
% some file types
if any(strmatch(saveType,{'Save Idealized Traces' 'Save Plots (using settings from main display)'...
        'Save Analysis Summary'},'exact')) 
    stop_flag = incomplete_data_check(vbFRET_data.plot.blur_rm,vbFRET_data.analysis.remove_blur,vbFRET_data.dat);
    if stop_flag
            % unmake hourglass pointer for main gui
            set(vbFRET_data.figure1,'Pointer','arrow');
            return
    end
end

% try
    switch saveType
%%
        case 'Save Session (can continue analysis later)'
            % make file name
            save_name = fullfile(filePath,[fileName DTstamp '.mat']);

            % check the file doesn't already exist
            overwrite = name_exists_one(save_name);
            if overwrite == 0
                % unmake hourglass pointer for main gui
                set(vbFRET_data.figure1,'Pointer','arrow');
                return
            end
            
            % save a variable to let vbFRET know this is a saved session file
            vbFRET_saved_session = 'file type';
            % get date and time stamp
            d_t = clock;
            date_and_time = sprintf('Date: %s   Time: %02d:%02d',date,d_t(4),d_t(5));

            % save current settings/analysis
            session_settings.dat = vbFRET_data.dat;
            session_settings.fit_par = vbFRET_data.fit_par;
            session_settings.plot = vbFRET_data.plot;
            session_settings.debleach = vbFRET_data.debleach;
            session_settings.analysis = vbFRET_data.analysis;

            % save current plot
            session_settings.current_plot = get(vbFRET_data.plot1_slider,'Value');
            
            %save file
            save(save_name,'vbFRET_saved_session','date_and_time','session_settings');
%%
        case 'Save Idealized Traces'
            % must have at least one analyzed trace to save
            if check_traces_exist(vbFRET_data.dat,'x_hat')
                % unmake hourglass pointer for main gui
                set(vbFRET_data.figure1,'Pointer','arrow');
                return
            end
            
            % gets the data to be saved (loads blur removed if applicable)
            [labels data FRET path path2D N] = get_save_data(vbFRET_data.dat,vbFRET_data.plot,vbFRET_data.analysis.remove_blur);

            % delete any traces that were not idealized
            [labels data FRET path path2D N] = remove_empty(labels, data, FRET, path, path2D);
            
            switch saveExt 

                case 1
                    % make file name
                    save_name = fullfile(filePath,[fileName DTstamp '.mat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end

                    %save file
                    save(save_name,'labels','data','FRET','path','path2D');
                case 2
                    % in case user saves to a file that exists
                    overwrite_all = 0;
                    for n = 1:N
                        % make file name
                        save_name = fullfile(filePath,[fileName labels{n} '_PATH' DTstamp '.dat']);
                        % check the file doesn't already exist
                        [overwrite_all overwrite] = name_exists_all(save_name,overwrite_all);
                        if overwrite == 0
                            % unmake hourglass pointer for main gui
                            set(vbFRET_data.figure1,'Pointer','arrow');
                            return
                        end

                        % put file components in variable
                        save_data = [(1:length(FRET{n}))' data{n} FRET{n} path{n}];

                        % save variable as text
                        fid = fopen(save_name,'w');
                        for i = 1:size(save_data,1);
                            fprintf(fid,'%15d%15.3f%15.3f%15.6f%15.6f\n',...
                                save_data(i,1), save_data(i,2), save_data(i,3),...
                                save_data(i,4), save_data(i,5));
                        end
                        fclose(fid);
    %                     save(save_name,'save_data','-ASCII');
                    end
                case 3
                    % make file name
                    save_name = fullfile(filePath,[fileName '_PATH' DTstamp '.dat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end
                    
                    % get size of data to be saved
                    T = 0;
                    for i = 1:length(path)
                        T = T + length(path{i});
                    end
                    
                    % variable to hold data to be written
                    out_var = NaN*ones(T,2);            
                    
                    % put path data into variable, column 1 contains the
                    % trace number. column 2 contains the path data
                    for i = 1:length(path)
                        j = find(isnan(out_var(:,1)),1);
                        out_var(j:j+length(path{i})-1,1) = i;
                        out_var(j:j+length(path{i})-1,2) = path{i};
                    end
                    
                    % save variable as text
                    fid = fopen(save_name,'w');
                    for t = 1:T
                        fprintf(fid,'%5d %16f\n',out_var(t,1), out_var(t,2));
                    end
                    fclose(fid);
                    
            end                        

%%            
        case 'Save Raw Data'
            % must have at least one trace to save
            if check_traces_exist(vbFRET_data.dat,'raw')
                % unmake hourglass pointer for main gui
                set(vbFRET_data.figure1,'Pointer','arrow');
                return
            end
            
            [labels data FRET path path2D N] = get_save_data(vbFRET_data.dat,vbFRET_data.plot,vbFRET_data.analysis.remove_blur);
            
            switch saveExt 
                case 1 % save as matlab file
                    % make file name
                    save_name = fullfile(filePath,[fileName DTstamp '.mat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end

                    %save file
                    save(save_name,'labels','data','FRET');
                    
                case 2 % individual text files

                    % in case user saves to a file that exists
                    overwrite_all = 0;
                    
                    for n = 1:N
                        % make file name
                        save_name = fullfile(filePath,[fileName labels{n} DTstamp '.dat']);

                        % check the file doesn't already exist
                        [overwrite_all overwrite] = name_exists_all(save_name,overwrite_all);
                        if overwrite == 0
                            % unmake hourglass pointer for main gui
                            set(vbFRET_data.figure1,'Pointer','arrow');
                            return
                        end

                        % put file components in variable
                        save_data = [(1:length(FRET{n}))' data{n}];

                        % save variable as text
                        fid = fopen(save_name,'w');
                        for i = 1:size(save_data,1);
                            fprintf(fid,'%15d%15.3f%15.3f\n',...
                                save_data(i,1), save_data(i,2), save_data(i,3));
                        end
                        fclose(fid);
                    end

                case 3 % save as one big text file
                    % make file name
                    save_name = fullfile(filePath,[fileName DTstamp '.dat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end
                
                    % add NaNs to the ends of traces to make them all the same
                    % length
                    [data] = equalize_length(data);

                    % save variable as text
                    fid = fopen(save_name,'w');
                    % print labels
                    for i = 1:length(labels)
                        fprintf(fid,' %16s %16s',labels{i},labels{i});
                    end

                    fprintf(fid,'\n');

                    [I J] = size(data);
                    for i = 1:I
                        for j = 1:J
                            fprintf(fid,' %16.3f',data(i,j));
                        end
                        fprintf(fid,'\n');
                    end
                    fclose(fid);
            end
            
%%            
        case 'Save Plots (using settings from main display)'
            if isequal(vbFRET_data.plot.type,'r')
                % must have at least one trace to save
                if check_traces_exist(vbFRET_data.dat,'raw')
                    % unmake hourglass pointer for main gui
                    set(vbFRET_data.figure1,'Pointer','arrow');
                    return
                end
            else
                % must have at least one analyzed trace to save
                if check_traces_exist(vbFRET_data.dat,'x_hat')
                    % unmake hourglass pointer for main gui
                    set(vbFRET_data.figure1,'Pointer','arrow');
                    return
                end
            end

            % gets the data to be saved (loads blur removed if applicable)
            [labels data FRET path path2D N] = get_save_data(vbFRET_data.dat,vbFRET_data.plot,vbFRET_data.analysis.remove_blur);

            % delete any traces that were not idealized if plotting fit data
             if isequal(vbFRET_data.plot.type,'a')
                [labels data FRET path path2D N] = remove_empty(labels, data, FRET, path, path2D);
             end
            
            % put data into structure so it can be plotted
            plot_dat = init_dat;
            plot_dat.labels = labels;
            plot_dat.raw = data;
            plot_dat.FRET = FRET;
            plot_dat.x_hat = [path; path2D];
            plot_opts = vbFRET_data.plot;
            % if blur rm data should be plotted, it was loaded into 'FRET'
            % and 'path', this simplifies the plotting process.
            plot_opts.blur_rm = 0;
            
            % take popup menu value and convert it to actual file extension
            ext = get_ext(saveExt);
           
            % get the number of plots per figure
            [nT nR nC] = get_plot_num(get(handles.nPlots_popupmenu,'Value'));
            
            % make a new figure to save plots with
            fig_hand = figure;

            % in case user saves to a file that exists
            overwrite_all = 0;

            % actual save loop
            for n = 1:N
                % Make new figure every nT traces
                if mod(n,nT) == 1 || nT == 1
                    clf(fig_hand);
                    n1 = n;
                end
                % make subplot
                sub_hand = subplot(nR,nC,1+mod(nT-1+n,nT));
                
                % plot the data using settings from main gui 
                plotFRET(sub_hand, plot_dat, plot_opts, n);

                % modify title
                keff = length(unique(path{n}));
                if isequal(vbFRET_data.plot.type,'r')
                    title(sprintf('%s',labels{n}),'interpreter','none');
                else
                    title(sprintf('%s (%d)',labels{n},keff),'interpreter','none');
                end
                
                % save when all subplots full
                if mod(n,nT) == 0 || n == N
                    
                    save_name = make_plot_name(fileName, filePath, labels, DTstamp, n, n1, nT);
                    
                    % check the file doesn't already exist
                    [overwrite_all overwrite] = name_exists_all([save_name '.' ext],overwrite_all);
                    if overwrite == 0
                        close(fig_hand);
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end
                    saveas(fig_hand,save_name,ext);
                end
            end
            % close figure
            close(fig_hand);
            
%%    
        case 'Save Analysis Summary'
            % must have at least one trace to save
            if isempty(vbFRET_data.fit_par) 
                flag.type = 'saving';
                flag.problem = 'no analysis';
                vbFRETerrors(flag)
                % unmake hourglass pointer for main gui
                set(vbFRET_data.figure1,'Pointer','arrow');
                return
            end

            [vbFRETsummary vbFRETunanalyzed] = get_summary(vbFRET_data.dat,vbFRET_data.fit_par,...
                            vbFRET_data.plot.blur_rm,vbFRET_data.analysis.remove_blur);

            switch saveExt 
                case 1 % save as matlab file
                    % make file name
                    save_name = fullfile(filePath,[fileName DTstamp '.mat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end

                    if isempty(vbFRETunanalyzed)
                        vbFRETunanalyzed = 'All traces were analyzed';
                    end
                        
                    % gets the data to be saved (loads blur removed if applicable)
                    [labels data FRET path path2D N] = get_save_data(vbFRET_data.dat,vbFRET_data.plot,vbFRET_data.analysis.remove_blur);
                    % delete any traces that were not idealized
                    [labels data FRET path path2D N] = remove_empty(labels, data, FRET, path, path2D);

                    %save file
                    save(save_name,'vbFRETsummary','vbFRETunanalyzed','labels','data','FRET','path','path2D');
                    
                case 2 % individual text files
                    %  file name
                    save_name = fullfile(filePath,[fileName DTstamp '.dat']);

                    % check the file doesn't already exist
                    overwrite = name_exists_one(save_name);
                    if overwrite == 0
                        % unmake hourglass pointer for main gui
                        set(vbFRET_data.figure1,'Pointer','arrow');
                        return
                    end
                    
                    % write file
                    fid = fopen(save_name,'w');
                    % get spacing right
                    max_label = length('Label');
                    maxK = 0;
                    for n=1:length(vbFRETsummary)
                        if length(vbFRETsummary{n}.label) > max_label
                            max_label = length(vbFRETsummary{n}.label);
                        end
                        if vbFRETsummary{n}.num_states > maxK
                            maxK = vbFRETsummary{n}.num_states;
                        end
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % funny way of formatting since i don't know how long a line
                    % will be
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    txt_legend = sprintf('Label');
                    for qq = 1:(max_label - length('Label'))
                        txt_legend = sprintf('%s ',txt_legend);
                    end
                    txt_legend = sprintf('%s  Num. States  Log(evidence)  Mean',txt_legend);

                    for qq = 1:(7*maxK - length('Mean'))
                        txt_legend = sprintf('%s ',txt_legend);
                    end

                    txt_legend = sprintf('%s  Stdev',txt_legend);
                    for qq = 1:(7*maxK - length('Stdev'))
                        txt_legend = sprintf('%s ',txt_legend);
                    end

                    % length of all but transition matrix
                    all_but_tm = '';
                    for qq = 1:length(txt_legend);
                        all_but_tm = [all_but_tm ' '];
                    end
                    
                    txt_legend = sprintf('%s  Transition matrix',txt_legend);
                    for qq = 1:(7*maxK - length('Transition matrix'))
                        txt_legend = sprintf('%s ',txt_legend);
                    end
                    line_break = '';
                    for qq = 1:length(txt_legend)
                        line_break = [line_break '-'];
                    end
                    fprintf(fid,'%s\n%s\n',txt_legend,line_break);

                    %write data to file
                    for n=1:length(vbFRETsummary)
                        % label, num states, evidence
                        txt_line = sprintf('%s',vbFRETsummary{n}.label);
                        for qq = 1:(max_label-length(txt_line)+2)
                        	txt_line = sprintf('%s ',txt_line);
                        end                        
                        fprintf(fid,'%s%-13d%-15g',txt_line,vbFRETsummary{n}.num_states,...
                            vbFRETsummary{n}.log_evidence);
                        
                        % means
                        for qq = 1:maxK
                            if qq > vbFRETsummary{n}.num_states
                                fprintf(fid,'%7s','');
                            else
                                if vbFRETsummary{n}.mu(qq) < 0
                                    fprintf(fid,'%0.2f  ',vbFRETsummary{n}.mu(qq));
                                else
                                    fprintf(fid,'%0.3f  ',vbFRETsummary{n}.mu(qq));
                                end
                            end
                        end
                        fprintf(fid,'  ');

                        % stdevs
                        for qq = 1:maxK
                            if qq > vbFRETsummary{n}.num_states
                                fprintf(fid,'%7s','');
                            else
                                fprintf(fid,'%0.3f  ',vbFRETsummary{n}.sigma(qq));
                            end
                        end
                        fprintf(fid,'  ');

                        % transition matrix
                        for zz = 1:vbFRETsummary{n}.num_states
                            if zz > 1
                                fprintf(fid,'%s  ',all_but_tm);
                            end
                            for qq = 1:vbFRETsummary{n}.num_states
                                    fprintf(fid,'%0.3f  ',vbFRETsummary{n}.transition_mtx(zz,qq));
                            end
                            fprintf(fid,'\n');
                        end
                        fprintf(fid,'%s\n',line_break);
                    end

                    if ~isempty(vbFRETunanalyzed)
                        fprintf(fid,'Unanalyzed traces:  ');
                        for qq = 1:length(vbFRETunanalyzed)
                            fprintf(fid,'%s  ',vbFRETunanalyzed{qq});
                            if mod(qq,10) == 0
                                fprintf('\n%20s','');
                            end
                        end
                    end
                    % list blur cleaned traces if applicable
                    if isfield(vbFRETsummary{1},'blur_cleaned')
                        fprintf(fid,'\nBlur cleaned traces:  ');
                        blur_count = 0;
                        for qq = 1:length(vbFRETsummary)
                            if vbFRETsummary{qq}.blur_cleaned == 1
                                blur_count = blur_count + 1;
                                fprintf(fid,'%s  ',vbFRETsummary{qq}.label);
                                if mod(blur_count,10) == 0
                                    fprintf('\n%22s','');
                                end
                            end
                        end
                        if blur_count == 0;
                            fprintf(fid,'No traces were blur cleaned.');
                        end
                    fclose(fid);                    
                    end 
            end
    end
%%
try
catch
    % generic error if for some reason save doesn't work
    flag.type = 'saving';
    flag.problem = 'fail save';
    vbFRETerrors(flag)
    % unmake hourglass pointer for main gui
    set(vbFRET_data.figure1,'Pointer','arrow');
    return
end

% unmake hourglass pointer for main gui
set(vbFRET_data.figure1,'Pointer','arrow');

msgboxText{1} = sprintf('Data saved successfully.');
uiwait(msgbox(msgboxText,'Data Saved Successfully', 'none'));

%put save results gui back on top
ishandle(saveResults);

%%
function cancel_pushbutton_Callback(hObject, eventdata, handles)
% close this gui 
close(saveResults);

%%
function handles = update_popups(saveType, handles)

switch saveType
    case 'Save Session (can continue analysis later)'
        set(handles.saveExt_popupmenu,'Value',1);
        set(handles.saveExt_popupmenu,'String','File Type');
        set(handles.saveExt_popupmenu,'Enable','off');
        set(handles.nPlots_popupmenu,'Value',1);
        set(handles.nPlots_popupmenu,'String','Plots per Figure');
        set(handles.nPlots_popupmenu,'Enable','off');
        
    case 'Save Idealized Traces'
        set(handles.saveExt_popupmenu,'Value',1);
        set(handles.saveExt_popupmenu,'String',{   'Save as Matlab file (.mat)' 
                                                   'Save as individual text files (.dat)'
                                                   'Save as concatenated text file (.dat)'});
        set(handles.saveExt_popupmenu,'Enable','on');
        set(handles.nPlots_popupmenu,'Value',1);
        set(handles.nPlots_popupmenu,'String','Plots per Figure');
        set(handles.nPlots_popupmenu,'Enable','off');
                
    case 'Save Raw Data'
        set(handles.saveExt_popupmenu,'Value',1);
        set(handles.saveExt_popupmenu,'String',{    'Save as Matlab file (.mat)' 
                                                    'Save as individual text files (.dat)'
                                                    'Save as one text file (.dat)' });
        set(handles.saveExt_popupmenu,'Enable','on');
        set(handles.nPlots_popupmenu,'Value',1);
        set(handles.nPlots_popupmenu,'String','Plots per Figure');
        set(handles.nPlots_popupmenu,'Enable','off');

    case 'Save Plots (using settings from main display)'        
        set(handles.saveExt_popupmenu,'Value',1);
        set(handles.saveExt_popupmenu,'String',{   'Save as Adobe Illustrator file (*.ai)'
                                                    'Save as Bitmap file (*.bmp)'
                                                    'Save as EPS file (*.eps)'
                                                    'Save as Matlab figure file (*.fig)'
                                                    'Save as JPEG file (*.jpg)'
                                                    'Save as a PDF file (*.pdf)'
                                                    'Save as Portable Network Graphic file (*.png)'
                                                    'Save as a compressed TIFF image (*.tif)'  });
        set(handles.saveExt_popupmenu,'Enable','on');
        set(handles.nPlots_popupmenu,'Value',1);
        set(handles.nPlots_popupmenu,'String',{ 'Plot 1 Trace per Figure'
                                                'Plot 2 Traces per Figure'
                                                'Plot 4 Traces per Figure'
                                                'Plot 6 Traces per Figure'
                                                'Plot 9 Traces per Figure' });
        set(handles.nPlots_popupmenu,'Enable','on');
        
    case 'Save Analysis Summary'
        set(handles.saveExt_popupmenu,'Value',1);
        set(handles.saveExt_popupmenu,'String',{   'Save as Matlab file (.mat)' 
                                                   'Save as text file (.dat)'  });
        set(handles.saveExt_popupmenu,'Enable','on');
        set(handles.nPlots_popupmenu,'Value',1);
        set(handles.nPlots_popupmenu,'String','Plots per Figure');
        set(handles.nPlots_popupmenu,'Enable','off');
end 

%%
function DTstamp = d_t_stamp(timeStamp,dateStamp)

% add date and time stamp if user desires
d_t = clock;
DTstamp = '';
if dateStamp
    DTstamp = [DTstamp sprintf('_D%02d%02d%02d',d_t(2),d_t(3),d_t(1)-2000)];
end

if timeStamp
    DTstamp = [DTstamp sprintf('_T%02d%02d',d_t(4),d_t(5))];
end

% switch saveType
%     case 'Save Session (can continue analysis later)'
%     case 'Save Idealized Traces'
%    
%     case 'Save Trace and Best Fit Plots'
%    
%     case 'Save Raw Data'
%    
%     case 'Save Plots (using settings from main display)'        
%    
% end


%%
function overwrite = name_exists_one(save_name)

if exist(save_name,'file')
    response = questdlg(sprintf('%s already exists. Do you wish to overwrite it?',save_name), ...
                             'Overwrite Existing File', ...
                             'Yes', 'No', 'No');

    if isequal(response,'Yes')
        overwrite = 1;
    else
        overwrite = 0;
    end
else
    overwrite = 1;
end


%%
function [overwrite_all overwrite] = name_exists_all(save_name,overwrite_all)

% if overwrite_all selected, ignore overwrite question
if overwrite_all
    overwrite_all = 1;
    overwrite = 1;
    return
end

if exist(save_name,'file')

    response = questdlg(sprintf('One or more file names to be saved already exists. Do you wish to overwrite them?'), ...
                             'Overwrite Existing File', ...
                             'Yes', 'No','No');
    switch response
        case 'Yes'
            overwrite_all = 1;
            overwrite = 1;
        case 'No'
            overwrite_all = 0;
            overwrite = 0;
    end
else % if save name doesn't exist then ok to write it
    overwrite_all = 0;
    overwrite = 1;
end

%%
function [labels raw FRET path1D path2D N] = get_save_data(dat,plot,remove_blur) 

N=length(dat.labels);
% relabel numerical traces so they are in order when exported
labels = renumber_labels(dat.labels);


% save non-blur removed data if 'plot blur_rm' is not checked or if blur
% removed states were not analyzed.
if plot.blur_rm == 0 || isempty(dat.raw_db)
    % warn if clean blur checked, but no blur data analyzed yet
    if plot.blur_rm == 1 && remove_blur == 1 && isempty(dat.raw_db)
        flag.type = 'saving';
        flag.problem = 'no cleaned traces';
        vbFRETerrors(flag)
    end
    
    % skip empty data 
    raw = dat.raw; 
    FRET = dat.FRET;
    path1D = dat.x_hat(1,:);
    path2D = dat.x_hat(2,:);
    
% save blur removed data if 'plot blur_rm is checked'
else    
    raw = dat.raw_db;
    FRET = dat.FRET_db;
    path1D = dat.x_hat_db(1,:);
    path2D = dat.x_hat_db(2,:);
    for n=1:length(path2D)
        if isempty(path2D{n})
            path2D{n} = dat.x_hat{2,n};
        end
    end
end

%%
function [labels raw FRET path1D path2D N] = remove_empty(labels, raw, FRET, path1D, path2D) 
% remove cells if no data is fit
for n = length(FRET):-1:1
    if isempty(path1D{n})
        labels(n) = []; 
        raw(n) = [];  
        FRET(n) = [];  
        path1D(n) = [];  
        path2D(n) = []; 
    end
end
N = length(raw);
%%
function labels = renumber_labels(labels)

N = length(labels);
% figure out how many digits to print in the file name so the numbers are
% in alphabetical order
digits = floor(log10(N))+1;

switch digits
    case 1
        for n = 1:N
            if ~isempty(str2num(labels{n}))
                labels{n} = num2str(str2num(labels{n}),'%01d');
            end
        end
    case 2
        for n = 1:N
            if ~isempty(str2num(labels{n}))
                labels{n} = num2str(str2num(labels{n}),'%02d');
            end
        end
    case 3
        for n = 1:N
            if ~isempty(str2num(labels{n}))
                labels{n} = num2str(str2num(labels{n}),'%03d');
            end
        end
    case 4
        for n = 1:N
            if ~isempty(str2num(labels{n}))
                labels{n} = num2str(str2num(labels{n}),'%04d');
            end
        end
    otherwise
        for n = 1:N
            if ~isempty(str2num(labels{n}))
                labels{n} = num2str(str2num(labels{n}),'%05d');
            end
        end
end

%%
function [data] = equalize_length(data)
T = 0;
% find longest trace
for n = 1:length(data)
    t = size(data{n},1);
    if t > T
        T = t;
    end
end

%add NaN's to the ends of traces to make them all T long
for n = 1:length(data)
    if length(data{n}) < T
        data{n} = [data{n}; NaN*ones(T-length(data{n}),2)]; 
    end
end

data = cell2mat(data);

%%
function [nT nR nC] = get_plot_num(nPlots)
% get total number of figurs per plot(nT), number of rows per plot (nP) and
% number of columns per plot (nC)

switch nPlots
    case 1
        nT = 1;
        nR = 1;
        nC = 1;
    case 2
        nT = 2;
        nR = 2;
        nC = 1;        
    case 3
        nT = 4;
        nR = 2;
        nC = 2;
    case 4
        nT = 6;
        nR = 3;
        nC = 2;
    case 5
        nT = 9;
        nR = 3;
        nC = 3;
end

%%
function ext = get_ext(saveExt)
    
switch saveExt
    case 1
        ext = 'ai';
    case 2
        ext = 'bmp';
    case 3
        ext = 'eps';
    case 4
        ext = 'fig';
    case 5
        ext = 'jpg';
    case 6
        ext = 'pdf';
    case 7
        ext = 'png';
    case 8
        ext = 'tif';        
end

%% 
function err = check_traces_exist(dat,check_x_hat)

err = 0;
if isempty(dat.raw)
    flag.type = 'saving';
    flag.problem = 'no traces';
    vbFRETerrors(flag)
    err = 1;
    return
end

if isempty(dat.x_hat{1}) && isequal(check_x_hat,'x_hat')
    flag.type = 'saving';
    flag.problem = 'no x_hat';
    vbFRETerrors(flag)
    err = 1;
    return
end

%%
function save_name = make_plot_name(fileName, filePath, labels, DTstamp, n, n1, nT)

% add _ to the name if fileName isn't blank
if ~isempty(fileName) && ~isequal(fileName(end),'_')
    fileName = [fileName '_'];
end

% figure out how many digits to print in the file name so the numbers are
% in alphabetical order
digits = floor(log10(length(labels)))+1;

% put the correct digits on all possible things that will be labeled
switch digits
    case 1
        n1 = num2str(n1,'%01d');
        nf = num2str(n,'%01d');
        if ~isempty(str2num(labels{n}))
            labels{n} = num2str(str2num(labels{n}),'%01d');
        end
    case 2
        n1 = num2str(n1,'%02d');
        nf = num2str(n,'%02d');
        if ~isempty(str2num(labels{n}))
            labels{n} = num2str(str2num(labels{n}),'%02d');
        end
    case 3
        n1 = num2str(n1,'%03d');
        nf = num2str(n,'%03d');
        if ~isempty(str2num(labels{n}))
            labels{n} = num2str(str2num(labels{n}),'%03d');
        end
    case 4
        n1 = num2str(n1,'%04d');
        nf = num2str(n,'%04d');
        if ~isempty(str2num(labels{n}))
            labels{n} = num2str(str2num(labels{n}),'%04d');
        end
    otherwise
        n1 = num2str(n1,'%05d');
        nf = num2str(n,'%05d');
        if ~isempty(str2num(labels{n}))
            labels{n} = num2str(str2num(labels{n}),'%05d');
        end
end



switch nT
    case 1
        save_name = fullfile(filePath,[fileName labels{n} DTstamp]);
    case 2
        save_name = fullfile(filePath,[fileName n1 '_and_'  nf DTstamp]);
    otherwise
        save_name = fullfile(filePath,[fileName n1 '_to_'  nf DTstamp]);
end
%%
function [vbFRETsummary vbFRETunanalyzed] = get_summary(dat,fit_par,plot_blur,remove_blur);

N = length(dat.z_hat);
% list of traces not analyzed by vbFRET
vbFRETunanalyzed = {};
% cell array to hold summary info
vbFRETsummary = cell(1,N);

% save non-blur removed or blur removed, depending on which settings are
% checked
if plot_blur*remove_blur == 0 
    % non-blur removed data will be used
    z_hat = dat.z_hat;
    out = fit_par.out;
    bestLP = fit_par.bestLP;
    
else    % save blur removed data 
    z_hat = dat.z_hat_db;
    out = cell(1,N);
    bestLP = zeros(1,N);
    
    % only use analyzed traces
    for n=1:N
        if isempty(z_hat{n})
            continue
        end
        
        if isempty(fit_par.out_deblured{n})
            out{n} = fit_par.out{n};
            bestLP(n) = fit_par.bestLP(n);
            % binary value, 1 = trace was blur cleaned, 0 = trace was not blur
            % cleaned - not used here
            vbFRETsummary{n}.blur_cleaned = 0;
        else
            out{n} = fit_par.out_deblured{n};
            bestLP(n) = fit_par.bestLP_deblured(n); 
            vbFRETsummary{n}.blur_cleaned = 1;
        end
    end 
end

% loop to write all output to file
for n = 1:N
    if isempty(z_hat{n})
        vbFRETunanalyzed{length(vbFRETunanalyzed) + 1} = dat.labels{n};
        continue
    end
    % data label
    vbFRETsummary{n}.label = dat.labels{n};
    % number of staes fit to data
    vbFRETsummary{n}.num_states = length(unique(z_hat{n}));
    % log evidence
    vbFRETsummary{n}.log_evidence = bestLP(n);
    % state means
    vbFRETsummary{n}.mu = out{n}.m;
    % state standard deviation (1/(sqrt(W*(v-D-1))
    vbFRETsummary{n}.sigma = zeros(1,vbFRETsummary{n}.num_states);
    for qq = 1:vbFRETsummary{n}.num_states
        vbFRETsummary{n}.sigma(qq) = sqrt(  1/( out{n}.W(qq)*(out{n}.v(qq)-2) )  );
    end
    % transition matrix
    vbFRETsummary{n}.transition_mtx = normalise(out{n}.Wa,2);

end

% delete empty cells
del = zeros(1,length(vbFRETsummary));
for n = 1:N
    if isempty(vbFRETsummary{n})
    del(n) = 1;
    end
end
vbFRETsummary(find(del == 1)) = [];