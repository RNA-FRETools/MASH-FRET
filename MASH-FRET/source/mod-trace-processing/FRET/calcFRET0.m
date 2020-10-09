function FRET = calcFRET0(nChan, nExc, allExc, chanExc, p, traces, gamma)
% Calculate FRET from multiple channel and multiple excitations data
% Adapted from: Lee, Sanghwa, Jinwoo Lee, Sungchul Hohng. « Single-Molecule
% Three-Color FRET with Both Negligible Spectral Overlap and Long 
% Observation Time ». PLoS ONE 5(2010): e12270.
%
% "nChan" >> number of channel
% "nExc" >> number of alternated lasers
% "p" >> [nFRET-by-2] channels of FRET pairs
% "traces" >> [L-by-nChan-by-nExc] single molecule intensities
% "gamma" >> [L-by-nFRET] gamma factors
% "FRET" >> [L-by-nFRET] calculated single molecule FRET data

% Last update 23.5.2019 by MH
% --> correct FRET calculation for multiple acceptors by correcting
%     apparent FRET efficiencies from the presence of other acceptors
%     Back-calculations checked for 3-color FRET with:
%     I_32 = E23*I_02;
%     I_22 = (1-E23)*I_02;
%     I_11 = I_01/(1 + E12/(1-E12) + E13/(1-E13));
%     I_21 = I_11*E12*(1-E23)/(1-E12);
%     I_31 = I_01 - I_21;
%
% update 17.4.2019 by MH
% --> Fix calculations for more than 2 channels and comment code

warning('off','symbolic:solve:DeprecateStringInputWarning');
warning('off','symbolic:sym:sym:DeprecateExpressions');

nFRET = size(p,1); % number of FRET pairs
L = size(traces,1); % trajectory length
FRET = nan(L,nFRET);

if nFRET > 0 && nExc>=1
    E_eq = cell(nChan);
    donors = (sort(unique(p(:,1)), 'ascend'))';
    [o,redtogreen] = sort(chanExc(donors),'descend');
    donors = donors(redtogreen);
    exc = zeros(1,max(donors));
    
    % express transferred intensity Q in function of the fluorescence 
    % intensity in absence of transfer I_0 and apparent FRET
    % efficiencies in presence of multiple acceptors E 
    q_eq = cell(1,max(donors));
    for d = donors
        
        % record donor direct excitation for later
        [o,excD,o] = find(allExc == chanExc(d));
        if ~isempty(excD)
            exc(d) = excD;
        end
        
        % list FRET pairs having directly/subsequently involved in energy transfers
        p_d = p(p(:,1)==d,:); % direct transfers donor->acceptors
        p_d = getSubsqPairs(p_d,p,d); % subsequent transfers acceptor->acceptors

        % fill in transfer matrix (true if transfer occurs at d excitation)
        isE = false(nChan);
        for f = 1:size(p_d,1)
            isE(p_d(f,1),p_d(f,2)) = true;
        end
        
        % express transfer probabilities in function of apparent FRET
        % efficiencies in presence of multiple acceptors E 
        q_eq{d} = cell(nChan);
        for h = d:nChan % direct (donor1) and indirect (acceptor1) donors
            for i =(h+1):nChan % acceptors
                if isE(h,i)
                    % express intensity absorbed by the acceptor
                    if h==d
                        q_eq{d}{h,i} = sprintf('E_%i%i',h,i);
                    else
                        str_q = '';
                        for j = 1:nChan
                            if ~isempty(q_eq{d}{j,h}) && ...
                                    ~strcmp(q_eq{d}{j,h},'0')
                                if isempty(str_q)
                                    str_q = strcat(str_q,q_eq{d}{j,h});
                                else
                                    str_q = strcat(str_q,'+',q_eq{d}{j,h});
                                end
                            end
                        end

                        % express intensity emitted by the acceptor
                        q_eq{d}{h,i} = sprintf('(%s)*E_%i%i',str_q,h,i);
                    end
                    
                else % no energy transferred
                    q_eq{d}{h,i} = '0'; 
                end
            end
        end
        
        % diagonal cells = dye emission
        q_eq{d}{d,d} = '1';
        for h = 1:nChan
            for i = 1:h-1
                if ~isempty(q_eq{d}{i,h}) && ~strcmp(q_eq{d}{i,h},'0')
                    q_eq{d}{h,h} = strcat(q_eq{d}{h,h},q_eq{d}{i,h},'+');
                end
            end
            if ~isempty(q_eq{d}{h,h}) && q_eq{d}{h,h}(end)=='+'
                q_eq{d}{h,h} = q_eq{d}{h,h}(1:end-1);
            end
            for i = h+1:nChan
                if ~(~isempty(q_eq{d}{h,i}) && ~strcmp(q_eq{d}{h,i},'0'))
                    continue
                end
                if isempty(q_eq{d}{h,h}) || (~isempty(q_eq{d}{h,h}) &&...
                        q_eq{d}{h,h}(end)~='-')
                    q_eq{d}{h,h} = strcat(q_eq{d}{h,h},'-');
                end
                q_eq{d}{h,h} = strcat(q_eq{d}{h,h},q_eq{d}{h,i},'-');
            end
            if ~isempty(q_eq{d}{h,h}) && q_eq{d}{h,h}(end)=='-'
                q_eq{d}{h,h} = q_eq{d}{h,h}(1:end-1);
            end
        end
        
        % convert probabilities to intensities
        for i = 1:numel(q_eq{d})
            if ~isempty(q_eq{d}{i}) && ~strcmp(q_eq{d}{i},'0')
                q_eq{d}{i} = strcat('I_0*(',q_eq{d}{i},')');
            end
        end
        
    end
    
    % express apparent FRET efficiencies E
    for d = donors 
        for c = (d+1):nChan % acceptors
            str_I = 'Ic';
            for don = 1:c-1 % FRET transfered to c
                if ~isempty(q_eq{d}{don,c})
                    str_I = strcat(str_I, '-', q_eq{d}{don,c});
                end
            end
            for acc = c+1:nChan % FRET transferred from c
                if ~isempty(q_eq{d}{c,acc})
                    str_I = strcat(str_I, '+', q_eq{d}{c,acc});
                end
            end
            I_eq{d}{c} = str_I;
            if ~isempty(strfind(str_I, sprintf('E_%i%i', d, c)))
                
                % check for Matlab version to use sym variables
                mtlbDat = ver;
                for i = 1:size(mtlbDat,2)
                    if strcmp(mtlbDat(1,i).Name, 'MATLAB')
                        break;
                    end
                end
                
                evar_str = findEelsethan(str_I,sprintf('E_%i%i',d,c));
                
                if str2num(mtlbDat(1,i).Version) >= 9
                    symvrbl(1) = sym('Ic');
                    symvrbl(2) = sym('I_0');
                    symvrbl(3) = sym(sprintf('E_%i%i', d, c));
                    for i_e = 1:size(evar_str,2)
                        symvrbl(3+i_e) = sym(evar_str{i_e});
                    end

                    E_eq{d,c} = solve(str2func(sprintf(...
                        cat(2,'@(%s',repmat(',%s',[1,numel(symvrbl)-1]),...
                        ')%s'),symvrbl,I_eq{d}{c})),symvrbl(3));
                    clear('symvrbl');
                
                else
                    syms('Ic', 'I_0', sprintf('E_%i%i', d, c));
                    for i_e = 1:size(evar_str,2)
                        syms(evar_str{i_e});
                    end
                    
                    E_eq{d,c} = solve(I_eq{d}{c}, sprintf('E_%i%i', d, c));
                    clear('Ic', 'I_0', sprintf('E_%i%i', d, c));
                    for i_e = 1:size(evar_str,2)
                        clear(evar_str{i_e});
                    end
                end
            end
        end
    end
    
    % solve apparent FRET efficiencies E
    for i = 1:numel(E_eq)
        if ~isempty(E_eq{i})
            E_eq{i} = strrep(char(E_eq{i}), '*', '.*');
            E_eq{i} = strrep(char(E_eq{i}), '/', './');
        end
    end
    E = zeros(L,nChan,nChan);
    
    % from reddest- to greenest-excited donor
    for d = donors
        if isempty(exc(d))
            continue
        end
        for c = (d+1):nChan
            if isempty(E_eq{d,c})
                continue
            end
            fret = @(Ic,I_0,E) eval(E_eq{d,c});
            if sum(E(:,d,c)~=0)
                continue
            end
            E(:,d,c) = fret(traces(:,c,exc(d)), ...
                sum(traces(:,:,exc(d)),2), E);
            for i = 1:numel(E_eq)
                if isempty(E_eq{i})
                    continue
                end
                E_eq{i} = strrep(E_eq{i},sprintf('E_%i%i',d,c), ...
                    sprintf('E(:,%i,%i)',d,c));
            end
        end
    end
    
    % solve transferred intensity Q with calculated apparent FRET 
    % efficiencies E
    Q_eq = q_eq{1};
    Q = zeros(L,nChan,nChan);
    d0 = donors(1);
    for d = 1:nChan
        for a = 1:nChan
            if ~isempty(Q_eq{d,a})
                Q_eq{d,a} = strrep(char(Q_eq{d,a}), '*', '.*');
                Q_eq{d,a} = strrep(char(Q_eq{d,a}), '/', './');
                for d2 = flip(donors,2)
                    for a2 = (d2+1):nChan
                        Q_eq{d,a} = strrep(Q_eq{d,a},sprintf('E_%i%i',d2,a2), ...
                            sprintf('E(:,%i,%i)',d2,a2));
                    end
                end
                q_da = @(I_0,E) eval(Q_eq{d,a});
                Q(:,d,a) = q_da(sum(traces(:,:,exc(d0)),2),E);
            end
        end
    end
    
    % calculate true FRET efficiencies (in absence of other acceptors) with
    % transferred intensity Q
    for n = 1:nFRET
        d = p(n,1); a = p(n,2);
        FRET(:,n) = Q(:,d,a)./(Q(:,d,d)+Q(:,d,a));
        FRET(:,n) = FRET(:,n)./(gamma(:,n)-FRET(:,n).*(gamma(:,n)-1));
    end
end
FRET(isnan(FRET))=0;


function E_str = findEelsethan(str,E_exept)

E_str = {};

ind = strfind(str,'E_');
if isempty(ind)
    return;
end

for i = 1:numel(ind);
    Ei_str = str(ind(i):ind(i)+length('_00'));
    intbl = false;
    for j = 1:size(E_str,2)
        if strcmp(E_str{j},Ei_str)
            intbl = true;
        end
    end
    if ~intbl && ~strcmp(Ei_str,E_exept)
        E_str = [E_str,Ei_str];
    end
end


function p_d = getSubsqPairs(p_d,p,d)

% get possible acceptors
acc = p(p(:,1)==d,2);

for a = acc'
    if ~isempty(find(p(:,1),a))
        % add donor-acceptor to list
        p_d = cat(1,p_d,p(p(:,1)==a,:));

        % add possible subsequent pairs
        p_d = getSubsqPairs(p_d,p,a);
    end
end

p_d = unique(p_d,'rows');

