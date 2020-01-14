% update photobleaching based gamma correction
% adapted from ud_bleach.m
% last updated: FS, 12.1.2018

function ud_pbGamma(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
m = p.curr_mol(proj);
p_panel = p.proj{proj}.curr{m}{6};

% cutoff parameter
acc = p_panel{2}(2);
start = p_panel{3}(acc,5);
prm = p_panel{3}(acc,2:5);

% collect molecule traces
incl = p.proj{proj}.bool_intensities(:,m);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nChan+1):m*nChan,:);
prm_dta = p.proj{proj}.curr{m}{4};

[I_dta,cutOff,gamma,ok,str] = gammaCorr_pb(acc,I_den,prm,prm_dta,...
    p.proj{proj},h_fig);
if ~ok
    setContPan(str,'warning',h_fig);
end
cutOff = cutOff*nExc;

p.proj{proj}.curr{m}{6}{3}(acc,7) = ok;
p.proj{proj}.curr{m}{6}{3}(acc,6) = cutOff;
if ok
    p.proj{proj}.curr{m}{6}{1}(1,acc) = gamma;
end

% save curr parameters
h.param.ttPr = p;
guidata(h_fig,h);

% update cross
drawCheck(h_fig);

% in frames or in seconds
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
fixIt = p.proj{proj}.fix{2}(6);
inSec = p.proj{proj}.fix{2}(7);
rate = p.proj{proj}.frame_rate;

if inSec
    start = start*rate;
    cutOff = cutOff*rate;
    prm(2:3) = prm(2:3)*rate;
end
if perSec
    prm(1) = prm(1)/rate;
end
if perPix
    nPix = p.proj{proj}.pix_intgr(2);
    prm(1) = prm(1)/nPix;
end

set(h.checkbox_photobl_fixStart, 'Value', fixIt);
set(h.checkbox_photobl_insec, 'Value', inSec);
set(h.edit_photobl_start, 'String', num2str(start));
if fixIt
    set(h.edit_photobl_start, 'Enable', 'inactive');
else
    set(h.edit_photobl_start, 'Enable', 'on');
end

% update edit fields of the cutoff parameters 
set(h.gpo.edit_pbGamma_stop, 'String', num2str(cutOff));
set(h.gpo.edit_pbGamma_threshold, 'String', num2str(prm(1)));
set(h.gpo.edit_pbGamma_extraSubstract, 'String', num2str(prm(2)));
set(h.gpo.edit_pbGamma_minCutoff, 'String', num2str(prm(3)));

% update the toolstrings depending on the x-axis unit (frames/s)
if inSec
    set(h.gpo.edit_pbGamma_extraSubstract, 'TooltipString', ...
        'Extra time to subtract (s)');
    set(h.gpo.edit_pbGamma_minCutoff, 'TooltipString', ...
        'Min. cutoff time (s)');
else
    set(h.gpo.edit_pbGamma_extraSubstract, 'TooltipString', ...
        'Extra frames to subtract');
    set(h.gpo.edit_pbGamma_minCutoff, 'TooltipString', 'Min. cutoff frame');
end


% draws a checkmark or a cross depending if a cutoff is found within the
% trace (i.e intensity of the donor prior to and after the presumed cutoff is different)
function drawCheck(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    acc = p.proj{proj}.curr{mol}{6}{2}(2);
    if p.proj{proj}.curr{mol}{6}{3}(acc,7) == 1
        [icon, ~, alpha] = imread('check.png');
        set(h.gpo.checkbox_showCutoff, 'Enable', 'on')
        set(h.gpo.pushbutton_computeGamma, 'Enable', 'on')
%         drawCutoff(h_fig,1)
    else
        [icon, ~, alpha] = imread('notdefined.png');
        set(h.gpo.checkbox_showCutoff, 'Enable', 'off')
        set(h.gpo.pushbutton_computeGamma, 'Enable', 'off')
%         drawCutoff(h_fig,0)
    end
    drawCutoff(h_fig,p.proj{proj}.curr{mol}{6}{3}(acc,7) & ...
        p.proj{proj}.curr{mol}{6}{3}(acc,1));
    image(icon, 'alphaData', alpha)
    set(gca, 'visible', 'off')
end


% draw the cutoff line; added by FS, 26.4.2018
function drawCutoff(h_fig, drawIt)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
acc = p.proj{proj}.curr{mol}{6}{2}(2);
p.proj{proj}.curr{mol}{6}{3}(acc,1) = drawIt;
set(h.gpo.checkbox_showCutoff, 'Value', drawIt)
h.param.ttPr = p;
guidata(h_fig, h)
% updateFields(h_fig, 'ttPr');

axes.axes_traceTop = h.axes_top;
axes.axes_histTop = h.axes_topRight;
axes.axes_traceBottom = h.axes_bottom;
axes.axes_histBottom = h.axes_bottomRight;
if p.proj{proj}.is_movie && p.proj{proj}.is_coord
    axes.axes_molImg = h.axes_subImg;
end
plotData(mol, p, axes, p.proj{proj}.curr{mol}, 1);
