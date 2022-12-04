function udCalc_pbGamma(h_fig,h_fig2)

% display action
setContPan(['Detecting acceptor photobleaching and calculating gamma ...',
    'factor...'],'process',h_fig);

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
m = p.ttPr.curr_mol(proj);
fret = p.proj{proj}.TP.fix{3}(8);

q = guidata(h_fig2);
prm = q.prm{2}(1:6);

% collect molecule traces
incl = p.proj{proj}.bool_intensities(:,m);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nChan+1):m*nChan,:);
prm_dta = p.proj{proj}.TP.curr{m}{4};

[I_dta,cutOff,gamma,ok,str] = gammaCorr_pb(fret,I_den,prm,prm_dta,...
    p.proj{proj},h_fig);
if ~ok
    setContPan(str,'warning',h_fig);
end
start = find(incl,1);
cutOff = (start-1+cutOff)*nExc;

q.prm{3} = I_dta;
q.prm{2}(8) = ok;
q.prm{2}(7) = cutOff;
q.prm{1} = round(gamma,2);

% save curr parameters
guidata(h_fig2,q);

if ok
    % display action
    setContPan('Gamma factor was successfully calculated!','success',...
        h_fig);
end

% draws a checkmark or a cross depending if a cutoff is found within the
% trace (i.e intensity of the donor prior to and after the presumed cutoff 
% is different)