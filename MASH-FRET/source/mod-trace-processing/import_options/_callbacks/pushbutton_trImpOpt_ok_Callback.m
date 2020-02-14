function pushbutton_trImpOpt_ok_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

% adjust import parameters
nChan_imp = m{1}{1}(7);
for i = 1:nChan_imp
    if i > size(m{3}{3}{1},1)
        m{3}{3}{1}(i,1:2) = m{3}{3}{1}(i-1,1:2) + 2;
    end
end

% save podifications
h.param.ttPr.impPrm = m;
guidata(h_fig, h);

% close option window
close(h.figure_trImpOpt);


