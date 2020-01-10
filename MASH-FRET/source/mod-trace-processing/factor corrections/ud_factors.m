function ud_factors(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

% project parameters
proj = p.curr_proj;
mol = p.curr_mol(proj);
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
labels = p.proj{proj}.labels;
clr = p.proj{proj}.colours;

% processing parameters
curr_fret = p.proj{proj}.fix{3}(8);
p_pan = p.proj{proj}.curr{mol}{6};

set(h.popupmenu_gammaFRET,'Value',1,'String',...
    getStrPop('corr_gamma',{FRET labels clr}));

if nFRET==0
    set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
        h.text_TP_factors_method h.popupmenu_TP_factors_method ...
        h.text_TP_factors_gamma h.edit_gammaCorr h.pushbutton_optGamma],...
        'Enable','off');
    set(h.edit_gammaCorr,'String','');
    return
end

if curr_fret<1
    set([h.text_TP_factors_data,h.popupmenu_gammaFRET],'Enable','on')
    set([h.text_TP_factors_method h.popupmenu_TP_factors_method ...
        h.text_TP_factors_gamma, h.edit_gammaCorr h.pushbutton_optGamma],...
        'Enable','off');
    return
end

set([h.text_TP_factors_data h.popupmenu_gammaFRET h.text_TP_factors_method ...
    h.popupmenu_TP_factors_method h.text_TP_factors_gamma ...
    h.pushbutton_optGamma],'Enable','on');

set(h.popupmenu_gammaFRET,'Value',curr_fret+1);
set(h.edit_gammaCorr,'String',num2str(p_pan{1}(curr_fret)));

switch p_pan{2}(1)
    case 0 % manual
        set(h.edit_gammaCorr,'Enable','on');
        set(h.pushbutton_optGamma,'String','Load','tooltipstring',...
            cat(2,'<html><b>Import gamma factors</b> from ASCII files.',...
            '</html>'));

    case 1 % photobleaching based
        set(h.edit_gammaCorr,'Enable','inactive');
        set(h.pushbutton_optGamma,'String','Opt.','tooltipstring',...
            cat(2,'<html><b>Open method settings</b> for factor ',...
            'estimation via acceptor photobleaching.</html>'));
        
    case 2 % photobleaching based
        set(h.edit_gammaCorr,'Enable','inactive');
        set(h.pushbutton_optGamma,'String','Opt.','tooltipstring',...
            cat(2,'<html><b>Open method settings</b> for factor ',...
            'estimation via linear regression.</html>'));

end
set(h.popupmenu_TP_factors_method,'Enable','on','Value',p_pan{2}(1)+1);
