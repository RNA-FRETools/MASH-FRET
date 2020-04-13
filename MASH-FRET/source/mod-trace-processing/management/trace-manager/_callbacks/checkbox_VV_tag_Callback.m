function checkbox_VV_tag_Callback(obj,evd,h_fig,t)

h = guidata(h_fig);
tagClr =  h.tm.molTagClr;
if sum(double((hex2rgb(tagClr{t})/255)>0.5))==3
    fntClr = 'black';
else
    fntClr = 'white';
end

switch get(obj,'value')
    case 1
        set(obj,'fontweight','bold');
        set(h.tm.edit_VV_tag(t),'enable','inactive','backgroundcolor',...
        hex2rgb(tagClr{t})/255,'foregroundcolor',fntClr);
    case 0
        set(obj,'fontweight','normal');
        set(h.tm.edit_VV_tag(t),'enable','off','foregroundcolor','black',...
            'backgroundcolor','white');
end

plotData_videoView(h_fig);

