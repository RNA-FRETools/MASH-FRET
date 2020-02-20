function ud_BAfields(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
if ~isempty(p.proj)
    % parameters from MASH
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
    rate = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);

    % parameters from BG analyser
    m = g.curr_m;
    l = g.curr_l;
    c = g.curr_c;
    meth = g.param{1}{m}(l,c,1);
    sngl_param1 = g.param{1}{m}(l,c,2);
    sngl_subdim = g.param{1}{m}(l,c,3);
    xdark = g.param{1}{m}(l,c,4);
    ydark = g.param{1}{m}(l,c,5);
    auto = g.param{1}{m}(l,c,6);
    bgVal = g.param{1}{m}(l,c,7);
    mlt_param1 = squeeze(g.param{2}{1}(l,c,:))';
    mlt_subdim = squeeze(g.param{2}{2}(l,c,:))';
    fix_param1 = g.param{3}(1);
    fix_subdim = g.param{3}(2);
    allmol = g.param{3}(3);
    
    str_un = '(a.u. /pix)';
    if perSec
        str_un = '(a.u. /pix /s)';
    end
    
    % set popupmenu strings and values
    set(g.popupmenu_data,'Value',nChan*(l-1)+c);
    set(g.popupmenu_meth, 'Value', meth);

    if ~fix_param1
        edit_param1 = g.edit_param1_i;
        set(g.edit_param1, 'Enable', 'off');
    else
        edit_param1 = g.edit_param1;
        set(g.edit_param1_i, 'Enable', 'off');
    end
    if ~fix_subdim
        edit_subimdim = g.edit_subimdim_i;
        set(g.edit_subimdim, 'Enable', 'off');
    else
        edit_subimdim = g.edit_subimdim;
        set(g.edit_subimdim_i, 'Enable', 'off');
    end
    
    set([edit_param1 edit_subimdim g.edit_xdark g.edit_ydark ...
        g.edit_chan g.edit_curmol], 'BackgroundColor', [1 1 1]);
    
    set([g.text_data g.popupmenu_data g.text_meth g.popupmenu_meth ...
        g.text_bgval g.text_curmol g.edit_curmol g.checkbox_allmol ...
        g.pushbutton_start g.pushbutton_save], 'Enable', 'on');
    
    if meth==1 % Manual
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'off');
        set(g.edit_chan, 'Enable', 'on');
            
    elseif meth==2 % 20 darkest, Mean value
        set([g.text_param1 edit_param1 g.text_xdark g.edit_xdark ...
            g.text_ydark g.edit_ydark g.checkbox_auto ...
            g.pushbutton_show g.radiobutton_fix_param1], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_subimdim edit_subimdim g.radiobutton_fix_subimdim], ...
            'Enable', 'on');
        
    elseif meth==3 % Mean value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', 'Tolerance cutoff');
            
    elseif meth==4 % Most frequent value, Histothresh 50% value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', 'Number of binning interval');
        
    elseif meth==5 % Histothresh
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', ...
            'Cumulative probability threshold');
            
    elseif meth==6 % Dark trace
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.text_xdark g.text_ydark g.checkbox_auto g.pushbutton_show ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        if ~auto
            set([g.edit_xdark g.edit_ydark], 'Enable', 'on');
        else
           set([g.edit_xdark g.edit_ydark], 'Enable', 'inactive');
        end
        set(g.edit_chan, 'Enable', 'inactive');
        set(edit_param1, 'TooltipString', 'Running average window size');
        
    elseif meth==7 % Median value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', sprintf(['Calculation method' ...
            '\n\t1: median(median_y)\n\t2: 0.5*(median(median_y)+' ...
            'median(median_x))']));
    end

    if perSec
        bgVal = bgVal/rate;
    end
    if perPix
        bgVal = bgVal/nPix;
    end
    edit_param1 = [g.edit_param1 g.edit_param1_i];
    param1 = [sngl_param1 mlt_param1];
    for i = 1:numel(edit_param1)
        set(edit_param1(i), 'String', num2str(param1(i)));
    end
    edit_subimdim = [g.edit_subimdim g.edit_subimdim_i];
    subdim = [sngl_subdim mlt_subdim];
    for i = 1:numel(subdim)
        set(edit_subimdim(i), 'String', num2str(subdim(i)));
    end
    set(g.edit_xdark, 'String', num2str(xdark));
    set(g.edit_ydark, 'String', num2str(ydark));
    set(g.checkbox_auto, 'Value', auto);
    set(g.edit_chan, 'String', num2str(bgVal));
    set(g.edit_curmol, 'String', num2str(m));
    set(g.checkbox_allmol, 'Value', allmol);
    set(g.radiobutton_fix_subimdim, 'Value', fix_subdim);
    set(g.radiobutton_fix_param1, 'Value', fix_param1);
    
    guidata(h_fig, g);
else
    setProp(get(h_fig, 'Children'), 'Enable', 'off');
end


