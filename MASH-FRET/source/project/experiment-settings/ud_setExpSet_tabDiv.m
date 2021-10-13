function ud_setExpSet_tabDiv(h_fig)

% retrieve interface content
h = guidata(h_fig);

% retrieve project content
proj = h_fig.UserData;

% refresh project title
set(h.edit_projName,'string',proj.exp_parameters{1,2});

% refresh video sampling time
if proj.spltime_from_video
    set(h.edit_splTime,'enable','inactive');
else
    set(h.edit_splTime,'enable','on');
end
set(h.edit_splTime,'string',proj.frame_rate);

% refresh molecule name
set(h.edit_molName,'string',proj.exp_parameters{2,2});

% refresh experimental conditions
tbldat = get(h.table_cond,'data');
tbldat(1:size(proj.exp_parameters(3:end,:),1),:) = ...
    proj.exp_parameters(3:end,:);
set(h.table_cond,'data',tbldat);

% refresh plot colors
str_pop = getStrPop('DTA_chan',{proj.labels,proj.FRET,proj.S,...
    proj.excitations,proj.colours});
chan = get(h.popup_chanClr,'value');
if chan>numel(str_pop)
    chan = numel(str_pop);
end
set(h.popup_chanClr,'string',str_pop,'value',chan);

nFRET = size(proj.FRET,1);
nS = size(proj.S,1);
if chan<=nFRET
    clr = proj.colours{2}(chan,:);
elseif chan<=(nFRET+nS)
    s = chan-nFRET;
    clr = proj.colours{3}(s,:);
else
    I = chan-nFRET-nS;
    l = ceil(I/proj.nb_channel);
    c = I-(l-1)*proj.nb_channel;
    clr = proj.colours{1}{l,c};
end
if sum(clr)>=1.5
    fntclr = 'black';
else
    fntclr = 'white';
end
set(h.push_clr,'backgroundcolor',clr,'foregroundcolor',fntclr);
