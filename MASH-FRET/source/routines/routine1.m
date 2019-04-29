function routine1(h_fig)

h = guidata(h_fig);

% set numbers of molecules
N = [10 50 100 500];

% set PSF standard deviations
o_PSF = [0.1 0.3 0.5 0.8 1];

% set destination directory
[pname,name,o] = fileparts(which(mfilename));
pname = cat(2,pname,filesep,name);

choice = questdlg({cat(2,'This routine will simulate several data sets ',...
    'with increasing number of molecules (',sprintf(repmat(' %i ',...
    [1,numel(N)]),N),') and increasing PSF width (',sprintf(repmat(' %0.1f ',...
    [1,numel(o_PSF)]),o_PSF),').'),cat(2,'Simulated data will be exported',...
    ' to files in directory',pname),'','Do you want to continue?',...
    cat(2,'To write/modify ',name,' see file: ',which(mfilename))},...
    cat(2,'Execute ',name,'?'),'Execute routine','Cancel','Cancel');

if ~strcmp(choice,'Execute routine')
    return;
end

% create destination directory
if ~exist(pname,'dir')
    mkdir(pname);
end
frootname = 'sim_';

% build file names
fname = cell(numel(N),numel(o_PSF));
for p1 = 1:numel(N)
    for p2 = 1:numel(o_PSF)
        fname{p1,p2} = cat(2,frootname,'N',num2str(N(p1)),'_PSF',...
            strrep(num2str(o_PSF(p2)),'.','-'));
    end
end

% activate avi and simulation parameter export
set(h.checkbox_avi,'Value',1);
h = guidata(h_fig);
checkbox_avi_Callback(h.checkbox_avi,[],h);
set(h.checkbox_simParam,'Value',1);
h = guidata(h_fig);
checkbox_simParam_Callback(h.checkbox_simParam,[],h);

% deactivate other export options
set(h.checkbox_dt,'Value',0);
h = guidata(h_fig);
checkbox_dt_Callback(h.checkbox_dt,[],h);
set(h.checkbox_expCoord,'Value',0);
h = guidata(h_fig);
checkbox_expCoord_Callback(h.checkbox_expCoord,[],h);
set(h.checkbox_movie,'Value',0);
h = guidata(h_fig);
checkbox_movie_Callback(h.checkbox_movie,[],h);
set(h.checkbox_procTraces,'Value',0);
h = guidata(h_fig);
checkbox_procTraces_Callback(h.checkbox_procTraces,[],h);
set(h.checkbox_traces,'Value',0);
h = guidata(h_fig);
checkbox_traces_Callback(h.checkbox_traces,[],h);

% set video length to 100
set(h.edit_length,'String','100');
h = guidata(h_fig);
edit_length_Callback(h.edit_length,[],h);

% activate PSF convolution
set(h.checkbox_convPSF,'Value',true);
h = guidata(h_fig);
checkbox_convPSF_Callback(h.checkbox_convPSF, [], h);

% start simulation and export loop
for p1 = 1:numel(N)
    
    % set molecule number
    set(h.edit_nbMol,'String',num2str(N(p1)));
    h = guidata(h_fig);
    edit_nbMol_Callback(h.edit_nbMol, [], h);
    
    % generate state trajectories
    h = guidata(h_fig);
    pushbutton_startSim_Callback(h.pushbutton_startSim, [], h);

    for p2 = 1:numel(o_PSF)
        
        % set PSF widths
        set(h.edit_psfW1,'String',num2str(o_PSF(p2)));
        h = guidata(h_fig);
        edit_psfW1_Callback(h.edit_psfW1, [], h);

        set(h.edit_psfW2,'String',num2str(o_PSF(p2)));
        h = guidata(h_fig);
        edit_psfW2_Callback(h.edit_psfW2, [], h);
        
        % update image
        h = guidata(h_fig);
        pushbutton_updateSim_Callback(h.pushbutton_updateSim, [], h);
        
        % export results
        exportResults(h_fig,cat(2,pname,filesep),fname{p1,p2});
    end
end

