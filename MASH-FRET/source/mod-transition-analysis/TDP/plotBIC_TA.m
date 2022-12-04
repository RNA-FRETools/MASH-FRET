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
bar(h_axes,1:Jmax,BICs);
if numel(BICs)==1
    ylim(h_axes,'auto');
else
    BICmin = min(BICs);
    BICmax = max(BICs);
    if BICmin==BICmax
        ylim(h_axes,BICmin+[-1,1]);
    else
        ylim(h_axes,[min(BICs) max(BICs)]);
    end
end
h_axes.XTick = 1:Jmax;
h_axes.XTickLabel = num2cell(num2str((1:Jmax)'))';
xlim(h_axes,[0,Jmax+1]);
xlabel(h_axes,'V');
ylabel(h_axes,'BIC');
