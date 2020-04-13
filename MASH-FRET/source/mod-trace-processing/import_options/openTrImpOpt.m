function openTrImpOpt(obj, evd, h_fig)
% openTrImpOpt([],[],h_fig)
%
% Open import options window for ASCII traces import in module Trace processing and Transition analysis
% 
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param.ttPr.impPrm;
if size(p{1}{1},2) < 12
    p{1}{1} = [1 0 0 1 1 0 2 1 0 5 5 0];
    h.param.ttPr.impPrm = p;
    guidata(h_fig, h);
end

% adjust import parameters
nChan_imp = p{1}{1}(7);
for i = 1:nChan_imp
    if i > size(p{3}{3}{1},1)
        p{3}{3}{1}(i,1:2) = p{3}{3}{1}(i-1,1:2) + 2;
    end
end

buildWinTrOpt(p, h_fig);


