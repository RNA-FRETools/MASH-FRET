function ud_factors(h_fig)

% defaults
file_icon0 = 'open_file.png';

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_factorCorrections,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
labels = p.proj{proj}.labels;
clr = p.proj{proj}.colours;
fix = p.proj{proj}.TP.fix;
curr = p.proj{proj}.TP.curr{mol};

curr_fret = fix{3}(8);
p_pan = curr{6};
set(h.popupmenu_gammaFRET,'Value',1,'String',...
    getStrPop('corr_gamma',{FRET labels clr}));

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep,'..',...
    filesep,'GUI',filesep];
img0 = imread([pname,file_icon0]);

nFRET = size(FRET,1);
nS = size(S,1);
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
    set([h.text_TP_factors_method h.popupmenu_TP_factors_method ...
        h.text_TP_factors_fact h.text_TP_factors_gamma,...
        h.text_TP_factors_beta,h.edit_gammaCorr,h.edit_betaCorr,...
        h.pushbutton_optGamma],'Enable','off');
    return
end

set(h.popupmenu_gammaFRET,'Value',curr_fret+1);
set(h.edit_gammaCorr,'String',num2str(p_pan{1}(1,curr_fret)));
set(h.edit_betaCorr,'String',num2str(p_pan{1}(2,curr_fret)));

switch p_pan{2}(curr_fret)
    case 0 % manual
        set(h.pushbutton_optGamma,'cdata',img0,'string','','tooltipstring',...
            cat(2,'<html><b>Import gamma factors</b> from ASCII files.',...
            '</html>'));

    case 1 % photobleaching based
        set(h.edit_gammaCorr,'Enable','inactive');
        set(h.pushbutton_optGamma,'cdata',[],'String','Opt.',...
            'tooltipstring',cat(2,'<html><b>Open method settings</b> for ',...
            'factor estimation via acceptor photobleaching.</html>'));
        
    case 2 % photobleaching based
        set([h.edit_gammaCorr,h.edit_betaCorr],'Enable','inactive');
        set(h.pushbutton_optGamma,'cdata',[],'String','Opt.',...
            'tooltipstring',cat(2,'<html><b>Open method settings</b> for ',...
            'factor estimation via linear regression.</html>'));

end

if ~isS
    set([h.text_TP_factors_beta,h.edit_betaCorr],'enable','off');
end
set(h.popupmenu_TP_factors_method,'Value',p_pan{2}(1,curr_fret)+1);
