function ud_subImg(h_fig)
h = guidata(h_fig);
p = h.param.ttPr.proj;
if ~isempty(p)
    proj = h.param.ttPr.curr_proj;
    mol = h.param.ttPr.curr_mol(proj);
    refocus = p{proj}.fix{1}(5);
    exc = p{proj}.fix{3}(5);
    chan = p{proj}.fix{3}(6);
    if p{proj}.is_coord
        p_panel = p{proj}.fix{1};
        meth = p{proj}.prm{mol}{3}{2}(exc,chan);
        subdim = p{proj}.prm{mol}{3}{3}{exc,chan}(meth,2);
        set(h.popupmenu_subImg_exc, 'Value', p_panel(1));
        set(h.checkbox_refocus, 'Value', refocus);
        set(h.edit_subImg_dim, 'String', num2str(subdim), ...
            'BackgroundColor', [1 1 1]);
        set(h.slider_brightness, 'Value', (p_panel(3)+1)/2);
        set(h.slider_contrast, 'Value', (p_panel(4)+1)/2);
        set(h.text_brightness, 'String', ['Brightness: ' ...
            num2str(100*p_panel(3)) '%']);
        set(h.text_contrast, 'String', ['Contrast: ' ...
            num2str(100*p_panel(4)) '%']);
    end
end