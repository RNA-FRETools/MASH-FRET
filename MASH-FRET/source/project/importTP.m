function p = importTP(p,projs)
% p = importTP(p,projs)
%
% Ensure proper import of input projects' TP processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define molecule processing parameters applied (prm) and to apply (curr)
for i = projs
    if isempty(p.proj{i}.TP)
        continue
    end
    
    % collect experiment settings
    N = numel(p.proj{i}.coord_incl);
    nChan = p.proj{i}.nb_channel;
    exc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;

    % set default processing parameters
    p.ttPr.defProjPrm = setDefPrm_traces(p,i); % interface default
    p.proj{i}.TP.def = p.ttPr.defProjPrm; % project default
    
    % reorder DE coefficients according to laser chronological order
    de_bywl = p.proj{i}.TP.def.general{4}{2};
    if size(de_bywl,2)>0
        for c = 1:nChan
            if sum(exc==chanExc(c))
                exc_but_c = exc(exc~=chanExc(c));
                if isempty(exc_but_c)
                    continue
                end
                [o,id] = sort(exc_but_c,'ascend');
                p.proj{i}.TP.def.general{4}{2}(id,c) = de_bywl(:,c);
            end
        end
    end
    
    % set global TP processing parameters
    if ~isfield(p.proj{i}.TP,'fix')
        p.proj{i}.TP.fix = p.ttPr.defProjPrm.general;
    end
    
    % initializes export options
    if ~isfield(p.proj{i}.TP, 'exp')
        p.proj{i}.TP.exp = [];
    end
    p.proj{i}.TP.exp = setExpOpt(p.proj{i}.TP.exp, p.proj{i});
    
    % initializes applied processing parameters 
    if ~isfield(p.proj{i}.TP, 'prm')
        p.proj{i}.TP.prm = cell(1,N); % empty param. for all mol.
    end
    
    % initializes current processing parameters
    p.proj{i}.TP.curr = cell(1,N);
    
    % adjust curr and prm to current standard
    for n = 1:N 
        if n>size(p.proj{i}.TP.prm,2)
            p.proj{i}.TP.prm{n} = {};
        end

        p.proj{i} = downCompatibilityTP(p.proj{i},n);

        % if size of prm is different from def, use def
        p.proj{i}.TP.curr{n} = adjustVal(p.proj{i}.TP.prm{n}, ...
            p.proj{i}.TP.def.mol);

    end
    p.proj{i}.TP.prm = p.proj{i}.TP.prm(1:N);
    p.proj{i}.TP.curr = p.proj{i}.TP.curr(1:N);
end
