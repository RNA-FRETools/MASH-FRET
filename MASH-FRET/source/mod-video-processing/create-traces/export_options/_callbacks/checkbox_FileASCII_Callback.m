function checkbox_FileASCII_Callback(obj, evd, h_fig)
h = guidata(h_fig);
switch get(obj, 'Value')
    case 1
        set([h.itgFileOpt.checkbox_allMol,h.itgFileOpt.checkbox_oneMol],...
            'Enable','on');
    case 0
        set([h.itgFileOpt.checkbox_allMol,h.itgFileOpt.checkbox_oneMol],...
            'value',0,'Enable','off');
end