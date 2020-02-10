function openTrsfOpt(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.movPr;
nChan = p.nChan;

if ~(isfield(h, 'figure_trsfOpt') && ishandle(h.figure_trsfOpt))
    
    mg = 10;
    dim_but = [50 22];
    dim_edit = [40 20];
    dim_txt_short = [40 14];
    dim_txt_chan = [52 14];
    dim_radio = [103 20];
    dim_txt_long = [120 14];
    h_pan_ref = 10 + 5*mg + 2*(dim_txt_short(2) + dim_radio(2) + ...
        dim_edit(2) + nChan*(dim_edit(2) + mg));
    h_pan_mol = 10 + 2*mg + dim_edit(2);
    w_pan = 5*mg + 2*dim_txt_chan(1) + 3*dim_txt_short(1);
    hFig = 6*mg + dim_txt_long(2) + dim_edit(2) + h_pan_ref + ...
        h_pan_mol + dim_but(2);
    wFig = w_pan + 2*mg;
    
    switch p.trsf_refImp_mode
        case 'rw'
            en_rw = 'on';
            en_cw = 'off';
        case 'cw'
            en_rw = 'off';
            en_cw = 'on';
    end

    prev_u = get(h_fig, 'Units');
    set(h_fig, 'Units', 'pixels');
    posFig = get(h_fig, 'Position');
    set(h_fig, 'Units', prev_u);
    xFig = posFig(1) + (posFig(3) - wFig)/2;
    yFig = posFig(2) + (posFig(4) - hFig)/2;

    h.figure_trsfOpt = figure('Color', [0.94 0.94 0.94], 'Resize', ...
        'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
        'Import options', 'Visible', 'off', 'Units', 'pixels', ...
        'Position', [xFig yFig wFig hFig], 'CloseRequestFcn', ...
        {@figure_trsfOpt_CloseRequestFcn, h_fig}, 'WindowStyle', 'Modal');
    
    bgCol = get(h.figure_trsfOpt, 'Color');
    
    ttstr_edit_movW = cat(2,'<html>Dimensions of the <b>reference image',...
        '</b> in<br>the <b>x-direction</b> used to calculate the<br>',...
        'imported transformation (in pixel)</html>'); 
    ttstr_edit_movH = cat(2,'<html>Dimensions of the <b>reference image',...
        '</b> in<br>the <b>y-direction</b> used to calculate the<br>',...
        'imported transformation (in pixel)</html>');
    ttstr_edit_molXcol = cat(2,'<html><b>Column index</b> in file where ',...
        'spots<br><b>x-coordinates</b> are written.</html>');
    ttstr_edit_molYcol = cat(2,'<html><b>Column index</b> in file where ',...
        'spots<br><b>y-coordinates</b> are written.</html>');
    ttstr_edit_start_i = cat(2,'<html><b>First row index</b> in file ',...
        'where<br>reference coordinates in channel %i<br>are written',...
        '</html>');
    ttstr_edit_iv_i = cat(2,'<html>Number of <b>row to skip</b> in<br>',...
        'file to read reference coordinates<br>in channel %i</html>');
    ttstr_edit_stop_i = cat(2,'<html><b>Last row index</b> in file ',...
        'where<br>reference coordinates in channel %i<br>are written',...
        '</html>');
    ttstr_edit_rColX = cat(2,'<html><b>Line</b> in file ',...
        'where reference<br><b>x-coordinates</b> are written</html>');
    ttstr_edit_rColY = cat(2,'<html><b>Line</b> in file ',...
        'where reference<br><b>y-coordinates</b> are written</html>');
    ttstr_radiobutton_rw = cat(2,'<html>Reference coordinates are<br>',...
        'written <b>on two lines</b> in file</html>');
    ttstr_edit_cColX_i = cat(2,'<html><b>Column index</b> in file where',...
        '<br>reference <b>x-coordinates</b> in<br>channel %i are written',...
        '</html>');
    ttstr_edit_cColY_i = cat(2,'<html><b>Column index</b> in file where',...
        '<br>reference <b>y-coordinates</b> in<br>channel %i are written',...
        '</html>');
    ttstr_edit_nHead = cat(2,'<html>Number of lines on top of<br>the file ',...
        'that <b>do not contain<br>reference coordinates</b></html>');
    ttstr_radiobutton_cw = cat(2,'<html>Reference coordinates are<br>',...
        'written  <b>in two columns</b> in file</html>');
    
    
    yNext = mg;
    xNext = mg;
    
    h.trsfOpt.pushbutton_trsfOpt_ok = uicontrol('Style', 'pushbutton', ...
        'String', 'Ok', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext dim_but], 'Callback', ...
        {@pushbutton_trsfOpt_ok_Callback, h_fig});
    
    xNext = xNext + dim_but(1) + mg;
    
    h.trsfOpt.pushbutton_trsfOpt_cancel = uicontrol('Style', ...
        'pushbutton', 'String', 'Cancel', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'Position', [xNext yNext dim_but], ...
        'Callback', {@pushbutton_trsfOpt_cancel_Callback, h_fig});
    
    guidata(h_fig,h);
    h.trsfOpt.pushbutton_help = setInfoIcons(...
        h.trsfOpt.pushbutton_trsfOpt_cancel,h_fig,p.infos_icon_file);
    
    yNext = yNext + dim_but(2) + mg;
    xNext = mg;

    h.trsfOpt.text_movW = uicontrol('Style', 'text', 'String', ...
        'width: ', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_txt_short(1) + mg;
    
    h.trsfOpt.edit_movW = uicontrol('Style', 'edit', 'String', ...
        num2str(p.trsf_coordLim(1)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', [xNext yNext dim_edit], ...
        'tooltipstring', ttstr_edit_movW);
        
    xNext = xNext + dim_edit(1) + 2*mg;
        
    h.trsfOpt.text_movH = uicontrol('Style', 'text', 'String', ...
        'height: ', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext dim_txt_short]);
        
    xNext = xNext + dim_txt_short(1) + mg;
        
    h.trsfOpt.edit_movH = uicontrol('Style', 'edit', 'String', ...
        num2str(p.trsf_coordLim(2)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', [xNext yNext dim_edit],...
        'tooltipstring', ttstr_edit_movH);
        
    yNext = yNext + dim_edit(2) + mg;
    xNext = mg;
    
    h.trsfOpt.text_movDim = uicontrol('Style', 'text', 'String', ...
        'Video dimensions (pixels): ', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext dim_txt_long]);
    
    yNext = yNext + dim_txt_long(2) + mg;
    xNext = mg;
    
    h.trsfOpt.uipanel_molCoord = uipanel('Title', ...
        'Molecule coordinates', 'Units', 'pixels', 'BackgroundColor', ...
        bgCol, 'Position', [xNext yNext w_pan h_pan_mol]);
    
    yNext = yNext + h_pan_mol + mg;
    
    h.trsfOpt.uipanel_refCoord = uipanel('Title', ...
        'Reference coordinates', 'Units', 'pixels', 'BackgroundColor', ...
        bgCol, 'Position', [xNext yNext w_pan h_pan_ref]);
    
    % Panel molecule coordinates
    
    yNext = mg;
    xNext = mg;
    
    h.trsfOpt.text_molXcol = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_molCoord, 'String', 'x-col: ', 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'center', 'Position', [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_txt_short(1) + mg;
    
    h.trsfOpt.edit_molXcol = uicontrol('Style', 'edit', 'Parent', ...
        h.trsfOpt.uipanel_molCoord, 'String', ...
        num2str(p.trsf_coordImp(1)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', [xNext yNext dim_edit],...
        'tooltipstring',ttstr_edit_molXcol);
        
    xNext = xNext + dim_edit(1) + 2*mg;
        
    h.trsfOpt.text_molYcol = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_molCoord, 'String', 'y-col: ', 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'center', 'Position', [xNext yNext dim_txt_short]);
        
    xNext = xNext + dim_txt_short(1) + mg;
        
    h.trsfOpt.edit_molYcol = uicontrol('Style', 'edit', 'Parent', ...
        h.trsfOpt.uipanel_molCoord, 'String', ...
        num2str(p.trsf_coordImp(2)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', [xNext yNext dim_edit],...
        'tooltipstring',ttstr_edit_molYcol);

    % Panel reference coordinates

    yNext = 0;
    
    for i = nChan:-1:1
        
        yNext = yNext + mg;
        xNext = mg;
        
        h.trsfOpt.text_rChan(i) = uicontrol('Style', 'text', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ['channel ' ...
            num2str(i) ':'], 'Units', 'pixels', 'BackgroundColor', ...
            bgCol, 'HorizontalAlignment', 'center', 'Position', ...
            [xNext yNext dim_txt_chan], 'Enable', en_rw);
        
        xNext = xNext + dim_txt_chan(1) + mg;
        
        h.trsfOpt.edit_start(i) = uicontrol('Style', 'edit', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ...
            num2str(p.trsf_refImp_rw{1,1}(i,1)), 'Enable', en_rw, ...
            'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
            [xNext yNext dim_edit],'tooltipstring',...
            sprintf(ttstr_edit_start_i,i));
        
        xNext = xNext + dim_edit(1) + mg;
        
        h.trsfOpt.edit_iv(i) = uicontrol('Style', 'edit', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ...
            num2str(p.trsf_refImp_rw{1,1}(i,2)), 'Enable', en_rw, ...
            'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
            [xNext yNext dim_edit],'tooltipstring',...
            sprintf(ttstr_edit_iv_i,i));
        
        xNext = xNext + dim_edit(1) + mg;
        
        h.trsfOpt.edit_stop(i) = uicontrol('Style', 'edit', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ...
            num2str(p.trsf_refImp_rw{1,1}(i,3)), 'Enable', en_rw, ...
            'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
            [xNext yNext dim_edit],'tooltipstring',...
            sprintf(ttstr_edit_stop_i,i));
        
        yNext = yNext + dim_edit(2);
    end
    
    xNext = 2*mg + dim_txt_chan(1);
    
    h.trsfOpt.text_start = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'start', 'Enable', en_rw, ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_edit(1) + mg;
    
    h.trsfOpt.text_iv = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'interv.', 'Enable', ...
        en_rw, 'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_edit(1) + mg;
    
    h.trsfOpt.text_stop = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'end', 'Enable', en_rw, ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_edit(1);
    
    h.trsfOpt.text_infos = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', '(0 = last)', 'Enable', ...
        en_rw, 'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_chan], 'HorizontalAlignment', 'left');
    
    yNext = yNext + dim_txt_chan(2) + mg;
    xNext = mg;
    
    h.trsfOpt.text_rColX = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'x-col:', 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'center', 'Position', [xNext yNext dim_txt_short], 'Enable', ...
        en_rw);
    
    xNext = xNext + dim_txt_short(1) + mg;
    
    h.trsfOpt.edit_rColX = uicontrol('Style', 'edit', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', ...
        num2str(p.trsf_refImp_rw{1,2}(i,1)), 'Enable', en_rw, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext dim_edit],'tooltipstring',ttstr_edit_rColX);
    
    xNext = xNext + dim_edit(1) + 2*mg;
    
    h.trsfOpt.text_rColY = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'y-col:', 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'center', 'Position', [xNext yNext dim_txt_short], 'Enable', ...
        en_rw);
    
    xNext = xNext + dim_txt_short(1) + mg;
    
    h.trsfOpt.edit_rColY = uicontrol('Style', 'edit', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', ...
        num2str(p.trsf_refImp_rw{1,2}(i,2)), 'Enable', en_rw, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext dim_edit],'tooltipstring',ttstr_edit_rColY);
    
    yNext = yNext + dim_edit(2) + mg;
    xNext = mg;

    h.trsfOpt.radiobutton_rw = uicontrol('Style', 'radiobutton', ...
        'Parent', h.trsfOpt.uipanel_refCoord, 'String', 'Row-wise', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_radio], 'Callback', ...
        {@radiobutton_rw_Callback, h_fig},'tooltipstring',...
        ttstr_radiobutton_rw);
    
    if strcmp(p.trsf_refImp_mode, 'rw')
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'bold', 'Value', 1);
    else
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'normal', 'Value', 0);
    end
    
    yNext = yNext + dim_radio(2);
    
    for i = nChan:-1:1
        
        yNext = yNext + mg;
        xNext = mg;
        
        h.trsfOpt.text_cChan(i) = uicontrol('Style', 'text', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ['channel ' ...
            num2str(i) ':'], 'Units', 'pixels', 'BackgroundColor', ...
            bgCol, 'HorizontalAlignment', 'center', 'Position', ...
            [xNext yNext dim_txt_chan], 'Enable', en_cw);
        
        xNext = xNext + dim_txt_chan(1) + mg;
        
        h.trsfOpt.edit_cColX(i) = uicontrol('Style', 'edit', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ...
            num2str(p.trsf_refImp_cw{1,1}(i,1)), 'Enable', en_cw, ...
            'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
            [xNext yNext dim_edit],'tooltipstring',...
            sprintf(ttstr_edit_cColX_i,i));
        
        xNext = xNext + dim_edit(1) + mg;
        
        h.trsfOpt.edit_cColY(i) = uicontrol('Style', 'edit', 'Parent', ...
            h.trsfOpt.uipanel_refCoord, 'String', ...
            num2str(p.trsf_refImp_cw{1,1}(i,2)), 'Enable', en_cw, ...
            'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
            [xNext yNext dim_edit],'tooltipstring',...
            sprintf(ttstr_edit_cColY_i,i));
        
        yNext = yNext + dim_edit(2);
        
    end
    
    xNext = 2*mg + dim_txt_chan(1);
    
    h.trsfOpt.text_cColX = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'x-col', 'Enable', en_cw, ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_short]);
    
    xNext = xNext + dim_edit(1) + mg;
    
    h.trsfOpt.text_cColY = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', 'y-col', 'Enable', en_cw, ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_txt_short]);

    yNext = yNext + dim_txt_short(2) + mg;
    xNext = mg;
    
    h.trsfOpt.text_nHead = uicontrol('Style', 'text', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', ...
        'number of header lines:', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext dim_txt_long], 'Enable', en_cw);
    
    xNext = xNext + dim_txt_long(1) + mg;
    
    h.trsfOpt.edit_nHead = uicontrol('Style', 'edit', 'Parent', ...
        h.trsfOpt.uipanel_refCoord, 'String', ...
        num2str(p.trsf_refImp_cw{1,2}), 'Enable', en_cw, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext dim_edit],'tooltipstring',ttstr_edit_nHead);
    
    yNext = yNext + dim_edit(2) + mg;
    xNext = mg;
    
    h.trsfOpt.radiobutton_cw = uicontrol('Style', 'radiobutton', ...
        'Parent', h.trsfOpt.uipanel_refCoord, 'String', 'Column-wise', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext dim_radio], 'Callback', ...
        {@radiobutton_cw_Callback, h_fig},'tooltipstring',...
        ttstr_radiobutton_cw);
    
    if strcmp(p.trsf_refImp_mode, 'cw')
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'bold', 'Value', 1);
    else
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'normal', 'Value', 0);
    end

    guidata(h_fig, h);
    
    set(h.figure_trsfOpt, 'Visible', 'on');
end


function figure_trsfOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'trsfOpt');
    h = rmfield(h, {'trsfOpt', 'figure_trsfOpt'});
    guidata(h_fig, h);
end

delete(obj);


function radiobutton_cw_Callback(obj, evd, h_fig)
h = guidata(h_fig);
nChan = h.param.movPr.nChan;
switch get(obj, 'Value')
    case 1
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'bold');
        set(h.trsfOpt.text_nHead, 'Enable', 'on');
        set(h.trsfOpt.edit_nHead, 'Enable', 'on');
        set(h.trsfOpt.text_cColY, 'Enable', 'on');
        set(h.trsfOpt.text_cColX, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'on');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'on');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'on');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'normal', 'Value', 0);
        set(h.trsfOpt.edit_rColY, 'Enable', 'off');
        set(h.trsfOpt.text_rColY, 'Enable', 'off');
        set(h.trsfOpt.edit_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_stop, 'Enable', 'off');
        set(h.trsfOpt.text_iv, 'Enable', 'off');
        set(h.trsfOpt.text_start, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'off');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'off');
            set(h.trsfOpt.edit_start(i), 'Enable', 'off');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'off');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'off');
        
    case 0
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'normal');
        set(h.trsfOpt.text_nHead, 'Enable', 'off');
        set(h.trsfOpt.edit_nHead, 'Enable', 'off');
        set(h.trsfOpt.text_cColY, 'Enable', 'off');
        set(h.trsfOpt.text_cColX, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'off');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'off');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'off');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'bold', 'Value', 1);
        set(h.trsfOpt.edit_rColY, 'Enable', 'on');
        set(h.trsfOpt.text_rColY, 'Enable', 'on');
        set(h.trsfOpt.edit_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_stop, 'Enable', 'on');
        set(h.trsfOpt.text_iv, 'Enable', 'on');
        set(h.trsfOpt.text_start, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'on');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'on');
            set(h.trsfOpt.edit_start(i), 'Enable', 'on');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'on');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'on');
end


function radiobutton_rw_Callback(obj, evd, h_fig)
h = guidata(h_fig);
nChan = h.param.movPr.nChan;
switch get(obj, 'Value')
    case 0
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'bold', 'Value', 1);
        set(h.trsfOpt.text_nHead, 'Enable', 'on');
        set(h.trsfOpt.edit_nHead, 'Enable', 'on');
        set(h.trsfOpt.text_cColY, 'Enable', 'on');
        set(h.trsfOpt.text_cColX, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'on');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'on');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'on');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'normal');
        set(h.trsfOpt.edit_rColY, 'Enable', 'off');
        set(h.trsfOpt.text_rColY, 'Enable', 'off');
        set(h.trsfOpt.edit_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_stop, 'Enable', 'off');
        set(h.trsfOpt.text_iv, 'Enable', 'off');
        set(h.trsfOpt.text_start, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'off');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'off');
            set(h.trsfOpt.edit_start(i), 'Enable', 'off');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'off');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'off');
        
    case 1
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'normal', 'Value', 0);
        set(h.trsfOpt.text_nHead, 'Enable', 'off');
        set(h.trsfOpt.edit_nHead, 'Enable', 'off');
        set(h.trsfOpt.text_cColY, 'Enable', 'off');
        set(h.trsfOpt.text_cColX, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'off');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'off');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'off');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'bold');
        set(h.trsfOpt.edit_rColY, 'Enable', 'on');
        set(h.trsfOpt.text_rColY, 'Enable', 'on');
        set(h.trsfOpt.edit_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_stop, 'Enable', 'on');
        set(h.trsfOpt.text_iv, 'Enable', 'on');
        set(h.trsfOpt.text_start, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'on');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'on');
            set(h.trsfOpt.edit_start(i), 'Enable', 'on');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'on');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'on');
end


function pushbutton_trsfOpt_ok_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.movPr;
nChan = h.param.movPr.nChan;

if get(h.trsfOpt.radiobutton_rw, 'Value')
    p.trsf_refImp_mode = 'rw';
else
    p.trsf_refImp_mode = 'cw';
end

for i = 1:nChan
    p.trsf_refImp_rw{1}(i,1:3) = ...
        [str2num(get(h.trsfOpt.edit_start(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_iv(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_stop(i), 'String'))];
    
    p.trsf_refImp_cw{1}(i,1:2) = ...
        [str2num(get(h.trsfOpt.edit_cColX(i), 'String')) ...
        str2num(get(h.trsfOpt.edit_cColY(i), 'String'))];
end

p.trsf_refImp_rw{2} = [str2num(get(h.trsfOpt.edit_rColX, 'String')) ...
    str2num(get(h.trsfOpt.edit_rColY, 'String'))];

p.trsf_refImp_cw{2} = str2num(get(h.trsfOpt.edit_nHead, 'String'));

p.trsf_coordImp = [str2num(get(h.trsfOpt.edit_molXcol, 'String')) ...
    str2num(get(h.trsfOpt.edit_molYcol, 'String'))];

p.trsf_coordLim = [str2num(get(h.trsfOpt.edit_movW, 'String')) ...
    str2num(get(h.trsfOpt.edit_movH, 'String'))];

h.param.movPr = p;
guidata(h_fig, h);

close(h.figure_trsfOpt);


function pushbutton_trsfOpt_cancel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
close(h.figure_trsfOpt);


