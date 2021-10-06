function updateActPan(act, h_fig, varargin)
% Obsolete: see setContPan

if ~isempty(varargin)
    setContPan(act, varargin{1}, h_fig);
else
    setContPan(act, '', h_fig);
end



