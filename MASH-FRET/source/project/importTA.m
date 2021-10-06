function p = importTA(p,projs)
% p = importTA(p,projs)
%
% Ensure proper import of input projects' TA analysis parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define data processing parameters applied (prm)
for i = projs
    
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    nTpe = nChan*nExc + nFRET + nS;
    nTag = numel(p.proj{i}.molTagNames);

    % set default processing parameters
    p.proj{i}.TA.def = setDefPrm_TDP(p.proj{i},p);
    
    % initializes processing parameters
    if ~isfield(p.proj{i}.TA, 'prm')
        p.proj{i}.TA.prm = cell(nTag+1,nTpe);
    end
    
    % initializes export options
    if ~isfield(p.proj{i}.TA, 'exp')
        p.proj{i}.exp = [];
    end
    
    % if the number of data changed, reset results and resize
    if size(p.proj{i}.TA.prm,2)~=(nTpe)
        disp(['Data types changed since last saving: Transition analysis ',...
            'results are reset.']);
        p.proj{i}.TA.prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(p.proj{i}.TA.prm,1)~=(nTag+1)
        disp(['Molecule subgroups changed since last saving: Transition ',...
            'analysis results are reset.']);
        p.proj{i}.TA.prm = cat(1,p.proj{i}.TA.prm(1,:),cell(nTag,nTpe));
    end
    
    p.proj{i}.TA.curr = cell(nTag+1,nTpe);
    for tpe = 1:nTpe
        for tag = 1:(nTag+1)

            p.proj{i} = downCompatibilityTDP(p.proj{i},tpe,tag);

            % if size of already applied parameters is different from
            % defaults, used defaults
            p.proj{i}.TA.curr{tag,tpe} = checkValTDP(p,...
                p.proj{i}.TA.prm{tag,tpe},p.proj{i}.TA.def{tag,tpe});
        end
    end
    
    % initializes current data type, tag and plot
    p.TDP.curr_type(i) = 1;
    p.TDP.curr_tag(i) = 1;
    p.TDP.curr_plot(i) = 1;
end
