function [MDL eff_fit] = discr_stasi(eff, maxN)
%% The main function of the generalized change point algorithm
% Input: 
%       single 1D trace (eff) or multiple traces selected in dialog
% Output:
%       G: structure, recording all the optimum clusterings under different
%   number of states
%       MDL: the minimum discription length, used to determine the optimum
%   number of states
%       states: the fitting based on the optimum number of states
%       eff: group the traces of different data together, if use input eff
%   trace, the output will be identical to the input
%       eff_fit: the fitting of all the feasible number of states, up to 30
%       breaks: recording the separations among different traces
%       output: recording several important parameters for potential usage
%       records: structure, recording the analysis of each loaded trace,
%   and also recording the location of each trace in the output eff
%       excluded: structure, recording all the traces not being used

%% step 1: change-points detection
% load each trace and detect change points
disp('STaSI: Student t test...');
N = numel(eff);
sd = w1_noise(diff(eff))/1.4;% estimate the noise level
points = change_point_detection(eff);% change points detection
groups = [1, points+1; points, N];

%% step 2 and 3: clustering the segments and calculate MDL
disp('STaSI: Grouping...');
[G, Ij, Tj] = clustering_GCP(eff, groups);
G = G(end:-1:1);% flip the G
n_mdl = min(maxN, numel(G));% calculate up to 30 states
MDL = zeros(1,n_mdl);
eff_fit = zeros(n_mdl, N);

disp('STaSI: Determining the optimum number of states...');
for i = 1:n_mdl;
    [MDL(i), eff_fit(i,:)] = MDL_piecewise(Ij, Tj, G(i), eff, groups, ...
        sd, N);
end

% [o, q] = min(MDL);%now the BIC is actually MDL

