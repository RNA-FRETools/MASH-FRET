function setSimCoordTable(p, h_tble)
% Display coordinates used in simulation in corrsponding table.
%
% p: structure containing simulation parameters and that must have fields:
%  p.genCoord: coordinates are generated randomly (true) or imported from file (false)
%  p.impPrm: some simulation parameters are imported from a preset file
%  p.molPrm: (only if p.impPrm is true) structure containing parameters imported from presets
%  p.coord: coordinates generated randomly or imported from an ASCII file

% Last update by MH, 6.12.2019
% >> display coordinates improted from preset file (an empty table was 
% being shown)

if p.genCoord
    coord = p.coord;
elseif p.impPrm && isfield(p.molPrm,'coord')
    coord = p.molPrm.coord;
else
    coord = p.coord;
end

if ~isempty(coord)
    dat = num2cell(coord);
else
    dat = {};
end

set(h_tble, 'Data', dat);
