function ud_sPanel(h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
isS = isfield(h.itgExpOpt,'popupmenu_Spairs');
if ~isS
    return
end

% get excitation wavelengths
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i});
end

% set channel popupmenu string
nFRET = size(p{3},1);
if nFRET>0
    str_pairs = {};
    for fret = 1:nFRET
        str_pairs = cat(2,str_pairs,cat(2,p{7}{2}{p{3}(fret,1)},'/',...
            p{7}{2}{p{3}(fret,2)}));
    end
    val = get(h.itgExpOpt.popupmenu_Spairs,'value');
    if val>nFRET
        val = nFRET;
    end
else
    str_pairs = 'no FRET pair';
    val = 1;
end
set(h.itgExpOpt.popupmenu_Spairs, 'String', str_pairs, 'Value', val);

% build S list string and S default colors
rgb_Smin = [0,0,1];
rgb_Smax = [1,1,1];
str_lst = {};
for s = 1:size(p{4},1)
    str_lst = [str_lst ['S ' p{7}{2}{p{4}(s,1)} p{7}{2}{p{4}(s,2)}]];
    if s > size(p{5}{3},1)
        if s>1
            p{5}{3}(s,:) = mean([p{5}{3}(s-1,:);rgb_Smax],1);
        else
            p{5}{3}(s,:) = rgb_Smin;
        end
    end
end

% update list
val = get(h.itgExpOpt.listbox_Scalc, 'Value');
set(h.itgExpOpt.listbox_Scalc, 'Value', 1);
set(h.itgExpOpt.listbox_Scalc, 'String', str_lst);
if val<=numel(str_lst) && val>0
    set(h.itgExpOpt.listbox_Scalc, 'Value', val);
else
    set(h.itgExpOpt.listbox_Scalc, 'Value', numel(str_lst));
end

% save colors
guidata(h.figure_itgExpOpt,p);

% update color panel
str_clrChan = getStrPop('DTA_chan',{p{7}{2} p{3} p{4} exc p{5}});
val_clrChan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if val_clrChan > size(str_clrChan,2)
    val_clrChan = size(str_clrChan,2);
end
set(h.itgExpOpt.popupmenu_clrChan, 'Value', val_clrChan, 'String', ...
  str_clrChan);
popupmenu_clrChan_Callback(h.itgExpOpt.popupmenu_clrChan, [], h_fig);