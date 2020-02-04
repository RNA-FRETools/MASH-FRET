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
S = p.proj{proj}.S;
nFRET = size(FRET,1);
nS = size(S,1);
labels = p.proj{proj}.labels;
clr = p.proj{proj}.colours;

% processing parameters
curr_fret = p.proj{proj}.fix{3}(8);
p_pan = p.proj{proj}.curr{mol}{6};

set(h.popupmenu_gammaFRET,'Value',1,'String',...
    getStrPop('corr_gamma',{FRET labels clr}));

isS = false;
if nS>0
    isS = sum(S(:,1)==FRET(curr_fret,1) & S(:,2)==FRET(curr_fret,2));
end

if nFRET==0
    set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
        h.text_TP_factors_method h.popupmenu_TP_factors_method ...
        h.text_TP_factors_fact h.text_TP_factors_gamma ...
        h.text_TP_factors_beta h.edit_gammaCorr h.edit_betaCorr ...
        h.pushbutton_optGamma],'Enable','off');
    set([h.edit_gammaCorr,h.edit_betaCorr],'String','');
    return
end

if curr_fret<1
    set([h.text_TP_factors_data ,h.popupmenu_gammaFRET],'Enable','on')
    set([h.text_TP_factors_method h.popupmenu_TP_factors_method ...
        h.text_TP_factors_fact h.text_TP_factors_gamma,...
        h.text_TP_factors_beta,h.edit_gammaCorr,h.edit_betaCorr,...
        h.pushbutton_optGamma],'Enable','off');
    return
end

set([h.text_TP_factors_fact h.popupmenu_gammaFRET h.text_TP_factors_method ...
    h.popupmenu_TP_factors_method h.text_TP_factors_data ...
    h.text_TP_factors_gamma h.text_TP_factors_beta h.pushbutton_optGamma],...
    'Enable','on');

set(h.popupmenu_gammaFRET,'Value',curr_fret+1);
set(h.edit_gammaCorr,'String',num2str(p_pan{1}(1,curr_fret)));
set(h.edit_betaCorr,'String',num2str(p_pan{1}(2,curr_fret)));

switch p_pan{2}(curr_fret)
    case 0 % manual
        set([h.edit_gammaCorr,h.edit_betaCorr],'Enable','on');
        set(h.pushbutton_optGamma,'String','Load','tooltipstring',...
            cat(2,'<html><b>Import gamma factors</b> from ASCII files.',...
            '</html>'));

    case 1 % photobleaching based
        set(h.edit_gammaCorr,'Enable','inactive');
        set(h.edit_betaCorr,'Enable','on');
        set(h.pushbutton_optGamma,'String','Opt.','tooltipstring',...
            cat(2,'<html><b>Open method settings</b> for factor ',...
            'estimation via acceptor photobleaching.</html>'));
        
    case 2 % photobleaching based
        set([h.edit_gammaCorr,h.edit_betaCorr],'Enable','inactive');
        set(h.pushbutton_optGamma,'String','Opt.','tooltipstring',...
            cat(2,'<html><b>Open method settings</b> for factor ',...
            'estimation via linear regression.</html>'));

end

if ~isS
    set([h.text_TP_factors_beta,h.edit_betaCorr],'enable','off');
else
    set(h.text_TP_factors_beta,'enable','on');
end
set(h.popupmenu_TP_factors_method,'Enable','on','Value',...
    p_pan{2}(1,curr_fret)+1);
