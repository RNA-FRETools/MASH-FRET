function ud_bleach(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p_panel = p.proj{proj}.curr{mol}{2};
    
    FRET = p.proj{proj}.FRET;
    S = p.proj{proj}.S;
    nFRET = size(FRET,1);
    nS = size(S,1);
    labels = p.proj{p.curr_proj}.labels;
    exc = p.proj{proj}.excitations;

    cutIt = p_panel{1}(1);
    method = p_panel{1}(2);
    chan = p_panel{1}(3);
    start = p_panel{1}(4);
    cutOff = p_panel{1}(4+method);
    prm = p_panel{2}(chan,:);
    
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
    str_un = 'counts';
    if chan > nFRET+nS % intensity channel
        if perSec
            prm(1) = prm(1)/rate;
            str_un = cat(2,str_un,' /second');
        end
        if perPix
            nPix = p.proj{proj}.pix_intgr(2);
            prm(1) = prm(1)/nPix;
            str_un = cat(2,str_un,' /pixel');
        end
    end
    
    set(h.checkbox_photobl_fixStart, 'Value', fixIt);
    set(h.checkbox_photobl_insec, 'Value', inSec);
    set(h.edit_photobl_start, 'String', num2str(start));
    if fixIt
        set(h.edit_photobl_start, 'Enable', 'inactive');
    else
        set(h.edit_photobl_start, 'Enable', 'on');
    end
    set(h.edit_photobl_stop, 'String', num2str(cutOff));
    set(h.popupmenu_debleachtype, 'Value', method);
    set(h.checkbox_cutOff, 'Value', cutIt);
    
    switch method
        case 1 % Manual
            set([h.edit_photoblParam_01 h.edit_photoblParam_02 ...
                h.edit_photoblParam_03 h.popupmenu_bleachChan], ...
                'Enable', 'off');
            set(h.edit_photobl_stop, 'Enable', 'on');
            
        case 2 % Threshold
            set([h.edit_photoblParam_01 h.edit_photoblParam_02 ...
                h.edit_photoblParam_03 h.popupmenu_bleachChan], ...
                'Enable', 'on');
            set(h.edit_photobl_stop, 'Enable', 'inactive');
    end
    if method == 2
        set(h.popupmenu_bleachChan, 'Value', chan, 'String', ...
            getStrPop('bleach_chan', {labels FRET S exc ...
            p.proj{proj}.colours}));
    else
        set(h.popupmenu_bleachChan, 'Value', 1, 'String', {'none'});
    end
    set(h.edit_photoblParam_01,'string',num2str(prm(1)),'tooltipstring',...
        cat(2,'<html><b>Data threshold ',str_un,':</b> photobleaching is ',...
        'detected when the selected data-time trace drops below the ',...
        'threshold.</html>'));
    set(h.edit_photoblParam_02, 'String', num2str(prm(2)));
    set(h.edit_photoblParam_03, 'String', num2str(prm(3)));
    
    if inSec
        set(h.edit_photoblParam_02, 'tooltipstring',cat(2,'<html><b>Tolerance ',...
            '(in seconds):</b> extra time to subtract to the detected ',...
            'photobleaching time</html>'));
        set(h.edit_photoblParam_03, 'tooltipstring',cat(2,'<html><b>Minimum ',...
            'cutoff time (in seconds):</b> photobleaching events detected',...
            ' below this time are ignored.</html>'));
    else
        set(h.edit_photoblParam_02, 'tooltipstring',cat(2,'<html><b>Tolerance ',...
            '(in frames):</b> extra frames to subtract to the detected ',...
            'photobleaching position</html>'));
        set(h.edit_photoblParam_03, 'tooltipstring',cat(2,'<html><b>Minimum ',...
            'cutoff position (in frames):</b> photobleaching events ',...
            'detected below this position are ignored.</html>'));
    end
    
end
