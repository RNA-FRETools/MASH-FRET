function lt = calcStateLifetimes(dt,expt)
% lt = calcStateLifetimes(dt,expt)
%
% Estimates state lifetimes from dwell times.
%
% dt: [ndt-by-2] dwell times and state values
% expt: exposure time
% lt: [ndt-by-2] lifetimes and state values

% collects states and dwell times
dwells = dt(:,1)/expt;
states = dt(:,2);

if all(isnan(states))
    lt = dt;
    return
end

% isolates state values
[mu,~,t_mu] = unique(states);
V = numel(mu);

% calculates transition probabilities
Pij = zeros(V,V);
for v1 = 1:V
    for v2 = 1:V
        if v1==v2
            continue
        end
        Pij(v1,v2) = sum(states(1:end-1)==mu(v1) & states(2:end)==mu(v2));
    end
end
for v = 1:V
    Pij(v,v) = sum(dwells(states==mu(v)));
end
Pij = Pij./repmat(sum(Pij,2),1,V);

% calculates transition rate constants
kij = Pij;
kij(~~eye(V)) = 0;
kij = kij/expt;

% calculates state lifetimes
mu_lt = (1./sum(kij,2))';
dt(:,1) = mu_lt(t_mu)';
lt = dt;
