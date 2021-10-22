% MH modified checkbox to popupmenu 26.3.2019
% FS added 8.1.2018, last modified 11.1.2018
function popupmenu_TP_factors_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
fret = p.proj{proj}.TP.fix{3}(8);

method = get(obj, 'Value');
isS = size(S,1)>0;
if isS && sum(S(:,1)==FRET(fret,1) & S(:,2)==FRET(fret,2))
    isS = true;
end

if method==3 && ~isS % linear regression
    setContPan(cat(2,'ES linear regression can not be used: no ',...
        'stoichiometry is available for this FRET pair.\n\nTo add ',...
        'stoichiometry calculations, edit the project options by pressing',...
        ' "Edit" below the project list.'),'error',h_fig);
    set(obj,'value',p.proj{proj}.TP.curr{mol}{6}{2}(fret)+1);
    return
end

p.proj{proj}.TP.curr{mol}{6}{2}(fret) = method-1; % method

h.param = p;
guidata(h_fig, h);

ud_factors(h_fig)
