function ud_expTDPopt(h_fig)
h = guidata(h_fig);
q = h.expTDPopt;
p_exp = guidata(q.figure_expTDPopt);

TDPascii = p_exp{2}(1);
TDPimg = p_exp{2}(2);
TDPascii_fmt = p_exp{2}(3);
TDPimg_fmt = p_exp{2}(4);
TDPclust = p_exp{2}(5);

kinDtHist = p_exp{3}(1);
kinFit = p_exp{3}(2);
kinBoba = p_exp{3}(3);
figBoba = p_exp{3}(4);

set([q.checkbox_TDPascii q.checkbox_TDPimg ...
    q.checkbox_kinDthist q.checkbox_kinCurves q.checkbox_kinBOBA ...
    q.pushbutton_cancel q.pushbutton_next], 'Enable', 'on');

set(q.checkbox_TDPascii, 'Value', TDPascii);
set(q.checkbox_TDPimg, 'Value', TDPimg);
set(q.checkbox_TDPclust, 'Value', TDPclust);
set(q.checkbox_kinDthist, 'Value', kinDtHist);
set(q.checkbox_kinCurves, 'Value', kinFit);
set(q.checkbox_kinBOBA, 'Value', kinBoba);
set(q.checkbox_figBOBA, 'Value', figBoba);

if TDPascii
    set(q.popupmenu_TDPascii, 'Enable','on', 'Value',TDPascii_fmt);
else
    set(q.popupmenu_TDPascii, 'Enable','off');
end

if TDPimg
    set(q.popupmenu_TDPimg, 'Enable','on', 'Value',TDPimg_fmt);
else
    set(q.popupmenu_TDPimg, 'Enable','off');
end