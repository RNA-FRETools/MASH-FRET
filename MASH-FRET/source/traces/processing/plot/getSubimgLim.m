function lim = getSubimgLim(coord, dimImg, limMov)

lim_img_x = [coord(1)-dimImg/2 coord(1)+dimImg/2];
lim_img_y = [coord(2)-dimImg/2 coord(2)+dimImg/2];

if lim_img_x(1) < limMov(1,1)
    lim_img_x(1) = limMov(1,1);
    lim_img_x(2) = limMov(1,1) + dimImg;
    
elseif lim_img_x(2) > limMov(1,2)
    lim_img_x(2) = limMov(1,2);
    lim_img_x(1) = limMov(1,2) - dimImg;
end
if lim_img_y(1) < limMov(2,1)
    lim_img_y(1) = limMov(2,1);
    lim_img_y(2) = limMov(2,1) + dimImg;

elseif lim_img_y(2) > limMov(2,2)
    lim_img_y(2) = limMov(2,2);
    lim_img_y(1) = limMov(2,2) - dimImg;
end

lim = [lim_img_x;lim_img_y];