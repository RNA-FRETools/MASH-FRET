% update photobleaching based gamma correction
% adapted from ud_bleach.m
% last updated: FS, 12.1.2018
function ud_pbGamma(h_fig,h_fig2)

% update calculations
udCalc_pbGamma(h_fig,h_fig2);

% collect project parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
rate = p.proj{proj}.frame_rate;

% collect option parameters
q = guidata(h_fig2);
prm = q.prm{2}(1:6);
cutOff = q.prm{2}(7);

% convert to proper units
if inSec
    cutOff = cutOff*rate;
    prm(3:4) = prm(3:4)*rate;
end
if perSec
    prm(2) = prm(2)/rate;
end

% update GUI
set(q.popupmenu_data, 'Value', prm(1));
set([q.edit_stop,q.edit_threshold,q.edit_extraSubstract,q.edit_minCutoff], ...
    'BackgroundColor', [1,1,1]);
set(q.edit_stop, 'String', num2str(cutOff));
set(q.edit_threshold, 'String', num2str(prm(2)));
set(q.edit_extraSubstract, 'String', num2str(prm(3)));
set(q.edit_minCutoff, 'String', num2str(prm(4)));
set(q.edit_tol, 'String', num2str(prm(6)));
set(q.edit_gamma, 'String', num2str(q.prm{1}));

% update the toolstrings depending on the x-axis unit (frames/s)
if inSec
    set(q.edit_extraSubstract, 'TooltipString', ...
        'Extra time to subtract (s)');
    set(q.edit_minCutoff, 'TooltipString', ...
        'Min. cutoff time (s)');
else
    set(q.edit_extraSubstract, 'TooltipString', ...
        'Extra frames to subtract');
    set(q.edit_minCutoff, 'TooltipString', 'Min. cutoff frame');
end

% update cross
drawCheck(h_fig2);

% plot traces and cutoff
nC = p.proj{proj}.nb_channel;
m = p.ttPr.curr_mol(proj);
fret = p.proj{proj}.TP.fix{3}(8);
don = p.proj{proj}.FRET(fret,1);
acc = p.proj{proj}.FRET(fret,2);
I_a = p.proj{proj}.intensities_denoise(:,(m-1)*nC+acc,prm(1));
incl = p.proj{proj}.bool_intensities(:,m);
clr0 = p.proj{proj}.colours{1};
nExc = p.proj{proj}.nb_excitations;
ldon = find(p.proj{proj}.excitations==p.proj{proj}.chanExc(don));
L = size(I_a,1)*nExc;

x_axis = [(prm(1):nExc:L); (ldon:nExc:L)];
if inSec
    x_axis = x_axis*rate;
    prm(6) = prm(6)*rate;
end
clr{1} = clr0{prm(1),acc};
clr{2} = clr0{ldon,don};
clr{3} = clr0{ldon,acc};

if ~isfield(q,'area_slct')
    q.area_slct = [];
end
q.area_slct = plot_pbGamma(q.axes_traces, x_axis(:,incl'), I_a(incl,:), ...
    q.prm{3}, clr, cutOff, prm(6), q.area_slct);
guidata(h_fig2, q);


