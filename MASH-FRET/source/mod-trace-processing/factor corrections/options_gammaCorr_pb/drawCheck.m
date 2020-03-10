function drawCheck(h_fig2)

q = guidata(h_fig2);
icons = get(q.axes_pbGamma,'UserData');

if q.prm{2}(8)==1
    icon = icons{1,1};
    alpha = icons{1,2};
%     set(q.checkbox_showCutoff, 'Enable', 'on')
    set([q.pushbutton_save,q.text_gamma,q.edit_gamma], 'Enable', 'on')
else
    icon = icons{2,1};
    alpha = icons{2,2};
%     set(q.checkbox_showCutoff, 'Enable', 'off')
    set([q.pushbutton_save,q.text_gamma,q.edit_gamma], 'Enable', 'off')
end

% cancelled by MH
%     drawCutoff(h_fig,p.proj{proj}.curr{mol}{6}{3}(fret,7) & ...
%         p.proj{proj}.curr{mol}{6}{3}(fret,1));

image(q.axes_pbGamma, icon, 'alphaData', alpha);
set(q.axes_pbGamma, 'Visible', 'off', 'UserData', icons);

% cancelled by MH, 15.1.2020
% % draw the cutoff line; added by FS, 26.4.2018
% function drawCutoff(h_fig, drawIt)
% h = guidata(h_fig);
% p = h.param.ttPr;
% proj = p.curr_proj;
% mol = p.curr_mol(proj);
% fret = p.proj{proj}.fix{3}(8);
% p.proj{proj}.curr{mol}{6}{3}(fret,1) = drawIt;
% set(q.checkbox_showCutoff, 'Value', drawIt)
% h.param.ttPr = p;
% guidata(h_fig, h)
% % updateFields(h_fig, 'ttPr');
% 
% axes.axes_traceTop = h.axes_top;
% axes.axes_histTop = h.axes_topRight;
% axes.axes_traceBottom = h.axes_bottom;
% axes.axes_histBottom = h.axes_bottomRight;
% if p.proj{proj}.is_movie && p.proj{proj}.is_coord
%     axes.axes_molImg = h.axes_subImg;
% end
% plotData(mol, p, axes, p.proj{proj}.curr{mol}, 1);


