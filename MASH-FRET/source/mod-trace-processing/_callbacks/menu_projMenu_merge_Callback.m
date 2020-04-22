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
    str_proj = ['"' p.proj{slct(1)}.exp_parameters{1,2} '"'];
    for pj = 2:nProj
        str_proj = cat(2,str_proj,', "',...
            p.proj{slct(pj)}.exp_parameters{1,2},'"');
    end
    del = questdlg({cat(2,'Projects ',str_proj,' will be merged into one ',...
        'and removed from the list.'),cat(2,'Changes made to individual ',...
        'source project won''t be saved to the respective files.'),' ',...
        'Do you wish to continue?'},'Merge projects',...
        'No, let me save first','Yes','No, let me save first');
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
fact = [];
for proj = 1:nProj
    % coordinates
    s.coord = cat(1,s.coord,p.proj{proj}.coord);
    
    % molecule selection
    s.coord_incl = cat(2,s.coord_incl,p.proj{proj}.coord_incl);

    % intensities
    s.intensities = cat(2,s.intensities,...
        extendTrace(p.proj{proj}.intensities,L,NaN));
    s.intensities_bgCorr = cat(2,s.intensities_bgCorr,...
        extendTrace(p.proj{proj}.intensities_bgCorr,L,NaN));
    s.intensities_crossCorr = cat(2,s.intensities_crossCorr,...
        extendTrace(p.proj{proj}.intensities_crossCorr,L,NaN));
    s.intensities_denoise = cat(2,s.intensities_denoise,...
        extendTrace(p.proj{proj}.intensities_denoise,L,NaN));
    s.bool_intensities = cat(2,s.bool_intensities,...
        extendTrace(p.proj{proj}.bool_intensities,L,false));
    
    % state sequences
    s.intensities_DTA = cat(2,s.intensities_DTA,...
        extendTrace(p.proj{proj}.intensities_DTA,L,NaN));
    s.FRET_DTA = ...
        cat(2,s.FRET_DTA,extendTrace(p.proj{proj}.FRET_DTA,L,NaN));
    s.S_DTA = cat(2,s.S_DTA,extendTrace(p.proj{proj}.S_DTA,L,NaN));

    % molecule tags
    s.molTag = cat(1,s.molTag,extendTags(p.proj{proj}.molTag,...
        p.proj{proj}.molTagNames,s.molTagNames));

    % correction factors
    N = size(p.proj{proj}.coord_incl,2);
    fact_proj = [];
    for n = 1:N
        if size(p.proj{proj}.prm{n},2)>=6 && ...
                size(p.proj{proj}.prm{n}{6},2)>=1 && ...
                ~isempty(p.proj{proj}.prm{n}{6}{1})
            fact_n = permute(p.proj{proj}.prm{n}{6}{1},[3,2,1]);
        else
            fact_n = ones(N,nFRET,2);
        end
        fact_proj = cat(1,fact_proj,fact_n);
    end
    fact = cat(1,fact,fact_proj);
end
s.bool_intensities = ~~s.bool_intensities;
s.coord_incl = ~~s.coord_incl;

% add merged project to the list
pushbutton_addTraces_Callback([],{s,fact},h_fig);

% close source projects
set(h.listbox_traceSet,'Value',slct);
pushbutton_remTraces_Callback([],[],h_fig,true);


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
    if p_proj{1}.frame_rate~=expT
        errmsg = 'Projects have different frame rate.';
        return
    end
    if p_proj{1}.nb_channel~=nChan
        errmsg = 'Projects have different number of channels.';
        return
    end
    if p_proj{1}.nb_excitations~=nL
        errmsg = 'Projects have different number of lasers.';
        return
    end
    if ~isequal(p_proj{1}.excitations,exc)
        errmsg = 'Projects have different laser wavelength.';
        return
    end
    if ~isequal(p_proj{1}.chanExc,chanExc)
        errmsg = cat(2,'Projects have different emitter-specific ',...
            'excitation wavelength.');
        return
    end
    if ~isequal(p_proj{1}.FRET,FRET)
        errmsg = 'Projects have different FRET pairs.';
        return
    end
    if ~isequal(p_proj{1}.S,S)
        errmsg = 'Projects have different stochiometry calculations.';
        return
    end
    if ~isequal(p_proj{1}.labels,lbls)
        errmsg = 'Projects have different emitter labels.';
        return
    end
    if ~isequal(p_proj{1}.pix_intgr,pixPrm)
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


