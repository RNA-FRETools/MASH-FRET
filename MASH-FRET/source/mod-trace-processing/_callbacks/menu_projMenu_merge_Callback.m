function menu_projMenu_merge_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end
    
% collect selected projects
slct = get(h.listbox_traceSet, 'Value');
nProj = numel(slct);

% check project compatibility
[comp,errmsg] = projectCompatibility(p.proj(slct));
if ~comp
    if h.mute_actions
        disp(cat(2,'Merging is impossible: ',errmsg));
    else
        setContPan(cat(2,'Merging is impossible: ',errmsg),'error',h_fig);
    end
    return
end

% build confirmation message box
if h.mute_actions
    del = 'Yes';
else
    str_proj = p.proj{slct(1)}.exp_parameters{1,2};
    del = questdlg({cat(2,'WARNING 1: The merging process induces a loss ',...
        'of single molecule videos that were used in individual projects.',...
        ' It is therefore recommended to perform all adjustments of ',...
        'molecule positions and background corrections prior merging.'),...
        ' ',cat(2,'WARNING 2: Cross-talk coefficients used in the merged ',...
        'project will be taken from the project "',str_proj,'" only.'),...
        ' ','Do you wish to continue?'},'Merge projects','Yes','Cancel',...
        'Yes');
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

s.movie_file = '';
s.is_movie = false;
s.movie_dim = [];
s.movie_dat = {};

s.nb_channel = p.proj{1}.nb_channel;
s.nb_excitations = p.proj{1}.nb_excitations;
s.excitations = p.proj{1}.excitations;
s.chanExc = p.proj{1}.chanExc;
s.FRET = p.proj{1}.FRET;
s.S = p.proj{1}.S;
nFRET = size(s.FRET,1);
nS = size(s.S,1);
s.exp_parameters = p.proj{1}.exp_parameters;
s.exp_parameters{1,2} = 'merged';
s.labels = p.proj{1}.labels;
s.colours = p.proj{1}.colours;

s.coord_file = '';
s.coord_imp_param = {[1 2] 1};
s.is_coord = false;

s.frame_rate = p.proj{1}.frame_rate;
s.pix_intgr = p.proj{1}.pix_intgr;
s.cnt_p_pix = p.proj{1}.cnt_p_pix;
s.cnt_p_sec = p.proj{1}.cnt_p_sec;

if nFRET>0
    s.ES = cell(1,nFRET);
else
    s.ES = {};
end

s.dt_ascii = false;
s.dt_pname = [];
s.dt_fname = [];
s.dt = {};

L = -Inf;
s.molTagNames = {};
s.molTagClr = {};
for proj = 1:nProj
    % get maximum length
    if size(p.proj{proj}.intensities,1)>L
        L = size(p.proj{proj}.intensities,1);
    end
    
    % concatenate molecule tag names and colors
    for tag = 1:numel(p.proj{proj}.molTagNames)
        if ~sum(~cellfun('isempty',...
                strfind(s.molTagNames,p.proj{proj}.molTagNames{tag})))
            s.molTagNames = ...
                cat(2,s.molTagNames,p.proj{proj}.molTagNames{tag});
            s.molTagClr = cat(2,s.molTagClr,p.proj{proj}.molTagClr{tag});
        end
    end
end

% general parameters
s.fixTT = p.proj{1}.fix;

% concatenate data
s.coord = [];
s.coord_incl = [];
s.intensities = [];
s.intensities_bgCorr = [];
s.intensities_crossCorr = [];
s.intensities_denoise = [];
s.bool_intensities = [];
s.intensities_DTA = [];
s.FRET_DTA = [];
s.S_DTA = [];
s.molTag = [];
s.prmTT = {};
if nFRET==0
    s.FRET_DTA = [];
end
if nS==0
    s.S_DTA = [];
end
for proj = 1:nProj
    % coordinates
    s.coord = cat(1,s.coord,p.proj{proj}.coord);
    N = size(p.proj{proj}.coord_incl,2);
    mols = repmat(1:N,[1,nFRET]);
    
    % molecule selection
    s.coord_incl = cat(2,s.coord_incl,p.proj{proj}.coord_incl);
    
    % laser order
    laserOrder = [];
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
    I = extendTrace(p.proj{proj}.intensities,L,NaN);
    s.intensities = cat(2,s.intensities,I(:,:,laserOrder));
    
    I_bgCorr = extendTrace(p.proj{proj}.intensities_bgCorr,L,NaN);
    s.intensities_bgCorr = ...
        cat(2,s.intensities_bgCorr,I_bgCorr(:,:,laserOrder));
    
    I_crossCorr = extendTrace(p.proj{proj}.intensities_crossCorr,L,NaN);
    s.intensities_crossCorr = ...
        cat(2,s.intensities_crossCorr,I_crossCorr(:,:,laserOrder));
    
    I_denoise = extendTrace(p.proj{proj}.intensities_denoise,L,NaN);
    s.intensities_denoise = ...
        cat(2,s.intensities_denoise,I_denoise(:,:,laserOrder));
    
    s.bool_intensities = cat(2,s.bool_intensities,...
        extendTrace(p.proj{proj}.bool_intensities,L,false));

    % state sequences
    I_DTA = extendTrace(p.proj{proj}.intensities_DTA,L,NaN);
    s.intensities_DTA = cat(2,s.intensities_DTA,I_DTA(:,:,laserOrder));
    
    if nFRET>0
        FRET_DTA = extendTrace(p.proj{proj}.FRET_DTA,L,NaN);
        fret_id = repmat(fretOrder',[1,N]);
        fret_id = reshape((mols-1)*nFRET+fret_id,[1,nFRET*N]);
        s.FRET_DTA = cat(2,s.FRET_DTA,FRET_DTA(:,fret_id));
    end
    
    if nS>0
        S_DTA = extendTrace(p.proj{proj}.S_DTA,L,NaN);
        s_id = repmat(sOrder',[1,N]);
        s_id = reshape((mols-1)*nS+s_id,[1,nS*N]);
        s.S_DTA = cat(2,s.S_DTA,S_DTA(:,s_id));
    end

    % molecule tags
    s.molTag = cat(1,s.molTag,extendTags(p.proj{proj}.molTag,...
        p.proj{proj}.molTagNames,s.molTagNames));
    
    % processing parameters
    N = size(p.proj{proj}.coord_incl,2);
    for n = 1:N
        if ~isempty(p.proj{proj}.prm{n})
            prm_n = rearrangeProcPrm(p.proj{proj}.prm{n},...
                laserOrder,fretOrder,sOrder);
        else
            prm_n = {};
        end
        s.prmTT = cat(2,s.prmTT,prm_n);
    end
end
s.bool_intensities = ~~s.bool_intensities;
s.coord_incl = ~~s.coord_incl;

% add merged project to the list
pushbutton_addTraces_Callback([],{s},h_fig);


function [ok,errmsg] = projectCompatibility(p_proj)

ok = false;
errmsg = '';

nProj = numel(p_proj);
if nProj<=1
    errmsg = 'Only one project is selected.';
    return
end

expT = p_proj{1}.frame_rate;
nChan = p_proj{1}.nb_channel;
nL = p_proj{1}.nb_excitations;
exc = p_proj{1}.excitations;
chanExc = p_proj{1}.chanExc;
FRET = p_proj{1}.FRET;
S = p_proj{1}.S;
lbls = p_proj{1}.labels;
pixPrm = p_proj{1}.pix_intgr;
for proj = 2:nProj
    if p_proj{proj}.frame_rate~=expT
        errmsg = 'Projects have different frame rate.';
        return
    end
    if p_proj{proj}.nb_channel~=nChan
        errmsg = 'Projects have different number of channels.';
        return
    end
    if p_proj{proj}.nb_excitations~=nL
        errmsg = 'Projects have different number of lasers.';
        return
    end
    if ~isequal(sort(p_proj{proj}.excitations),sort(exc))
        errmsg = 'Projects have different laser wavelength.';
        return
    end
    if ~isequal(p_proj{proj}.chanExc,chanExc)
        errmsg = cat(2,'Projects have different emitter-specific ',...
            'excitation wavelength.');
        return
    end
    if ~isequal(sortrows(p_proj{proj}.FRET),sortrows(FRET))
        errmsg = 'Projects have different FRET pairs.';
        return
    end
    if ~isequal(sortrows(p_proj{proj}.S),sortrows(S))
        errmsg = 'Projects have different stochiometry calculations.';
        return
    end
    if ~isequal(p_proj{proj}.labels,lbls)
        errmsg = 'Projects have different emitter labels.';
        return
    end
    if ~isequal(p_proj{proj}.pix_intgr,pixPrm)
        errmsg = cat(2,'Projects have different inetnsity integration ',...
            'parameters.');
        return
    end
end

ok = true;


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
    molTag_ext(:,~cellfun('isempty',strfind(namesRef,names{tag}))) = ...
        molTag(:,tag);
end


function prm = rearrangeProcPrm(prm,laserOrder,fretOrder,sOrder)

nL = numel(laserOrder);
nFRET = numel(fretOrder);
nS = numel(sOrder);
nChan = (size(prm{2}{2},1)-nFRET-nS-2)/nL;

lc = 1:nChan*nL;
lcOrder = [];
for l = 1:nL
    lcOrder = ...
        cat(2,lcOrder,lc(((laserOrder(l)-1)*nChan+1):laserOrder(l)*nChan));
end
datOrder = [fretOrder,nFRET+sOrder,nFRET+nS+lcOrder];

% Photobleaching
chan = prm{2}{1}(3);
if chan<=(nFRET+nS+nL*nChan)
    chan = datOrder(chan);
end
prm{2}{1}(3) = chan;
prm{2}{2}(1:(nFRET+nS+nL*nChan),:) = prm{2}{2}(datOrder,:);

% Background correction
prm{3}{1} = prm{3}{1}(laserOrder,:);
prm{3}{2} = prm{3}{2}(laserOrder,:);
prm{3}{3} = prm{3}{3}(laserOrder,:);
for l = 1:nL % set background to manual
    for c = 1:nChan
        if  prm{3}{1}(l,c)
            prm{3}{3}{l,c}(1,3) = prm{3}{3}{l,c}(prm{3}{2}(l,c),3);
        else
            prm{3}{3}{l,c}(1,3) = 0;
        end
        prm{3}{2}(l,c) = 1;
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


