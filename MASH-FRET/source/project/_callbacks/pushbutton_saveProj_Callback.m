function pushbutton_saveProj_Callback(obj, evd, h_fig)
% pushbutton_saveProj_Callback([],[],h_fig)
% pushbutton_saveProj_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file name

h = guidata(h_fig);
p = h.param;
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
    projfile = p.proj{proj}.proj_file;
    projtitle = p.proj{proj}.exp_parameters{1,2};
    rootfolder = p.proj{proj}.folderRoot;
    if ~isempty(projfile)
        [pname,projName,~] = fileparts(projfile);
    elseif ~isempty(projtitle)
        projName = getCorrName([projtitle,'.mash'],[],h_fig);
        [~,projName,~] = fileparts(projName);
        pname = rootfolder;
    else
        projName = 'project';
        pname = rootfolder;
    end
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
dat = p.proj{proj};
if ~isempty(p.proj{proj}.TP)
    dat.cnt_p_sec = p.proj{proj}.TP.fix{2}(4);
    dat.cnt_p_pix = p.proj{proj}.TP.fix{2}(5);
end

% udpdate MASH version and modification date
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);
dat.MASH_version = vers;
dat.date_last_modif = datestr(now);
dat.module = p.curr_mod{proj};

% update project file, date and intensity units
dat.proj_file = [pname fname_proj];
p.proj{proj}.proj_file = dat.proj_file;
p.proj{proj}.date_last_modif = dat.date_last_modif;
p.proj{proj}.cnt_p_sec = dat.cnt_p_sec;
p.proj{proj}.cnt_p_pix = dat.cnt_p_pix;

% save to file
save([pname fname_proj], '-struct', 'dat');

% show action
setContPan(['Project has been successfully saved to file: ' pname ...
    fname_proj], 'success' , h_fig);

% set interface default param. to project's param.
if ~isempty(p.proj{proj}.sim)
    p.sim.defProjPrm = p.proj{proj}.sim.curr;
    p.sim.defProjPrm.res_dt = p.proj{proj}.sim.def.res_dt;
    p.sim.defProjPrm.res_dat = p.proj{proj}.sim.def.res_dat;
    p.sim.defProjPrm.res_plot = p.proj{proj}.sim.def.res_plot;
end
if ~isempty(p.proj{proj}.VP)
    p.VP.defProjPrm = p.proj{proj}.VP.curr;
    p.VP.defProjPrm.res_crd = p.proj{proj}.VP.def.res_crd;
    p.VP.defProjPrm.res_plot = p.proj{proj}.VP.def.res_plot;
end
if ~isempty(p.proj{proj}.TP)
    p.ttPr.defProjPrm = p.proj{proj}.TP.def;
end
if ~isempty(p.proj{proj}.HA)
    p.thm.defProjPrm = p.proj{proj}.HA.def;
end
if ~isempty(p.proj{proj}.TA)
    p.TDP.defProjPrm = p.proj{proj}.TA.def;
end
p.es = setExpSetFromProj(dat);

if ~isempty(p.proj{proj}.TP)
    % save current project's cross-talks as default
    p.ttPr.defProjPrm.general{4} = p.proj{proj}.TP.fix{4};

    % reorder DE coefficients according to laser chromatic order
    chanExc = p.proj{proj}.chanExc;
    exc = p.proj{proj}.excitations;
    cf_bywl = p.ttPr.defProjPrm.general{4}{2};
    if size(cf_bywl,1)>0
        for c = 1:dat.nb_channel
            if sum(exc==chanExc(c))
                exc_but_c = exc(exc~=chanExc(c));
                if isempty(exc_but_c)
                    continue
                end
                [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl
                p.ttPr.defProjPrm.general{4}{2}(:,c) = cf_bywl(id,c);
            end
        end
    end
end

% save interface default and current project's new file name
h.param = p;
guidata(h_fig,h);

