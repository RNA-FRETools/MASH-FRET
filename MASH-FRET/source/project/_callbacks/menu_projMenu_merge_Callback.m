function menu_projMenu_merge_Callback(obj,evd,h_fig)

% adjust current project index in case it is out of list range (can happen 
% when project import failed)
setcurrproj(h_fig);

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TP')
    return
end
    
% collect selected projects
slct = get(h.listbox_proj, 'Value');

% check project compatibility
[comp,errmsg,splt0,splt,wl,lbl] = projectCompatibility(p.proj(slct),...
    [h.figure_dummy,h.text_dummy],h.mute_actions);
if ~comp
    if h.mute_actions
        disp(cat(2,'Merging is impossible: ',errmsg));
    else
        setContPan(cat(2,'Merging is impossible: ',errmsg),'error',h_fig);
    end
    return
end

% build confirmation message box
diffcrosstalks = false;
if h.mute_actions
    del = 'Yes';
else
    str_proj = p.proj{slct(1)}.exp_parameters{1,2};
    prompt = {'WARNING 1: The merging process induces a loss of single ',...
        'molecule videos that were used in individual projects.',...
        ' It is therefore recommended to perform all adjustments of ',...
        'molecule positions and background corrections prior merging.'};
    
    for i = slct
        if ~(isequal(p.proj{slct(1)}.TP.fix{4}{1},p.proj{i}.TP.fix{4}{1}) ...
                && isequal(p.proj{slct(1)}.TP.fix{4}{2},...
                p.proj{i}.TP.fix{4}{2}))
            diffcrosstalks = true;
            break
        end
    end
    if diffcrosstalks
        prompt = [prompt,' ',['WARNING 2: Cross-talk coefficients used in',...
            ' the merged project will be taken from the project "',...
            str_proj,'" only.']];
    end
    del = questdlg([prompt,' ','Do you wish to continue?'],...
        'Merge projects','Yes','Cancel','Yes');
end

if ~strcmp(del, 'Yes')
    return
end

s.date_creation = datestr(now);
s.date_last_modif = s.date_creation;
s.proj_file = '';
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
s.MASH_version = figname(b:end);
s.module = p.proj{slct(1)}.module;
s.folderRoot = p.proj{slct(1)}.folderRoot;

s.is_movie = false;
s.movie_file = {[]};
s.movie_dim = {[]};
s.movie_dat = {[]};
s.spltime_from_video = p.proj{slct(1)}.spltime_from_video;

s.nb_channel = p.proj{slct(1)}.nb_channel;
s.nb_excitations = p.proj{slct(1)}.nb_excitations;
[~,lasid] = sort(p.proj{slct(1)}.excitations);
s.excitations = wl(lasid);
s.chanExc = p.proj{slct(1)}.chanExc;
s.FRET = p.proj{slct(1)}.FRET;
s.S = p.proj{slct(1)}.S;
nFRET = size(s.FRET,1);
nS = size(s.S,1);
s.exp_parameters = p.proj{slct(1)}.exp_parameters;
s.exp_parameters{1,2} = 'merged';
s.labels = lbl;
s.colours = p.proj{slct(1)}.colours;

s.coord_file = '';
s.coord_imp_param = {[1 2] 1};
s.is_coord = false;

s.sampling_time = splt0;
s.resampling_time = splt;
s.pix_intgr = p.proj{slct(1)}.pix_intgr;
s.cnt_p_sec = p.proj{slct(1)}.cnt_p_sec;
s.time_in_sec = p.proj{slct(1)}.time_in_sec;

if nFRET>0
    s.ES = cell(1,nFRET);
else
    s.ES = {};
end

s.dt_ascii = false;
s.dt_pname = [];
s.dt_fname = [];
s.dt = {};

L0 = -Inf;
L = -Inf;
s.traj_import_opt = [];
s.molTagNames = {};
s.molTagClr = {};
for proj = slct
    % get maximum length
    L0 = max([L0,size(p.proj{proj}.intensities,1)]);
    if p.proj{proj}.resampling_time==splt
        L = max([L,size(p.proj{proj}.intensities_bin,1)]);
    end
    
    % concatenate molecule tag names and colors
    for tag = 1:numel(p.proj{proj}.molTagNames)
        if ~any(cellfun(@(x) isequal(x,p.proj{proj}.molTagNames{tag}),...
                s.molTagNames))
            s.molTagNames = ...
                cat(2,s.molTagNames,p.proj{proj}.molTagNames{tag});
            s.molTagClr = cat(2,s.molTagClr,p.proj{proj}.molTagClr{tag});
        end
    end
end

% general parameters
s.fixTT = p.proj{slct(1)}.TP.fix;

% concatenate data
s.coord = [];
s.coord_incl = [];
s.intensities = [];
s.intensities_bgCorr = [];
s.intensities_bin = [];
s.intensities_crossCorr = [];
s.intensities_denoise = [];
s.bool_intensities = [];
s.emitter_is_on = [];
s.intensities_DTA = [];
s.FRET_DTA = [];
s.FRET_DTA_import = [];
s.S_DTA = [];
s.molTag = [];
s.prmTT = {};
for proj = slct
    % coordinates
    s.coord = cat(1,s.coord,p.proj{proj}.coord);
    N = size(p.proj{proj}.coord_incl,2);
    mols = repmat(1:N,[1,nFRET]);
    
    % molecule selection
    s.coord_incl = cat(2,s.coord_incl,p.proj{proj}.coord_incl);
    
    % laser order
    laserOrder = [];
    [~,lasid] = sort(p.proj{proj}.excitations);
    p.proj{proj}.excitations = wl(lasid);
    for l = 1:s.nb_excitations
        id = find(p.proj{proj}.excitations==s.excitations(l));
        laserOrder = cat(2,laserOrder,id);
    end
    
    % FRET pair order
    fretOrder = [];
    for pair = 1:nFRET
        id = find(p.proj{proj}.FRET(:,1)==s.FRET(pair,1) & ...
            p.proj{proj}.FRET(:,2)==s.FRET(pair,2));
        fretOrder = cat(2,fretOrder,id);
    end
    
    % S pair order
    sOrder = [];
    for pair = 1:nS
        id = find(p.proj{proj}.S(:,1)==s.S(pair,1) & ...
            p.proj{proj}.S(:,2)==s.S(pair,2));
        sOrder = cat(2,sOrder,id);
    end

    % intensities
    I = extendTrace(p.proj{proj}.intensities,L0,NaN);
    s.intensities = cat(2,s.intensities,I(:,:,laserOrder));
    
    I_bgCorr = extendTrace(p.proj{proj}.intensities_bgCorr,L0,NaN);
    s.intensities_bgCorr = ...
        cat(2,s.intensities_bgCorr,I_bgCorr(:,:,laserOrder));
    
    if p.proj{proj}.resampling_time==splt
        I_bin = extendTrace(p.proj{proj}.intensities_bin,L,NaN);
        I_crossCorr = extendTrace(p.proj{proj}.intensities_crossCorr,L,NaN);
        I_denoise = extendTrace(p.proj{proj}.intensities_denoise,L,NaN);
        bool_I = extendTrace(p.proj{proj}.bool_intensities,L,false);
        em_is_on = extendTrace(p.proj{proj}.emitter_is_on,L,false);
        I_DTA = extendTrace(p.proj{proj}.intensities_DTA,L,NaN);
        if nFRET>0
            FRET_DTA = extendTrace(p.proj{proj}.FRET_DTA,L,NaN);
        end
        if nS>0
            S_DTA = extendTrace(p.proj{proj}.S_DTA,L,NaN);
        end
    else
        I_bin = NaN([L,size(s.intensities,[2,3])]);
        I_crossCorr = I_bin;
        I_denoise = I_bin;
        I_DTA = I_bin;
        bool_I = true(L,N);
        em_is_on = true(L,size(I_bin,2));
        if nFRET>0
            FRET_DTA = NaN(L,nFRET);
        end
        if nS>0
            S_DTA = NaN(L,nS);
        end
    end
    s.intensities_bin = cat(2,s.intensities_bin,I_bin(:,:,laserOrder));
    s.intensities_crossCorr = ...
        cat(2,s.intensities_crossCorr,I_crossCorr(:,:,laserOrder));
    s.intensities_denoise = ...
        cat(2,s.intensities_denoise,I_denoise(:,:,laserOrder));
    s.bool_intensities = cat(2,s.bool_intensities,bool_I);
    s.emitter_is_on = cat(2,s.emitter_is_on,em_is_on);
    s.intensities_DTA = cat(2,s.intensities_DTA,I_DTA(:,:,laserOrder));
    if nFRET>0
        fret_id = repmat(fretOrder',[1,N]);
        fret_id = reshape((mols-1)*nFRET+fret_id,[1,nFRET*N]);
        s.FRET_DTA = cat(2,s.FRET_DTA,FRET_DTA(:,fret_id));
        
        FRET_DTA_import = p.proj{proj}.FRET_DTA_import;
        if isempty(FRET_DTA_import)
            FRET_DTA_import = NaN(size(p.proj{proj}.FRET_DTA));
        end
        FRET_DTA_import = extendTrace(FRET_DTA_import,L0,NaN);
        s.FRET_DTA_import = ...
            cat(2,s.FRET_DTA_import,FRET_DTA_import(:,fret_id));
    end
    if nS>0
        s_id = repmat(sOrder',[1,N]);
        s_id = reshape((mols-1)*nS+s_id,[1,nS*N]);
        s.S_DTA = cat(2,s.S_DTA,S_DTA(:,s_id));
    end

    % molecule tags
    s.molTag = cat(1,s.molTag,extendTags(p.proj{proj}.molTag,...
        p.proj{proj}.molTagNames,s.molTagNames));
    
    % processing parameters
    for n = 1:N
        if ~isempty(p.proj{proj}.TP.prm{n})
            prm_n = rearrangeProcPrm(p.proj{proj}.TP.prm{n},...
                laserOrder,fretOrder,sOrder,s.nb_channel);
        else
            prm_n = {};
        end
        s.prmTT = cat(2,s.prmTT,prm_n);
    end
end
s.bool_intensities = ~~s.bool_intensities;
s.emitter_is_on = ~~s.emitter_is_on;
s.coord_incl = ~~s.coord_incl;

% remove VP and/or sim parameters
s.sim = [];
s.VP = [];

% add merged project to the list
pushbutton_openProj_Callback([],{s},h_fig);

% update processing with comon cross talks
if diffcrosstalks
    pushbutton_TP_updateAll_Callback('cross',[],h_fig);
end

% show action
setContPan('Projects successfully merged!','success',h_fig);


function [ok,errmsg,splt0,splt,wl,lbl] = projectCompatibility(proj,h,mute)

% initializes output
ok = false;
errmsg = '';
splt0 = [];
splt = [];
wl = [];
lbl = [];

nProj = numel(proj);
if nProj<=1
    errmsg = 'Only one project is selected.';
    return
end

nChan = proj{1}.nb_channel;
nL = proj{1}.nb_excitations;
exc = proj{1}.excitations;
chanExc = proj{1}.chanExc;
FRET = proj{1}.FRET;
S = proj{1}.S;

[ok,splt0] = checkvidframerate(proj,'sampling_time',mute);
if ~ok
    errmsg = 'Projects have different frame rates.';
    return
end

[ok,splt] = checkvidframerate(proj,'resampling_time',mute);
if ~ok
    errmsg = 'Projects have different resampling times.';
    return
end

ok = false;
for p = 2:nProj
    if proj{p}.nb_channel~=nChan
        errmsg = 'Projects have different number of channels.';
        return
    end
    if proj{p}.nb_excitations~=nL
        errmsg = 'Projects have different number of lasers.';
        return
    end
end

[ok,wl] = checklaserwavelength(proj,h,mute);
if ~ok
    errmsg = 'Projects have different laser wavelengths.';
    return
end
[~,lasid] = sort(exc);
for c = 1:numel(chanExc)
    if chanExc(c)>0
        chanExc(c) = wl(lasid(exc==chanExc(c)));
    end
end

ok = false;
for p = 2:nProj
    [~,lasid] = sort(proj{p}.excitations);
    for c = 1:numel(proj{p}.chanExc)
        if proj{p}.chanExc(c)>0
            proj{p}.chanExc(c) = wl(lasid(proj{p}.excitations==...
                proj{p}.chanExc(c)));
        end
    end
    if ~isequal(proj{p}.chanExc,chanExc)
        errmsg = cat(2,'Projects have different emitter-specific ',...
            'excitation wavelength.');
        return
    end
    if ~isequal(sortrows(proj{p}.FRET),sortrows(FRET))
        errmsg = 'Projects have different FRET pairs.';
        return
    end
    if ~isequal(sortrows(proj{p}.S),sortrows(S))
        errmsg = 'Projects have different stochiometry calculations.';
        return
    end
end

[ok,lbl] = checkemitterlbl(proj,h,mute);
if ~ok
    errmsg = 'Projects have different emitter labels.';
    return
end


function [ok,splt] = checkvidframerate(proj,field,mute)
nProj = numel(proj);
allsplt = zeros(1,nProj);
ok = 1;
for n = 1:nProj
    allsplt(n) = proj{n}.(field);
end

name = strrep('field','_',' ');

splt = allsplt(1);
if ~all(allsplt==allsplt(1)) && ~mute
    strsplt = [];
    for n = 1:nProj
        if n==nProj-1
            strsplt = cat(2,strsplt,num2str(allsplt(n)),' and ');
        else
            strsplt = cat(2,strsplt,num2str(allsplt(n)),', ');
        end
    end
    strsplt = ['(',strsplt(1:end-2),' seconds)'];
    prompt = {['Projects have different video ',name,'s ',strsplt,...
        '.Please define a common ',name,' (in seconds) or abort ',...
        'the merging process:']};
    opts.Interpreter = 'tex';
    dlgtitle = ['Video ',name];
    dims = 1;
    definput = {''};
    answ = inputdlg(prompt,dlgtitle,dims,definput,opts);
    if isempty(answ) || isempty(str2num(answ{1}))
        ok = 0;
    else
        splt = str2num(answ{1});
    end
end


function [ok,wl] = checklaserwavelength(proj,hdl,mute)

% defaults
w = 350;
h = 100;

nProj = numel(proj);
nExc = proj{1}.nb_excitations;
allwl = zeros(nProj,nExc);
ok = 1;
for n = 1:nProj
    allwl(n,:) = sort(proj{n}.excitations);
end
wl = sort(allwl(1,:));
if ~all(all(allwl==repmat(allwl(1,:),nProj,1))) && ~mute
    strwl = cell(1,nProj);
    for n = 1:nProj
        strwl{n} = num2str(allwl(n,:));
    end
    prompt = ['Projects have different laser ',...
        'wavelengths. Please select a common set of wavelengths ',...
        '(in nm) or abort the merging process:'];
    [prompt,~] = wrapStrToWidth(prompt,'points',10,'normal',w,'gui',...
        hdl);
    [id,ok] = listdlg('PromptString',prompt,'ListString',strwl,...
        'SelectionMode','single','ListSize',[w,h]);
    if ok
        wl = allwl(id,:);
    end
end


function [ok,lbl] = checkemitterlbl(proj,hdl,mute)

% defaults
w = 350;
h = 100;

nProj = numel(proj);
nChan = proj{1}.nb_channel;
alllbl = cell(nProj,nChan);
ok = 1;
for n = 1:nProj
    alllbl(n,:) = proj{n}.labels;
end
lbl = alllbl(1,:);
if ~isequal(alllbl,repmat(alllbl(1,:),nProj,1)) && ~mute
    strlbl = cell(1,nProj);
    for n = 1:nProj
        for c = 1:nChan
            strlbl{n} = [strlbl{n},alllbl{n,c},' '];
        end
        strlbl{n} = strlbl{n}(1:end-1);
    end
    prompt = ['Projects have different emitter labels. Please select ',...
        'a common set of labels or abort the merging process:'];
    [prompt,~] = wrapStrToWidth(prompt,'points',10,'normal',w,'gui',...
        hdl);
    [id,ok] = listdlg('PromptString',prompt,'ListString',strlbl,...
        'SelectionMode','single','ListSize',[w,h]);
    if ok
        lbl = alllbl(id,:);
    end
end


function trace = extendTrace(trace,L,val)

if isa(val,'logical')
    if val
        trace = ...
            cat(1,trace,true(L-size(trace,1),size(trace,2),size(trace,3)));
    else
        trace = cat(1,trace,...
            false(L-size(trace,1),size(trace,2),size(trace,3)));
    end
else
    trace = ...
        cat(1,trace,val*ones(L-size(trace,1),size(trace,2),size(trace,3)));
end


function molTag_ext = extendTags(molTag,names,namesRef)

nTag_ref = numel(namesRef);
nTag = numel(names);
molTag_ext = false(size(molTag,1),nTag_ref);
for tag = 1:nTag
    molTag_ext(:,cellfun(@(x) isequal(x,names{tag}),namesRef)) = ...
        molTag(:,tag);
end


function prm = rearrangeProcPrm(prm,laserOrder,fretOrder,sOrder,nChan)

nL = numel(laserOrder);
nFRET = numel(fretOrder);
nS = numel(sOrder);

lc = 1:nChan*nL;
lcOrder = [];
for l = 1:nL
    lcOrder = ...
        cat(2,lcOrder,lc(((laserOrder(l)-1)*nChan+1):laserOrder(l)*nChan));
end
datOrder = [fretOrder,nFRET+sOrder,nFRET+nS+lcOrder];

% Background correction
prm{3}{1} = prm{3}{1}(laserOrder,:,:); % apply & dynamic
prm{3}{2} = prm{3}{2}(laserOrder,:); % method
prm{3}{3} = prm{3}{3}(laserOrder,:); % parameters
for l = 1:nL % set unique background correction
    for c = 1:nChan
        if  ~prm{3}{1}(l,c,1) % apply
            prm{3}{3}{l,c}(1,3) = 0;
            prm{3}{2}(l,c) = 1;
        end
        prm{3}{3}{l,c} = prm{3}{3}{l,c}(prm{3}{2}(l,c),:);
    end
end

% Find states
prm{4}{2} = prm{4}{2}(:,:,datOrder); % parameters
prm{4}{3} = prm{4}{3}(datOrder,:);  % states values
prm{4}{4} = prm{4}{4}(:,:,datOrder); % thresholds

% Correction factors
prm{6}{1} = prm{6}{1}(:,fretOrder); % factors
prm{6}{2} = prm{6}{2}(fretOrder);  % method 
prm{6}{3} = prm{6}{3}(fretOrder,:); % acc-pb parameters
prm{6}{4} = prm{6}{4}(fretOrder,:); % ES-regression parameters
for pair = 1:nFRET % set method to manual
    prm{6}{2}(pair) = 0;
end

prm = {prm};


