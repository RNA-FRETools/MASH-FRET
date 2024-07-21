function popstr = getdefbgcorrpopstr(varargin)
% popstr = getdefbgcorrpopstr
% popstr = getdefbgcorrpopstr(corr)
%
% Returns cell string array containing names of background corrections
% ordered as in the popup menu of TP's panel Background.
%
% corr: index of background correction in popup menu
% popstr: {1-by-M} names of background corrections

popstr = {'Manual', '<N median values>', 'Mean value', 'Most frequent value', ...
    'Histothresh', 'Dark coordinates', 'Median value'};
if ~isempty(varargin)
    popstr = popstr(varargin{1});
end