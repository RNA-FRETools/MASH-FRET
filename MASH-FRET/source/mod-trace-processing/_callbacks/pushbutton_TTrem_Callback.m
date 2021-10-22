function pushbutton_TTrem_Callback(obj, evd, h_fig)

%% Last update by MH, 24.4.2019
% >> adapt code to new molecule tag structure
%
% update by FS, 27.6.2018
% >> adapt code with molecule tags
%
%%

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
incl = p.proj{proj}.coord_incl;
    
if ~h.mute_actions
    del = questdlg('Clear unselected molecules from the project?', ...
        'Clear molecules', 'Yes', 'No', 'No');
    if ~strcmp(del, 'Yes')
        return
    end
end

setContPan('Clear selected molecules from project...','process',h_fig);

if sum(incl)==numel(incl)
    setContPan('Molecule selection empty.','error',h_fig);
    return
else
    rem_mols = find(~incl);
end
if ~isempty(p.proj{proj}.coord)
    p.proj{proj}.coord = p.proj{proj}.coord(incl,:);
end
p.proj{proj}.bool_intensities = p.proj{proj}.bool_intensities(:,incl);

incl_c = reshape(repmat(incl, [nChan,1]),1,nChan*numel(incl));
p.proj{proj}.intensities = p.proj{proj}.intensities(:,incl_c,:);
p.proj{proj}.intensities_bgCorr = ...
    p.proj{proj}.intensities_bgCorr(:,incl_c,:);
p.proj{proj}.intensities_crossCorr = ...
    p.proj{proj}.intensities_crossCorr(:,incl_c,:);
p.proj{proj}.intensities_denoise = ...
    p.proj{proj}.intensities_denoise(:,incl_c,:);
p.proj{proj}.intensities_DTA = p.proj{proj}.intensities_DTA(:,incl_c,:);

if nFRET > 0
    incl_f = reshape(repmat(incl, [nFRET,1]),1,nFRET*numel(incl));
    p.proj{proj}.FRET_DTA = p.proj{proj}.FRET_DTA(:,incl_f);
end

if nS > 0
    incl_s = reshape(repmat(incl, [nS,1]),1,nS*numel(incl));
    p.proj{proj}.S_DTA = p.proj{proj}.S_DTA(:,incl_s);
end

m = 1:numel(incl);
prm_mol = {}; prm_curr = {}; curr_mol = 1;
for i = m(incl)
    prm_mol = [prm_mol p.proj{proj}.TP.prm(i)];
    prm_curr = [prm_curr p.proj{proj}.TP.curr(i)];
    if i == p.curr_mol(proj)
        curr_mol = size(prm_mol,2);
    end
end
p.proj{proj}.TP.prm = prm_mol;
p.proj{proj}.TP.curr = prm_curr;
p.ttPr.curr_mol(proj) = curr_mol;
p.proj{proj}.coord_incl = incl(incl);

% modified by MH, 24.4.2019
%         p.proj{proj}.molTag = p.proj{proj}.molTag(incl); % added by FS, 27.6.2018
p.proj{proj}.molTag = p.proj{proj}.molTag(incl,:);

h.param = p;
guidata(h_fig, h);

ud_TTprojPrm(h_fig);
ud_trSetTbl(h_fig);
updateFields(h_fig, 'ttPr');

str = '';
for i = 1:numel(rem_mols)
    str = cat(2,str,num2str(rem_mols(i)),' ');
end
if numel(rem_mols)>1
    str = cat(2,'Molecules ',str,'have ');
else
    str = cat(2,'Molecule ',str,'has ');
end

setContPan(cat(2,str,'been successfully cleared from the project'),...
    'success',h_fig);

