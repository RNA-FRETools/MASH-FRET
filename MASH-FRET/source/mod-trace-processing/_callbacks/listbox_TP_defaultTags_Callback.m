function listbox_TP_defaultTags_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);

tag = get(obj,'value');
str_tag = get(obj,'string');
if strcmp(str_tag{tag},'no default tag')
    return
end

p.proj{proj}.molTag(mol,tag) = true;

% added by MH, 13.1.2020: reset ES histograms
for i = 1:size(p.proj{proj}.ES,2)
    if ~(numel(p.proj{proj}.ES{i})==1 && isnan(p.proj{proj}.ES{i}))
        p.proj{proj}.ES{i} = [];
    end
end

% reset HA and TA
p = importHA(p,p.curr_proj);
p = importTA(p,p.curr_proj);

h.param = p;
guidata(h_fig,h);

grey = [240/255 240/255 240/255];
set(h.togglebutton_TP_addTag,'value',0,'backgroundColor',grey);
set(obj,'visible','off');

ud_trSetTbl(h_fig);
ud_HA_histDat(h_fig);
ud_TDPdata(h_fig);
