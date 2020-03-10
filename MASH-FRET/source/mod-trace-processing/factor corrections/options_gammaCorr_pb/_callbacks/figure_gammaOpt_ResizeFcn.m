function figure_gammaOpt_ResizeFcn(obj, ~)

% % default
% mg = 10;
% 
% q = guidata(obj);
% if ~isstruct(q)
%     return
% end
% 
% h_axes = q.axes_traces;
% pospan = getPixPos(q.uipanel_photobleach);
% posed = getPixPos(q.edit_pair);
% postxt = getPixPos(q.text_data);
% 
% y = postxt(2)+postxt(4)+mg;
% x = mg;
% waxes = pospan(3)-2*mg;
% haxes = posed(2)-mg-y;
% 
% un = get(h_axes, 'Units');
% set(h_axes,'Units','pixels');
% 
% pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'TightInset'),'traces');
% 
% set(h_axes,'Position',pos);
% set(h_axes,'Units',un);

