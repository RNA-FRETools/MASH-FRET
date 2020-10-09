function axes_ovrAll_1_ButtonDownFcn(obj,evd,h_fig)

h = guidata(h_fig);

% get project parameters
p = h.param.ttPr;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
inSec = p.proj{proj}.fix{2}(7);
expT = p.proj{proj}.frame_rate; % this is truely the exposure time
incl = p.proj{proj}.bool_intensities;

% get clicked position on axes
pos = get(h.tm.axes_ovrAll_1,'currentpoint');

% get frame at click
l = pos(1);
if inSec
    l = l/expT;
end

% get molecule selection at last update
dat3 = get(h.tm.axes_histSort,'userdata');
mol_slct = dat3.slct;

% determine the corresponding molecule index
L = 0;
M = numel(mol_slct);
for m = 1:M
    if mol_slct(m)
        L = L + sum(incl(:,m))*nExc;
        if L>l
            break;
        end
    end
end
m = m - 1;

% set slider at molecule position & update
mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));
valSld = (M-m)-mol_disp+1;
if valSld<=0
    valSld = 1;
end
set(h.tm.slider,'value',valSld);
slider_Callback(h.tm.slider,[],h_fig);

