function ud_movBgCorr(obj, evd, h)

p = h.param.movPr;

method = get(obj, 'Value');
switch method
    case 1 % none
         set(h.edit_bgParam_01, 'Enable', 'off', 'TooltipString', '');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
    case 2 % gauss
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Halfwindow size & standard deviation');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');     
    case 3 % mean
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Halfwindow size');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');       
    case 4 % median
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Halfwindow size');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
    case 5 % ggf
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Halfwindow size');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Standard deviation');       
    case 6 % lwf
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Halfwindow size');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Noise intensity per pixel');        
    case 7 % gwf
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Noise intensity per pixel');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
    case 8 % outlier
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Radius of a spot');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Correction intensity');        
    case 9 % histotresh
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Percentage of background');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');        
    case 10 % simpletresh
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Minimum intensity');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');   
    case 11 % old1: mean
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Tolerance factor');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');    
    case 12 % old 2: most frequent
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Tolerance factor');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Histogram interval number');    
    case 13 % old 3: histotresh
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Cumulative probability threshold');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Histogram interval number');
    case 14 % Ha-all
         set(h.edit_bgParam_01, 'Enable', 'off', 'TooltipString', '');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
    case 15 % Ha-each
         set(h.edit_bgParam_01, 'Enable', 'off', 'TooltipString', '');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
    case 16 % Twotone
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', ...
                                'Bandpass Kernel diameter');
         set(h.edit_bgParam_02, 'Enable', 'on', 'TooltipString', ...
                                'Noise length');
    case 17 % Subtract image
         set(h.edit_bgParam_01, 'Enable', 'off', 'TooltipString', '');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', '');
         
    case 18 % Multiplication
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', 'Factor');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', ''); 
         
    case 19 % Addition
         set(h.edit_bgParam_01, 'Enable', 'on', 'TooltipString', 'Offset');
         set(h.edit_bgParam_02, 'Enable', 'off', 'TooltipString', ''); 
end

p.movBg_method = method;
h.param.movPr = p;
guidata(h.figure_MASH, h);

channel = get(h.popupmenu_bgChanel, 'Value');
if p.movBg_method ~= 17 %image subtraction
    set(h.edit_bgParam_01, 'String', num2str(p.movBg_p{...
        p.movBg_method,channel}(1)), 'BackgroundColor', [1 1 1]);
    set(h.edit_bgParam_02, 'String', num2str(p.movBg_p{...
        p.movBg_method,channel}(2)), 'BackgroundColor', [1 1 1]);
else
    set(h.edit_bgParam_01, 'String', '', 'BackgroundColor', [1 1 1]);
    set(h.edit_bgParam_02, 'String', '', 'BackgroundColor', [1 1 1]);
end

