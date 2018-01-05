function FRET = calcFRET(nChan, nExc, allExc, chanExc, p, traces, gamma)
% Calculate FRET from multiple channel and multiple excitations data
% Adapted from: Lee, Sanghwa, Jinwoo Lee, Sungchul Hohng. « Single-Molecule
% Three-Color FRET with Both Negligible Spectral Overlap and Long 
% Observation Time ». PLoS ONE 5(2010): e12270.
%
% "nChan" >> number of channel
% "nExc" >> number of excitations
% "p" >> [n-by-3] matrix intensity channels and excitation of each FRET
% "traces" >> [N-by-nChan-by-nExc] matrix intensities

% Created the 10th of April 2014 by Mélodie C.A.S. Hadzic
% Last update the 15th of April by Mélodie C.A.S. Hadzic

warning('off','symbolic:solve:DeprecateStringInputWarning');
warning('off','symbolic:sym:sym:DeprecateExpressions');

FRET = [];
nFRET = size(p,1);
N = size(traces,1);

if nFRET > 0 && nExc>=1
    E_eq = cell(nChan);
    donors = (sort(unique(p(:,1)), 'ascend'))';

    for d = donors
        % assign an excitation to each donor
        [o,excD,o] = find(allExc == chanExc(d));
        
        if ~isempty(excD)
            exc(d) = excD;
        end
        
        % build FRET transfer and FRET efficiency matrices
        q_eq{d} = cell(nChan);
        
        isE = false(nChan);
        p_d = p(p(:,1)==d,:);
        acc = p(p(:,1)==d,2);
        for a = size(acc,1)
            p_d = [p_d;p(p(:,1)==acc(a,1),:)];
        end
        for f = 1:size(p_d,1)
            isE(p_d(f,1),p_d(f,2)) = true;
        end
       
        q_eq{d}(d,d:end) = {'I_0'};
        for h = d:nChan % donor (channel==d)
            for i = (h+1):nChan % possible acceptors (channel>d)
                if isE(h,i)
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
                    q_eq{d}(h,i) = {sprintf('(%s)*E_%i%i', str_q, h, i)};
%                 else
%                     q_eq{d}(h,i) = {[]};
                end
            end
        end
    end
    
    for d = donors % from red to green excited donor
        for c = (d+1):nChan
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
%                 syms('Ic', 'I_0', sprintf('E_%i%i', d, c));
%                 E_eq{d,c} = solve(I_eq{d}{c}, sprintf('E_%i%i', d, c));
%                 clear('Ic', 'I_0', sprintf('E_%i%i', d, c));

                symvar1 = sym('Ic');
                symvar2 = sym('I_0');
                symvar3 = sym(sprintf('E_%i%i', d, c));
                E_eq{d,c} = solve(I_eq{d}{c}, symvar3);
                clear('symvar1','symvar2','symvar3');
            end
        end
    end
    
    for i = 1:numel(E_eq)
        if ~isempty(E_eq{i})
            E_eq{i} = strrep(char(E_eq{i}), '*', '.*');
            E_eq{i} = strrep(char(E_eq{i}), '/', './');
        end
    end

    E = zeros(N,nChan,nChan);
    for d = flipdim(donors,2)
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
