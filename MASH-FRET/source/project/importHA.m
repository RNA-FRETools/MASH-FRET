function p = importHA(p,projs)
% p = importHA(p,projs)
%
% Ensure proper import of input projects' HA processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define data processing parameters applied (prm)
for i = projs
    if isempty(p.proj{i}.HA)
        continue
    end
    
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    allExc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    
    % determine if data are imported from ASCII files
    fromfile = isfield(p.proj{i},'histdat') && ~isempty(p.proj{i}.histdat);
    
    % determines numbers of data and subgroups
    em0 = find(chanExc~=0);
    inclem = true(1,numel(em0));
    for em = 1:numel(em0)
        if ~sum(chanExc(em)==allExc)
            inclem(em) = false;
        end
    end
    em0 = em0(inclem);
    nDE = numel(em0);
    if ~fromfile
        nTpe = 2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS;
    else
        nTpe = 1;
    end
    nTag = numel(p.proj{i}.molTagNames);

    % initializes applied parameters
    if ~isfield(p.proj{i}.HA,'prm')
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end
    
    % initializes export options
    if ~isfield(p.proj{i}.HA,'exp')
        p.proj{i}.HA.exp = [];
    end

    if nTpe>size(p.proj{i}.HA.prm,2)
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end

    % if the number of data changed, reset results and resize
    if size(p.proj{i}.HA.prm,2)~=(nTpe)
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(p.proj{i}.HA.prm,1)~=(nTag+1)
        p.proj{i}.HA.prm = cat(1,p.proj{i}.HA.prm(1,:),cell(nTag,nTpe));
    end
    
    p.proj{i}.HA.def = cell(nTag+1,nTpe);
    p.proj{i}.HA.curr = cell(nTag+1,nTpe);
    for tpe = 1:nTpe
        for tag = 1:(nTag+1)
            if ~fromfile
                [trace,isratio] = collecttrajforhist(p.proj{i},tpe,tag);
                dat = {1,trace};
            else
                dat = {2,p.proj{i}.histdat};
                isratio= false;
            end
            p.proj{i}.HA.def{tag,tpe} = setDefPrm_thm([],dat,isratio,...
                p.thm.colList);
            
            p.proj{i}.HA = downCompatibilityHA(p.proj{i}.HA,tpe,tag);
            
            p.proj{i}.HA.curr{tag,tpe} = setDefPrm_thm(...
                p.proj{i}.HA.prm{tag,tpe},dat,isratio,p.thm.colList);
        end
    end
    
    % initializes current data type, tag and plot
    p.thm.curr_tpe(i) = 1;
    p.thm.curr_tag(i) = 1;
    p.thm.curr_plot(i) = 1;
end

