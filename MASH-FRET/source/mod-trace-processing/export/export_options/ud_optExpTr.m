function ud_optExpTr(opt, h_fig)

% Last update, 10.4.2019 by MH: (1) set edit fields with empty strings and checkboxes unchecked when main export options are deactivated (2) set checkboxes for trace options to unchecked when formats other than "custommed format" are used and prevent the selection of the option "external file(.log)" for processing parameters export

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.TP.exp;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
perSec = p.proj{proj}.TP.fix{2}(4);
perPix = p.proj{proj}.TP.fix{2}(5);

set(h.optExpTr.checkbox_molValid, 'Value', prm.mol_valid);
if prm.mol_valid
    set(h.optExpTr.checkbox_molValid, 'ForegroundColor', [0 0 1]);
else
    set(h.optExpTr.checkbox_molValid, 'ForegroundColor', [0 0 0]);
end

if strcmp(opt, 'tr') || strcmp(opt, 'all')
    
    set(h.optExpTr.radiobutton_saveTr, 'Value', prm.traces{1}(1));
    set(h.optExpTr.radiobutton_noTr, 'Value', ~prm.traces{1}(1));
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.popupmenu_trFmt, 'Value', prm.traces{1}(2));
%     dat_txt = get(h.optExpTr.text_trInfos, 'UserData');
%     set(h.optExpTr.text_trInfos, 'String', dat_txt(prm.traces{1}(2)));
%     set(h.optExpTr.checkbox_trI, 'Value', prm.traces{2}(1));
%     set(h.optExpTr.checkbox_trFRET, 'Value', prm.traces{2}(2));
%     set(h.optExpTr.checkbox_trS, 'Value', prm.traces{2}(3));
%     set(h.optExpTr.checkbox_trAll, 'Value', prm.traces{2}(4));
%     set(h.optExpTr.popupmenu_trPrm, 'Value', prm.traces{2}(5));
%     set(h.optExpTr.checkbox_gam, 'Value', prm.traces{2}(6));  % added by FS, 4.4.2017
    
    if prm.traces{1}(1)
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.popupmenu_trFmt, 'Value', prm.traces{1}(2));
        dat_txt = get(h.optExpTr.text_trInfos, 'UserData');
        set(h.optExpTr.text_trInfos, 'String', dat_txt(prm.traces{1}(2)));
        set(h.optExpTr.checkbox_trI, 'Value', prm.traces{2}(1));
        set(h.optExpTr.checkbox_trFRET, 'Value', prm.traces{2}(2));
        set(h.optExpTr.checkbox_trS, 'Value', prm.traces{2}(3));
        set(h.optExpTr.checkbox_trAll, 'Value', prm.traces{2}(4));
        set(h.optExpTr.popupmenu_trPrm, 'Value', prm.traces{2}(5));
        set(h.optExpTr.checkbox_gam, 'Value', prm.traces{2}(6));  % added by FS, 4.4.2017
        
        set(h.optExpTr.radiobutton_saveTr, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noTr, 'FontWeight', 'normal');
        set([h.optExpTr.text_trFmt h.optExpTr.popupmenu_trFmt ...
            h.optExpTr.text_tr2exp h.optExpTr.text_trInfos ...
            h.optExpTr.checkbox_gam h.optExpTr.text_trPrm ...
            h.optExpTr.popupmenu_trPrm],'Enable', 'on');
        if sum(double(prm.traces{1}(2) == [1 7])) % ASCII or all
            set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
                h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll], ...
                'Enable', 'on');
        else
            % modified by MH, 10.4.2019
%             set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
%                 h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll], ...
%                 'Enable', 'off');
            set(h.optExpTr.checkbox_trI,'Value',1,'Enable','off');
            set([h.optExpTr.checkbox_trFRET h.optExpTr.checkbox_trS ...
                h.optExpTr.checkbox_trAll],'Value', 0, 'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveTr, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noTr, 'FontWeight', 'bold');
        set([h.optExpTr.text_trFmt h.optExpTr.popupmenu_trFmt ...
            h.optExpTr.text_tr2exp h.optExpTr.text_trInfos ...
            h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
            h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll ...
            h.optExpTr.checkbox_gam h.optExpTr.text_trPrm ...
            h.optExpTr.popupmenu_trPrm],'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
            h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll ...
            h.optExpTr.checkbox_gam], 'Value', 0);
    end
    if ~nFRET
        set([h.optExpTr.checkbox_trFRET h.optExpTr.checkbox_gam], ...
            'Enable','off');
    end
    if ~nS
        set(h.optExpTr.checkbox_trS, 'Enable', 'off');
    end
    if nS + nFRET == 0
        set(h.optExpTr.checkbox_trAll, 'Enable', 'off');
    end
end

if strcmp(opt, 'hist') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveHist, 'Value', prm.hist{1}(1));
    set(h.optExpTr.radiobutton_noHist, 'Value', ~prm.hist{1}(1));
    
    % cancel by MH, 10.4.2019
%     set(h.optExpTr.checkbox_histDiscr, 'Value', prm.hist{1}(2));
%     set(h.optExpTr.checkbox_histI, 'Value', prm.hist{2}(1,1));
%     perSec = h.param.proj{h.param.curr_proj}.fix{2}(4);
%     perPix = h.param.proj{h.param.curr_proj}.fix{2}(5);
%     if perSec
%         rate = h.param.proj{h.param.curr_proj}.frame_rate;
%         prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/rate;
%     end
%     if perPix
%         nPix = h.param.proj{h.param.curr_proj}.pix_intgr(2);
%         prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/nPix;
%     end
%     set(h.optExpTr.edit_minI, 'String', num2str(prm.hist{2}(1,2)));
%     set(h.optExpTr.edit_binI, 'String', num2str(prm.hist{2}(1,3)));
%     set(h.optExpTr.edit_maxI, 'String', num2str(prm.hist{2}(1,4)));
%     set(h.optExpTr.checkbox_histFRET, 'Value', prm.hist{2}(2,1));
%     set(h.optExpTr.edit_minFRET, 'String', num2str(prm.hist{2}(2,2)));
%     set(h.optExpTr.edit_binFRET, 'String', num2str(prm.hist{2}(2,3)));
%     set(h.optExpTr.edit_maxFRET, 'String', num2str(prm.hist{2}(2,4)));
%     set(h.optExpTr.checkbox_histS, 'Value', prm.hist{2}(3,1));
%     set(h.optExpTr.edit_minS, 'String', num2str(prm.hist{2}(3,2)));
%     set(h.optExpTr.edit_binS, 'String', num2str(prm.hist{2}(3,3)));
%     set(h.optExpTr.edit_maxS, 'String', num2str(prm.hist{2}(3,4)));
    
    
    if prm.hist{1}(1)
        
        set(h.optExpTr.radiobutton_saveHist, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noHist, 'FontWeight', 'normal');
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.checkbox_histDiscr, 'Value', prm.hist{1}(2));
        set(h.optExpTr.checkbox_histI, 'Value', prm.hist{2}(1,1));
        if perSec
            prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/expT;
        end
        if perPix
            prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/nPix;
        end
        set(h.optExpTr.edit_minI, 'String', num2str(prm.hist{2}(1,2)));
        set(h.optExpTr.edit_binI, 'String', num2str(prm.hist{2}(1,3)));
        set(h.optExpTr.edit_maxI, 'String', num2str(prm.hist{2}(1,4)));
        set(h.optExpTr.checkbox_histFRET, 'Value', prm.hist{2}(2,1));
        set(h.optExpTr.edit_minFRET, 'String', num2str(prm.hist{2}(2,2)));
        set(h.optExpTr.edit_binFRET, 'String', num2str(prm.hist{2}(2,3)));
        set(h.optExpTr.edit_maxFRET, 'String', num2str(prm.hist{2}(2,4)));
        set(h.optExpTr.checkbox_histS, 'Value', prm.hist{2}(3,1));
        set(h.optExpTr.edit_minS, 'String', num2str(prm.hist{2}(3,2)));
        set(h.optExpTr.edit_binS, 'String', num2str(prm.hist{2}(3,3)));
        set(h.optExpTr.edit_maxS, 'String', num2str(prm.hist{2}(3,4)));

        set([h.optExpTr.text_hist2exp h.optExpTr.text_min ...
            h.optExpTr.text_bin h.optExpTr.text_max ...
            h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS], ...
            'Enable', 'on');
        if prm.hist{2}(1,1) % intensities
            set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
                h.optExpTr.edit_maxI], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
                h.optExpTr.edit_maxI], 'Enable', 'off');
        end
        if prm.hist{2}(2,1) % FRET
            set([h.optExpTr.edit_minFRET h.optExpTr.edit_binFRET ...
                h.optExpTr.edit_maxFRET], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minFRET h.optExpTr.edit_binFRET ...
                h.optExpTr.edit_maxFRET], 'Enable', 'off');
        end
        if prm.hist{2}(3,1) % S
            set([h.optExpTr.edit_minS h.optExpTr.edit_binS ...
                h.optExpTr.edit_maxS], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minS h.optExpTr.edit_binS ...
                h.optExpTr.edit_maxS], 'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveHist, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noHist, 'FontWeight', 'bold');
        set([h.optExpTr.text_hist2exp h.optExpTr.text_min ...
            h.optExpTr.text_bin h.optExpTr.text_max ...
            h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS ...
            h.optExpTr.edit_minI h.optExpTr.edit_binI ...
            h.optExpTr.edit_maxI h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET ...
            h.optExpTr.edit_minS h.optExpTr.edit_binS ...
            h.optExpTr.edit_maxS], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS],...
            'Value',0);
        set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
            h.optExpTr.edit_maxI h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET ...
            h.optExpTr.edit_minS h.optExpTr.edit_binS ...
            h.optExpTr.edit_maxS],'String','');
    end
    if ~nFRET
        set([h.optExpTr.checkbox_histFRET h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET], 'Enable', ...
            'off');
    end
    if ~nS
        set([h.optExpTr.checkbox_histS h.optExpTr.edit_minS ...
            h.optExpTr.edit_binS h.optExpTr.edit_maxS], 'Enable', 'off');
    end
end

if strcmp(opt, 'dt') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveDt, 'Value', prm.dt{1});
    set(h.optExpTr.radiobutton_noDt, 'Value', ~prm.dt{1});
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.checkbox_dtI, 'Value', prm.dt{2}(1));
%     set(h.optExpTr.checkbox_dtFRET, 'Value', prm.dt{2}(2));
%     set(h.optExpTr.checkbox_dtS, 'Value', prm.dt{2}(3));
%     set(h.optExpTr.checkbox_kin, 'Value', prm.dt{2}(4));
    
    if prm.dt{1}
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.checkbox_dtI, 'Value', prm.dt{2}(1));
        set(h.optExpTr.checkbox_dtFRET, 'Value', prm.dt{2}(2));
        set(h.optExpTr.checkbox_dtS, 'Value', prm.dt{2}(3));
        set(h.optExpTr.checkbox_kin, 'Value', prm.dt{2}(4));
    
        set(h.optExpTr.radiobutton_saveDt, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noDt, 'FontWeight', 'normal');
        set([h.optExpTr.text_dt2exp h.optExpTr.checkbox_dtI ...
            h.optExpTr.checkbox_dtFRET h.optExpTr.checkbox_dtS ...
            h.optExpTr.checkbox_kin], 'Enable', 'on');

    else
        set(h.optExpTr.radiobutton_saveDt, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noDt, 'FontWeight', 'bold');
        set([h.optExpTr.text_dt2exp h.optExpTr.checkbox_dtI ...
            h.optExpTr.checkbox_dtFRET h.optExpTr.checkbox_dtS ...
            h.optExpTr.checkbox_kin], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_dtI h.optExpTr.checkbox_dtFRET ...
            h.optExpTr.checkbox_dtS h.optExpTr.checkbox_kin],'Value',0);
    end
    if ~nFRET
        set(h.optExpTr.checkbox_dtFRET, 'Enable', 'off');
    end
    if ~nS
        set(h.optExpTr.checkbox_dtS, 'Enable', 'off');
    end
end

if strcmp(opt, 'fig') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveFig, 'Value', prm.fig{1}(1));
    set(h.optExpTr.radiobutton_noFig, 'Value', ~prm.fig{1}(1));
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.popupmenu_figFmt, 'Value', prm.fig{1}(2));
%     set(h.optExpTr.edit_nMol, 'String', num2str(prm.fig{1}(3)));
%     set(h.optExpTr.checkbox_subImg, 'Value', prm.fig{1}(4));
%     set(h.optExpTr.checkbox_figHist, 'Value', prm.fig{1}(5));
%     set(h.optExpTr.checkbox_figDiscr, 'Value', prm.fig{1}(6));
%     set(h.optExpTr.checkbox_top, 'Value', prm.fig{2}{1}(1));
%     set(h.optExpTr.popupmenu_topExc, 'Value', prm.fig{2}{1}(2));
%     set(h.optExpTr.popupmenu_topChan, 'Value', prm.fig{2}{1}(3));
%     set(h.optExpTr.checkbox_bottom, 'Value', prm.fig{2}{2}(1));
    
    if prm.fig{1}(1)
        set(h.optExpTr.radiobutton_saveFig, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noFig, 'FontWeight', 'normal');
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.popupmenu_figFmt, 'Value', prm.fig{1}(2));
        set(h.optExpTr.edit_nMol, 'String', num2str(prm.fig{1}(3)));
        set(h.optExpTr.checkbox_subImg, 'Value', prm.fig{1}(4));
        set(h.optExpTr.checkbox_figHist, 'Value', prm.fig{1}(5));
        set(h.optExpTr.checkbox_figDiscr, 'Value', prm.fig{1}(6));
        set(h.optExpTr.checkbox_top, 'Value', prm.fig{2}{1}(1));
        set(h.optExpTr.popupmenu_topExc, 'Value', prm.fig{2}{1}(2));
        set(h.optExpTr.popupmenu_topChan, 'Value', prm.fig{2}{1}(3));
        set(h.optExpTr.checkbox_bottom, 'Value', prm.fig{2}{2}(1));
        
        % added by MH, 10.4.2019
        dat_txt = get(h.optExpTr.text_figInfos, 'UserData');
        set(h.optExpTr.text_figInfos, 'String', dat_txt(prm.fig{1}(2)));
        
        set([h.optExpTr.text_figFmt h.optExpTr.popupmenu_figFmt ...
            h.optExpTr.text_nMol h.optExpTr.edit_nMol ...
            h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.checkbox_bottom h.optExpTr.checkbox_figHist ...
            h.optExpTr.checkbox_figDiscr h.optExpTr.pushbutton_preview],...
            'Enable', 'on');
        
        if prm.fig{2}{1}(1) % top axes
            set([h.optExpTr.popupmenu_topExc ...
                h.optExpTr.popupmenu_topChan] , 'Enable', 'on');
        else
            set([h.optExpTr.popupmenu_topExc ...
                h.optExpTr.popupmenu_topChan] , 'Enable', 'off');
        end
        if prm.fig{2}{2}(1) % bottom axes
            set(h.optExpTr.popupmenu_botChan, 'Enable', 'on', 'Value', ...
                prm.fig{2}{2}(2));
        else
            set(h.optExpTr.popupmenu_botChan, 'Enable', 'off');
        end
        if ~prm.fig{2}{1}(1) && ~prm.fig{2}{2}(1)
            set([h.optExpTr.checkbox_figHist ...
                h.optExpTr.checkbox_figDiscr], 'Enable', 'off');
        end
        
        % moved here by MH, 10.4.2019
        if ~nFRET && ~nS
            set([h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan], ...
                'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveFig, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noFig, 'FontWeight', 'bold');
        set([h.optExpTr.text_figFmt h.optExpTr.popupmenu_figFmt ...
            h.optExpTr.text_nMol h.optExpTr.edit_nMol ...
            h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.popupmenu_topExc h.optExpTr.popupmenu_topChan ...
            h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan ...
            h.optExpTr.checkbox_figHist h.optExpTr.checkbox_figDiscr ...
            h.optExpTr.pushbutton_preview], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.checkbox_bottom h.optExpTr.checkbox_figHist ...
            h.optExpTr.checkbox_figDiscr],'Value',0);
    end
    
    % cancelled by MH, 10.4.2019
%     if ~nFRET && ~nS
%         set([h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan], ...
%             'Enable', 'off');
%     end
end
