function ud_fretPanel(h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
isFRET = isfield(h.itgExpOpt,'popupmenu_FRETfrom');
if ~isFRET
    return
end

% get excitation wavelengths
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i});
end

% set channel popupmenu string
if isfield(h.itgExpOpt, 'popupmenu_FRETfrom')
    set(h.itgExpOpt.popupmenu_FRETfrom, 'String', p{7}{2});
end
if isfield(h.itgExpOpt, 'popupmenu_FRETto')
    set(h.itgExpOpt.popupmenu_FRETto, 'String', p{7}{2});
end

% build FRET list string and FRET default colors
rgb_Emin = [0,0,0];
rgb_Emax = [1,1,1];
str_lst = {};
for l = 1:size(p{3},1)
    str_lst = [str_lst ['FRET ' p{7}{2}{p{3}(l,1)} '>' ...
        p{7}{2}{p{3}(l,2)}]];
    if l > size(p{5}{2},1)
        if l>1
            p{5}{2}(l,:) = mean([p{5}{2}(l-1,:);rgb_Emax],1);
        else
            p{5}{2}(l,:) = rgb_Emin;
        end
    end
end

% update list
val = get(h.itgExpOpt.listbox_FRETcalc, 'Value');
set(h.itgExpOpt.listbox_FRETcalc, 'Value', 1);
set(h.itgExpOpt.listbox_FRETcalc, 'String', str_lst);
if val<=numel(str_lst) && val>0
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', val);
else
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', numel(str_lst));
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