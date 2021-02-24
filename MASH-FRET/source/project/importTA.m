function p = importTA(p,dat,h_fig)
% p = importTA(p,dat,h_fig)
%
% p: structure containing parameters for Transition analysis interface
% dat: structure containing project data
% h_fig: handle to main figure

% add project to list
p.proj = [p.proj dat];

% define data processing parameters applied (prm)
for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
    
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    nTpe = nChan*nExc + nFRET + nS;
    nTag = numel(p.proj{i}.molTagNames);
    
    p.curr_type(i) = 1;
    p.curr_tag(i) = 1;

    p.proj{i}.def = setDefPrm_TDP(p,i);

    if ~isfield(p.proj{i}, 'prmTDP')
        p.proj{i}.prm = cell(nTag+1,nTpe);
    else
        p.proj{i}.prm = p.proj{i}.prmTDP;
        p.proj{i} = rmfield(p.proj{i}, 'prmTDP');
    end
    if ~isfield(p.proj{i}, 'expTDP')
        p.proj{i}.exp = [];
    else
        p.proj{i}.exp = p.proj{i}.expTDP;
        p.proj{i} = rmfield(p.proj{i}, 'expTDP');
    end
    
    % if the number of data changed, reset results and resize
    if size(p.proj{i}.prm,2)~=(nTpe)
        disp(['Data types changed since last saving: Transition analysis ',...
            'results are reset.']);
        p.proj{i}.prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(p.proj{i}.prm,1)~=(nTag+1)
        disp(['Molecule subgroups changed since last saving: Transition ',...
            'analysis results are reset.']);
        p.proj{i}.prm = cat(1,p.proj{i}.prm(1,:),cell(nTag,nTpe));
    end
    
    p.proj{i}.curr = cell(nTag+1,nTpe);
    for tpe = 1:nTpe
        for tag = 1:(nTag+1)

            p.proj{i} = downCompatibilityTDP(p.proj{i},tpe,tag);

            % if size of already applied parameters is different from
            % defaults, used defaults
            p.proj{i}.curr{tag,tpe} = checkValTDP(p,p.proj{i}.prm{tag,tpe},...
                p.proj{i}.def{tag,tpe});
        end
    end
end
