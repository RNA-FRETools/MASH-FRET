function FRET = calcFRET(nChan, nExc, allExc, chanExc, p, traces, gamma)
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

% Last update the 17th of April by Mélodie C.A.S. Hadzic
% --> Fix calculations for more than 2 channels and comment code

warning('off','symbolic:solve:DeprecateStringInputWarning');
warning('off','symbolic:sym:sym:DeprecateExpressions');

FRET = [];
nFRET = size(p,1); % number of FRET pairs
L = size(traces,1); % trajectory length

if nFRET > 0 && nExc>=1
    E_eq = cell(nChan);
    donors = (sort(unique(p(:,1)), 'ascend'))';

    for d = donors
        
        % record donor direct excitation for later
        [o,excD,o] = find(allExc == chanExc(d));
        if ~isempty(excD)
            exc(d) = excD;
        end
        
        % initialize transfer matrix (true if transfer after d excitation)
        isE = false(nChan);
        
        % direct transfer donor1->acceptor1
        p_d = p(p(:,1)==d,:);
        
        % consequent transfer acceptor1->acceptor2
        acc = p(p(:,1)==d,2);
        for a = 1:size(acc,1)
            p_d = [p_d;p(p(:,1)==acc(a,1),:)];
        end
        
        % update in transfer matrix
        for f = 1:size(p_d,1)
            isE(p_d(f,1),p_d(f,2)) = true;
        end
        
        % express the transferred intensity in function of I_0, the 
        % fluorescence intensity in absence of transfer 
        q_eq{d} = cell(nChan);
        q_eq{d}(d,d:end) = {'I_0'};
        
        for h = d:nChan % direct (donor1) and indirect (acceptor1) donors
            for i = (h+1):nChan % acceptors
                if isE(h,i)
                    
                    % express intensity absorbed by the acceptor
                    str_q = '';
                    for j = 1:nChan
                        if ~isempty(q_eq{d}{j,h})
                            if strcmp(str_q, '')
                                str_q = strcat(str_q, q_eq{d}{j,h});
                            else
                                str_q = strcat(str_q, '+', q_eq{d}{j,h});
                            end
                        end
                    end
                    
                    % express intensity emitted by the acceptor
                    q_eq{d}(h,i) = {sprintf('(%s)*E_%i%i', str_q, h, i)};
                    
                else
                    % no transfer
                    q_eq{d}(h,i) = {'0'}; 
                end
            end
        end
    end
    
    for d = donors 
        for c = (d+1):nChan % acceptors
            str_I = 'Ic';
            for don = 1:nChan % FRET transfered to c
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
    
    for i = 1:numel(E_eq)
        if ~isempty(E_eq{i})
            E_eq{i} = strrep(char(E_eq{i}), '*', '.*');
            E_eq{i} = strrep(char(E_eq{i}), '/', './');
        end
    end

    E = zeros(L,nChan,nChan);
    
    % from reddest- to greenest-excited donor
    for d = flip(donors,2) % /!\ this assumes that chanel 1,2,3... are 
                           % directly ecxited with increasing wavelength
        if ~isempty(exc(d))
            for c = (d+1):nChan
                if ~isempty(E_eq{d,c})
                    fret = @(Ic,I_0,E) eval(E_eq{d,c});
                    if sum(E(:,d,c) == 0)
                        E(:,d,c) = fret(traces(:,c,exc(d)), ...
                            sum(traces(:,:,exc(d)),2), E);
                        for i = 1:numel(E_eq)
                            if ~isempty(E_eq{i})
                                E_eq{i} = strrep(E_eq{i}, sprintf('E_%i%i', d, c), ...
                                    sprintf('E(:,%i,%i)', d, c));
                            end
                        end
                    end
                end
            end
        end
    end
    for n = 1:nFRET
        FRET(:,n) = E(:,p(n,1),p(n,2));
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

