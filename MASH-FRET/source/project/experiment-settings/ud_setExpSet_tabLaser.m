function ud_setExpSet_tabLaser(h_fig)

h = guidata(h_fig);

proj = h_fig.UserData;

% set number of lasers
set(h.edit_nExc,'string',num2str(proj.nb_excitations));

% set laser wavelengths and emitter popup lists
str_pop = cell(1,proj.nb_channel+1);
str_pop{1} = 'none';
for c = 1:proj.nb_channel
    str_pop{c+1} = proj.labels{c};
end
for l = 1:proj.nb_excitations
    if isfield(h,'edit_excWl') && l<=numel(h.edit_excWl) && ...
            ishandle(h.edit_excWl(l))
        set(h.edit_excWl(l),'string',num2str(proj.excitations(l)));
        set(h.popup_excEm(l),'string',str_pop,'value',1);

        c = find(proj.chanExc==proj.excitations(l));
        if numel(c)==1 && proj.chanExc(c)>0
            set(h.popup_excEm(l),'value',c+1);
        end
    end
end
set(h.edit_excWl,'backgroundcolor',[1,1,1]);

% set "Next" button
allset = all(proj.excitations>0) & ...
    numel(unique(proj.excitations(proj.excitations>0)))==...
    numel(proj.excitations(proj.excitations>0));
if allset
    set(h.push_nextExc,'enable','on');
else
    set(h.push_nextExc,'enable','off');
end

