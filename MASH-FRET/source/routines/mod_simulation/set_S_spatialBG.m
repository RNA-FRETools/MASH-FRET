function set_S_spatialBG(bg,I,w,pth,img_file,h_fig)
% set_S_spatialBG(bg,I,w,img_file,h_fig)
%
% Set background spatial distribution to proper values and update interface
%
% bg: index of distribution type in list
% I: [1-by-2] background intensities in donor and accpetor channels
% w: [1-by-2] Gaussian widths in the x- and y-directions (in pixels)
% pth: source directory of background image
% img_file: background image file
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.popupmenu_simBg_type,'value',bg);
popupmenu_simBg_type_Callback(h.popupmenu_simBg_type,[],h_fig);

set(h.edit_bgInt_don,'string',num2str(I(1)));
edit_bgInt_don_Callback(h.edit_bgInt_don,[],h_fig);

set(h.edit_bgInt_acc,'string',num2str(I(2)));
edit_bgInt_acc_Callback(h.edit_bgInt_acc,[],h_fig);

if bg==2
    set(h.edit_TIRFx,'string',num2str(w(1)));
    edit_TIRFx_Callback(h.edit_TIRFx,[],h_fig);

    set(h.edit_TIRFy,'string',num2str(w(2)));
    edit_TIRFy_Callback(h.edit_TIRFy,[],h_fig);
    
elseif bg==3
    pushbutton_S_impBgImg_Callback({pth,img_file},[],h_fig);
end


