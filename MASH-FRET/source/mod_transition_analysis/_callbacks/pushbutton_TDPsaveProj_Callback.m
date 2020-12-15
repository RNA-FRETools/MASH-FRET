function pushbutton_TDPsaveProj_Callback(obj, evd, h_fig)
% pushbutton_TDPsaveProj_Callback([],[],h_fig)
% pushbutton_TDPsaveProj_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file name

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    if ~isempty(p.proj{proj}.proj_file)
        projName = p.proj{proj}.proj_file;
    elseif ~isempty(p.proj{proj}.exp_parameters{1,2})
        projName = getCorrName([p.proj{proj}.exp_parameters{1,2} '.mash'], [], ...
            h_fig);
    else
        projName = 'project.mash';
    end
    [pname, projName,o] = fileparts(projName);
    if ~isempty(pname)
        pname = what(pname); % get absolute path
        pname = pname.path;
    end
    defName = [pname filesep projName '.mash'];
    [fname,pname,o] = uiputfile(...
        {'*.mash;','MASH project(*.mash)';'*.*', 'All Files (*.*)'},...
        'Export MASH project',defName);
end

if sum(fname)==0
    return
end

setContPan(['Save project ' fname ' ...'], 'process' , ...
    h_fig);
cd(pname);
[o,fname,o] = fileparts(fname);
fname_proj = getCorrName([fname '.mash'], pname, ...
    h_fig);

if ~sum(fname_proj)
    return
end

% update processing parameters and export settings
dat = p.proj{proj};
dat = rmfield(dat, {'prm', 'exp'});
dat.prmTDP = p.proj{proj}.prm;
dat.expTDP = p.proj{proj}.exp;

% udpdate MASH version and modification date
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);
dat.MASH_version = vers;
dat.date_last_modif = datestr(now);

% update project file and 
dat.proj_file = [pname fname_proj];
p.proj{proj}.proj_file = dat.proj_file;

% save to file
save([pname fname_proj], '-struct', 'dat');

% show action
setContPan(['Project has been successfully saved to file: ' pname ...
    fname_proj], 'success' , h_fig);

% save interface default and current project's new file name
h.param.TDP = p;
guidata(h_fig,h);

