function ud_TDPplot(h_fig)

% Last update by MH, 26.1.2020: do not update plot anymore (done only when pressing "update") and adapt to current (curr) and last applied (prm) parameters
% update by MH, 12.12.2019: give the colorbar's handle in plotTDP's input to prevent dependency on MASH main figure's handle and allow external use.

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_TA_transitionDensityPlot;
if ~prepPanel(h.uipanel_TA_transitionDensityPlot,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;
curr = p.proj{proj}.TA.curr{tag,tpe};

nFRET = size(FRET,1);
nS = size(S,1);
nTag = size(tagNames,2);

% collect processing parameters
bin = curr.plot{1}(1,1);
lim = curr.plot{1}(1,2:3);
gconv = curr.plot{1}(3,2);
norm = curr.plot{1}(3,3);
onecount = curr.plot{1}(4,1);
rearrng = curr.plot{1}(4,2);
incldiag = curr.plot{1}(4,3);
TDP = curr.plot{2};
cmap = curr.plot{4};

% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = cat(2,str_pop,cat(2,labels{c},' at ',num2str(exc(l)),...
            'nm'));
    end
end
for n = 1:nFRET
    str_pop = cat(2,str_pop,cat(2,'FRET ',labels{FRET(n,1)},'>',...
        labels{FRET(n,2)}));
end
for n = 1:nS
    str_pop = cat(2,str_pop,cat(2,'S ',labels{S(n,1)},'>',labels{S(n,2)}));
end
set(h.popupmenu_TDPdataType,'value',tpe,'string',str_pop);

% build tag list
str_pop = getStrPopTags(tagNames,colorlist);
if nTag>1
    str_pop = cat(2,'all molecules',str_pop);
end
set(h.popupmenu_TDPtag,'string',str_pop,'value',tag);

if numel(TDP)==1 && isnan(TDP)
    setProp(get(h_pan,'children'),'enable','off');
    set([h.text_TDPdataType,h.popupmenu_TDPdataType,h.text_TDPtag,...
        h.popupmenu_TDPtag],'enable','on');
    return
end

set(h.edit_TDPbin, 'String', num2str(bin));
set(h.edit_TDPmin, 'String', num2str(lim(1)));
set(h.edit_TDPmax, 'String', num2str(lim(2)));
set(h.checkbox_TDPgconv, 'Value', gconv);
set(h.checkbox_TDPnorm, 'Value', norm);
set(h.checkbox_TDP_onecount, 'Value', onecount);
set(h.checkbox_TDPignore, 'Value', rearrng);
set(h.checkbox_TDP_statics, 'Value', incldiag);

% adjust and save colormap
p.proj{proj}.TA.curr{tag,tpe}.plot{4} = colormap(h.axes_TDPplot1);
p.proj{proj}.TA.prm{tag,tpe}.plot{4} = colormap(h.axes_TDPplot1);
set(h.axes_TDPplot1, 'Color', cmap(1,:));
setCmap(h_fig, cmap);

guidata(h_fig,h);
