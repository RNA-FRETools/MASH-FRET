function plotBIC_TA(h_axes,prm)

if ~(isfield(prm,'clst_res') && size(prm.clst_res,2)>=1 && ...
        isfield(prm.clst_res{1},'BIC') && ~isempty(prm.clst_res{1}.BIC))
    cla(h_axes);
    set(h_axes,'visible','off');
    return
end
Jmax = size(prm.clst_res{1}.BIC,2);
BICs = prm.clst_res{1}.BIC;

set(h_axes,'visible','on');
barh(h_axes,1:Jmax,BICs);
if numel(BICs)==1
    xlim(h_axes,'auto');
else
    xlim(h_axes,[min(BICs) mean(BICs)]);
end
ylim(h_axes,[0,Jmax+1]);
title(h_axes,'BIC');