% MH modified checkbox to popupmenu 26.3.2019
% FS added 8.1.2018, last modified 11.1.2018
function popupmenu_TP_factors_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
fret = p.proj{proj}.fix{3}(8);
mol = p.curr_mol(proj);

method = get(obj, 'Value');
isS = sum(S(:,1)==FRET(fret,1) & S(:,2)==FRET(fret,2));

if method==3 && ~isS % linear regression
    setContPan(cat(2,'ES linear regression can not be used: no ',...
        'stoichiometry is available for this FRET pair.\n\nTo add ',...
        'stoichiometry calculations, edit the project options by pressing',...
        ' "Edit" below the project list.'),'error',h_fig);
    set(obj,'value',p.proj{proj}.curr{mol}{6}{2}(fret)+1);
    return
end

mol = p.curr_mol(proj);
p.proj{proj}.curr{mol}{6}{2}(fret) = method-1; % method
h.param.ttPr = p;
guidata(h_fig, h);
ud_factors(h_fig)
