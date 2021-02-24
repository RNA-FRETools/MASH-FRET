function pushbutton_saveProj_Callback(obj, evd, h_fig)
% pushbutton_saveProj_Callback([],[],h_fig)
% pushbutton_saveProj_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file name

h = guidata(h_fig);
pMov = h.param.movPr;
pTP = h.param.ttPr;
pHA = h.param.thm;
pTA = h.param.TDP;
if isempty(pTP.proj)
    return
end

proj = pTP.curr_proj;
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    if ~isempty(pTP.proj{proj}.proj_file)
        projName = pTP.proj{proj}.proj_file;
    elseif ~isempty(pTP.proj{proj}.exp_parameters{1,2})
        projName = getCorrName([pTP.proj{proj}.exp_parameters{1,2} '.mash'], [], ...
            h_fig);
    else
        projName = 'project.mash';
    end
    [pname, projName,o] = fileparts(projName);
    defName = [pname filesep projName '.mash'];
    [fname,pname,o] = uiputfile(...
        {'*.mash;','MASH project(*.mash)';'*.*', 'All Files (*.*)'},...
        'Export MASH project',defName);
end
if sum(fname)==0
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname_proj = getCorrName([fname '.mash'], pname, h_fig);
if ~sum(fname_proj)
    return
end
setContPan(['Save project ' fname_proj ' ...'], 'process' , h_fig);

% update processing parameters and export settings
dat = pTP.proj{proj};
dat = rmfield(dat, {'prm', 'curr', 'exp', 'fix'});
dat.prmTDP = pTA.proj{proj}.prm;
dat.expTDP = pTA.proj{proj}.exp;
dat.fixTT = pTP.proj{proj}.fix;
dat.prmTT = pTP.proj{proj}.prm;
dat.expTT = pTP.proj{proj}.exp;
dat.prmThm = pHA.proj{proj}.prm;
dat.expThm = pHA.proj{proj}.exp;
dat.cnt_p_sec = pTP.proj{proj}.fix{2}(4);
dat.cnt_p_pix = pTP.proj{proj}.fix{2}(5);

% udpdate MASH version and modification date
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);
dat.MASH_version = vers;
dat.date_last_modif = datestr(now);

% update project file and 
dat.proj_file = [pname fname_proj];
pTP.proj{proj}.proj_file = dat.proj_file;
pTP.proj{proj}.date_last_modif = dat.date_last_modif;
pTP.proj{proj}.cnt_p_sec = dat.cnt_p_sec;
pTP.proj{proj}.cnt_p_pix = dat.cnt_p_pix;
pHA.proj{proj}.proj_file = dat.proj_file;
pHA.proj{proj}.date_last_modif = dat.date_last_modif;
pHA.proj{proj}.cnt_p_sec = dat.cnt_p_sec;
pHA.proj{proj}.cnt_p_pix = dat.cnt_p_pix;
pTA.proj{proj}.proj_file = dat.proj_file;
pTA.proj{proj}.date_last_modif = dat.date_last_modif;
pTA.proj{proj}.cnt_p_sec = dat.cnt_p_sec;
pTA.proj{proj}.cnt_p_pix = dat.cnt_p_pix;

% save to file
save([pname fname_proj], '-struct', 'dat');

% show action
setContPan(['Project has been successfully saved to file: ' pname ...
    fname_proj], 'success' , h_fig);

% set interface default param. to project's default param.
pTP.defProjPrm = pTP.proj{proj}.def;

% save current project's cross-talks as default
pTP.defProjPrm.general{4} = pTP.proj{proj}.fix{4};

% added by MH, 24.4.2019
pMov.defTagNames = pTP.proj{proj}.molTagNames;
pMov.defTagClr = pTP.proj{proj}.molTagClr;
chanExc = pTP.proj{proj}.chanExc;
exc = pTP.proj{proj}.excitations;
cf_bywl = pTP.defProjPrm.general{4}{2};
if size(cf_bywl,1)>0
    for c = 1:dat.nb_channel
        if sum(exc==chanExc(c)) % emitter-specific illumination defined and present in used ALEX scheme (DE calculation possible)
            % reorder the direct excitation coefficients according to laser wavelength
            exc_but_c = exc(exc~=chanExc(c));
            if isempty(exc_but_c)
                continue
            end
            [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl
            pTP.defProjPrm.general{4}{2}(:,c) = cf_bywl(id,c);
        end
    end
end

% save interface default and current project's new file name
h.param.movPr = pMov;
h.param.ttpr = pTP;
h.param.thm = pHA;
h.param.TDP = pTA;
guidata(h_fig,h);

