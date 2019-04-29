function setSimCoordTable(coord, h_tble)

if ~isempty(coord)
    dat = num2cell(coord);
else
    dat = {};
end

set(h_tble, 'Data', dat);
