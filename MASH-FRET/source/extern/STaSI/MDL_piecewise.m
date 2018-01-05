function [MDL, eff_fit] = MDL_piecewise(Ij, Tj, G, eff, groups, sd, breaks)
    [Pmj, Im] = pre_calculation(Ij, Tj, G);
    [nG, Ncp] = size(Pmj);% nG: the number of groups; Ncp: the number of 
                          % change points detected
    N = numel(eff);
    V = max(eff)-min(eff);% the space of state values
    eff_fit = zeros(size(eff));% the fitting
    %nk = zeros(1,nG);
    for k = 1:Ncp
        %nk(Pmj(:,k)==1) = nk(Pmj(:,k)==1)+groups(2,k)-groups(1,k)+1;
        eff_fit(groups(1,k):groups(2,k)) = Im*Pmj(:,k);
    end
    F = N*log(sd*sqrt(2*pi)) + 1/2/sd*sum(abs(eff-eff_fit));% the goodness 
                                                            % of the fit
    [lnDET, nb] = the_matrix(eff_fit, breaks, sd);
    G = nG/2*log(1/2/pi)+nG*log(V/sd)+nb/2*log(N)+0.5*lnDET;% the cost of 
                                                            % the model
    MDL = F+G;
end

%% calculate the log determinant of the parameter matrix
function [lnDET, nb] = the_matrix(states, breaks, sd)
    [Z, ~, IZ] = unique(states);
    nz = numel(Z);
    indx = find(diff(IZ)~=0);% indx records the positions of transitions, 
                             % and the period of each stay
    for i = 1:numel(breaks)
        indx(indx == breaks(i)) = [];% these breaks will not be considered
                                     % as a change point
    end
    % lucky, the matrix is diagonal
    nb = numel(indx);
    A = (zeros(1,nz));% the state value part
    D = (zeros(1,nb));% the change-points part
    for i = 1:nz
        A(i) = numel(IZ(IZ==i));% length of each state
    end
    for i = 1:nb
        temp = states(indx(i))-states(indx(i)+1);% the transition value
        D(i) = temp^2;
    end
    lnDET = sum(log([A,D/sd^2]));% let D divide sd here to avoid super
                                 % large/small numbers
end

%% calculate the matrix of assignments (Pmj) and the mean intensity for 
 % each state (Im)
function [Pmj, Im] = pre_calculation(Ij, Tj, G)
    N = numel(Ij);
    n = numel(G.g);
    Pmj = zeros(n, N);
    for i = 1:n
        for j = 1:numel(G.g(i).gg)
            Pmj(i,G.g(i).gg(j))=1;
        end
    end
    Tm = zeros(1,n);
    nm = zeros(1,n);
    Im = zeros(1,n);
    for i = 1:n
        Tm(i) = sum(Pmj(i,:).*Tj);
        nm(i) = sum(Pmj(i,:).*(Ij.*Tj));
        if Tm(i) ~= 0
            Im(i) = nm(i)/Tm(i);
        else
            Im(i) = 0;
        end
    end
end
