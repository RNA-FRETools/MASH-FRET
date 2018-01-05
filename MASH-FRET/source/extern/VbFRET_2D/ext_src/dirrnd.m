%DIRRND Random vectors from Dirichlet distribution
% GCNU, M J Beal 25/10/1999
%  u = dirrnd(pu,n) returns random vectors from the Dirichlet
%  distribution with parameters specified in row vector 'pu'. If
%  specified, 'n' is the number of samples generated; otherwise a
%  sample for each row of the 'pu' matrix is generated.
%
%  Uses sampling from a gamma distribution: see p.482 of Gelman Carlin
%  Stern & Rubin, Bayesian Data Analysis.

function [samples] = dirrnd(pu,n)

s = size(pu,2);

if nargin < 2
  n = size(pu,1);
else
  if size(pu,1) == 1
    pu = ones(n,1) * pu;
  else
    fprintf('Parameter argument and required samples incommensurate.\n')
    % jbedit break
    return
  end
end

samples = gamrnd(pu,1);
samples = samples ./ (sum(samples,2)*ones(1,s));