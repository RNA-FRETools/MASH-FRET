function pushbutton_thm_saveProj_Callback(obj, evd, h_fig)
% pushbutton_thm_saveProj_Callback([],[],h_fig)
% pushbutton_thm_saveProj_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination directory and file

h = guidata(h_fig);
p = h.param.thm;
if isempty(p.proj);
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
        projName = getCorrName([p.proj{proj}.exp_parameters{1,2} ...
            '.mash'], [], h_fig);
    else
        projName = 'project.mash';
    end
    [pName, projName,o] = fileparts(projName);
    defName = [pName filesep projName '.mash'];
    [fname,pname,o] = uiputfile(...
        {'*.mash;', 'MASH project(*.mash)'; ...
         '*.*', 'All Files (*.*)'}, 'Export MASH project', defName);
end
if ~sum(fname)
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

dat = p.proj{proj};
dat = rmfield(dat, {'prm', 'exp'});
dat.prmThm = p.proj{proj}.prm;
dat.expThm = p.proj{proj}.exp;

figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);
dat.MASH_version = vers;

dat.proj_file = [pname fname_proj];
dat.date_last_modif = datestr(now);
save([pname fname_proj], '-struct', 'dat');
setContPan(['Project has been successfully saved to file: ' ...
    pname fname_proj], 'success' , h_fig);

p.proj{proj}.proj_file = dat.proj_file;
h.param.thm = p;
guidata(h_fig,h);

