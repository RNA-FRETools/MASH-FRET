function str_out = getStrPlot_overall(h_fig)
% Return popupmenu string for overall plot in str_out{1} for axes1 and
% str_out{2} for axes2

% update: by RB, 3.1.2018
% >> new variable to expand popupmenu entries
%
% update: by RB, 15.12.2017 
% >> review string in popupmenu of axes 2 for ES hitograms

% get guidata
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

% get variables from the indiviudal project `proj`
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
labels = p.proj{proj}.labels;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
clr = p.proj{proj}.colours;

str_plot = {}; % string for popup menu

% String for Intensity Channels in popup menu
for l = 1:nExc % number of excitation channels
    for c = 1:nChan % number of emission channels
        clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
            round(clr{1}{l,c}(1:3)*255));
        clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{1}{l,c}(1:3) <= 0.5)));
        str_plot = [str_plot ...
            ['<html><span style= "background-color: ' ...
            clr_bg_c ';color: ' clr_fbt_c ';"> ' labels{c} ...
            ' at ' num2str(exc(l)) 'nm</span></html>']];
    end
end

% String for FRET Channels in popup menu
for n = 1:nFRET
    clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
        round(clr{2}(n,1:3)*255));
    clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
        [255 255 255]*sum(double( ...
        clr{2}(n,1:3) <= 0.5)));
    str_plot = [str_plot ['<html><span style= "background-color: '...
        clr_bg_f ';color: ' clr_fbt_f ';">FRET ' labels{FRET(n,1)} ...
        '>' labels{FRET(n,2)} '</span></html>']];
end
% String for Stoichiometry Channels in popup menu
for n = 1:nS
    clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
        round(clr{3}(n,1:3)*255));
    clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
        [255 255 255]*sum(double( ...
        clr{3}(n,1:3) <= 0.5)));
    str_plot = [str_plot ['<html><span style= "background-color: '...
        clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(n)} ...
        '</span></html>']];
end
% String for all Intensity Channels in popup menu 
if nChan > 1 || nExc > 1
    str_plot = [str_plot 'all intensity traces'];
end
% String for all FRET Channels in popup menu
if nFRET > 1
    str_plot = [str_plot 'all FRET traces'];
    dat1.ylabel{size(str_plot,2)} = 'FRET';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
end
% String for all Stoichiometry Channels in popup menu
if nS > 1
    str_plot = [str_plot 'all S traces'];
    dat1.ylabel{size(str_plot,2)} = 'S';
    % no dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
end
% String for all FRET and Stoichiometry Channels in popup menu
if nFRET > 0 && nS > 0
    str_plot = [str_plot 'all FRET & S traces'];
    dat1.ylabel{size(str_plot,2)} = 'FRET or S';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET or S'; % RB 2018-01-04
end
% String for Stoichiometry-FRET Channels in popup menu
% RB 2017-12-15: str_plot including FRET-S-histograms in popupmenu (only corresponding SToichiometry FRET values e.g. FRET:Cy3->Cy5 and S:Cy3->Cy5 not FRET:Cy3->Cy5 and S:Cy3->Cy7 etc.)   )

% corrected by MH, 27.3.2019
%     for s = 1:nS
for fret = 1:nFRET
    for s = 1:nS
        clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
            round(clr{3}(s,1:3)*255));
        clr_bg_e = sprintf('rgb(%i,%i,%i)', ...
            round(clr{2}(fret,1:3)*255));
        clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{3}(s,1:3) <= 0.5)));
        clr_fbt_e = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{2}(fret,1:3) <= 0.5)));
        str_plot =  [str_plot ['<html><span style= "background-color: '...
            clr_bg_e ';color: ' clr_fbt_e ';">FRET ' labels{FRET(fret,1)} ...
            '>' labels{FRET(fret,2)} '</span>-<span style= "background-color: '...
            clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(s)} ...
            '</span></html>']];
    end
end

str_out{1} = str_plot(1:(size(str_plot,2)-nFRET*nS));
str_out{2} = [str_plot(1:(nChan*nExc+nFRET+nS)) ...
    str_plot((size(str_plot,2)-nFRET*nS+1):size(str_plot,2))];

