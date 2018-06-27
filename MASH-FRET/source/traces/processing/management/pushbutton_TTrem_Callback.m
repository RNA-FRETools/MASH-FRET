function pushbutton_TTrem_Callback(obj, evd, h)
if ~isempty(h.param.ttPr.proj)
    del = questdlg('Remove unselected molecules from the list?', ...
        'Clear molecule list', 'Yes', 'No', 'No');
    if strcmp(del, 'Yes')
        p = h.param.ttPr;
        proj = p.curr_proj;
        nChan = p.proj{proj}.nb_channel;
        nFRET = size(p.proj{proj}.FRET,1);
        nS = size(p.proj{proj}.S,1);
        
        incl = p.proj{proj}.coord_incl;
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
            incl_f = reshape(repmat(incl, [1,nFRET]),1,nFRET*numel(incl));
            p.proj{proj}.FRET_DTA = p.proj{proj}.FRET_DTA(:,incl_f);
        end
        
        if nS > 0
            incl_s = reshape(repmat(incl, [1,nS]),1,nS*numel(incl));
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
        p.proj{proj}.molTag = p.proj{proj}.molTag(incl); % added by FS, 27.6.2018
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        
        ud_TTprojPrm(h.figure_MASH);
        ud_trSetTbl(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end