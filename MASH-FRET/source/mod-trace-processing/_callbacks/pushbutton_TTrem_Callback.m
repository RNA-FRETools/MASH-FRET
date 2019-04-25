function pushbutton_TTrem_Callback(obj, evd, h)

%% Last update by MH, 24.4.2019
% >> adapt code to new molecule tag structure
%
% update by FS, 27.6.2018
% >> adapt code with molecule tags
%
%%

if ~isempty(h.param.ttPr.proj)
    del = questdlg('Clear selected molecules from the project?', ...
        'Clear molecule list', 'Yes', 'No', 'No');
    
    if strcmp(del, 'Yes')
        
        setContPan('Clear selected molecules from project...','process',...
            h.figure_MASH);
        
        p = h.param.ttPr;
        proj = p.curr_proj;
        nChan = p.proj{proj}.nb_channel;
        nFRET = size(p.proj{proj}.FRET,1);
        nS = size(p.proj{proj}.S,1);
        
        incl = p.proj{proj}.coord_incl;
        if sum(incl)==numel(incl)
            setContPan('Molecule selection empty.','error',h.figure_MASH);
            return;
        else
            rem_mols = find(~incl);
        end
        if ~isempty(p.proj{proj}.coord)
            p.proj{proj}.coord = p.proj{proj}.coord(incl,:);
        end
        p.proj{proj}.bool_intensities = ...
            p.proj{proj}.bool_intensities(:,incl);
        
        incl_c = reshape(repmat(incl, [nChan,1]),1,nChan*numel(incl));
        p.proj{proj}.intensities = p.proj{proj}.intensities(:,incl_c,:);
        p.proj{proj}.intensities_bgCorr = ...
            p.proj{proj}.intensities_bgCorr(:,incl_c,:);
        p.proj{proj}.intensities_crossCorr = ...
            p.proj{proj}.intensities_crossCorr(:,incl_c,:);
        p.proj{proj}.intensities_denoise = ...
            p.proj{proj}.intensities_denoise(:,incl_c,:);
        p.proj{proj}.intensities_DTA = ...
            p.proj{proj}.intensities_DTA(:,incl_c,:);
        
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
            prm_mol = [prm_mol p.proj{proj}.prm(i)];
            prm_curr = [prm_curr p.proj{proj}.curr(i)];
            if i == p.curr_mol(proj)
                curr_mol = size(prm_mol,2);
            end
        end
        p.proj{proj}.prm = prm_mol;
        p.proj{proj}.curr = prm_curr;
        p.curr_mol(proj) = curr_mol;
        p.proj{proj}.coord_incl = incl(incl);
        
        % modified by MH, 24.4.2019
%         p.proj{proj}.molTag = p.proj{proj}.molTag(incl); % added by FS, 27.6.2018
        p.proj{proj}.molTag = p.proj{proj}.molTag(incl,:);
        
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        
        ud_TTprojPrm(h.figure_MASH);
        ud_trSetTbl(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
        
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
            'success',h.figure_MASH);
    end
end
