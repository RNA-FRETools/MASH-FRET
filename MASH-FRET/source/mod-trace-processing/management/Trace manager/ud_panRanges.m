function ud_panRanges(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

dat3 = get(h.tm.axes_histSort,'userdata');
data = get(h.tm.popupmenu_selectData,'value');
calc = get(h.tm.popupmenu_selectCalc,'value');

prm = dat3.range;
if isempty(prm)
    R = 0;
else
    R = size(prm,1);
end

if data>(nChan*nExc+nFRET+nS) % 2D histogram
    set([h.tm.text_yrangeLow,h.tm.edit_yrangeLow,h.tm.text_yrangeUp,...
        h.tm.edit_yrangeUp],'enable','on');
else
    set([h.tm.text_yrangeLow,h.tm.edit_yrangeLow,h.tm.text_yrangeUp,...
        h.tm.edit_yrangeUp],'enable','off');
end

if calc==1 || calc==6 % trajectories
    set([h.tm.text_conf1,h.tm.text_conf2,h.tm.popupmenu_units,...
        h.tm.popupmenu_cond,h.tm.edit_conf1,h.tm.text_and,...
        h.tm.edit_conf2],'enable','on');

    cond = get(h.tm.popupmenu_cond,'value');
    if cond==3 % between
        set([h.tm.text_and,h.tm.edit_conf2],'enable','on');
    else
        set([h.tm.text_and,h.tm.edit_conf2],'enable','off');
    end

else
    set([h.tm.text_conf1,h.tm.text_conf2,h.tm.popupmenu_units,...
        h.tm.popupmenu_cond,h.tm.edit_conf1,h.tm.text_and,...
        h.tm.edit_conf2],'enable','off');
end

disp('sort molecules...');
molIncl = ud_popCalc(h_fig);
disp('sorting complete!');

drawMask_subpop(h_fig,molIncl);

nMol = sum(molIncl);
str_mol = cat(2,'subgroup size: ',num2str(nMol),' molecule');
if nMol>1
    str_mol = cat(2,str_mol,'s');
end
set(h.tm.text_Npop,'string',str_mol);

if nMol==0
    set(h.tm.pushbutton_saveRange,'enable','off');

else
    set(h.tm.pushbutton_saveRange,'enable','on');
end

update_taglist_AS(h_fig);

if R==0
    set([h.tm.pushbutton_dismissRange,h.tm.listbox_ranges,h.tm.text_pop,...
        h.tm.text_tag,h.tm.pushbutton_addTag2pop,h.tm.popupmenu_defTagPop,...
        h.tm.listbox_popTag,h.tm.pushbutton_remPopTag,...
        h.tm.pushbutton_applyTag],'enable','off');

else
    set([h.tm.pushbutton_dismissRange,h.tm.listbox_ranges,h.tm.text_pop,...
        h.tm.text_tag,h.tm.pushbutton_addTag2pop,h.tm.popupmenu_defTagPop,...
        h.tm.listbox_popTag,h.tm.pushbutton_remPopTag,...
        h.tm.pushbutton_applyTag],'enable','on');
end
   
