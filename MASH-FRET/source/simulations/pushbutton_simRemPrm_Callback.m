function pushbutton_simRemPrm_Callback(obj, evd, h)
p = h.param.sim;

if isfield(p.molPrm, 'coord')
    p.genCoord = 1;
elseif ~isempty(p.coord) && isempty(p.coordFile)
    p.genCoord = 0;
    p.molNb = size(p.coord,1);
end

p.PSFw = p.PSFw(1,:);
p.molPrm = [];
p.impPrm = 0;
p.prmFile = [];
p.matGauss = cell(1,4);
h.param.sim = p;

guidata(h.figure_MASH, h);

updateFields(h.figure_MASH, 'sim');