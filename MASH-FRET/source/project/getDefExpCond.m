function prm = getDefExpCond(varargin)
% prm = getDefExpCond()
%
% Return default experimental conditions.
%
% prm: {nPrm-by-3} condition's name, value and units

prm = {'Title','new project','';...
    'Molecule','','';...
    '[Mg2+]',[],'mM';...
    '[K+]',[],'mM'};