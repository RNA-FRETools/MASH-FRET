function plot_ESlinRegOpt(h_axes,ES,prm,fact)

elim = prm(2:3);
slim = prm(5:6);

imagesc(elim,slim,ES,'parent',h_axes);
if sum(sum(isnan(ES))) || ~sum(sum(ES))
    set(h_axes,'clim',[0 1]);
    return
end

set(h_axes,'clim',[min(min(ES)) max(max(ES))],'ydir','normal');

gamma = fact(1);
beta = fact(2);
SIG = beta*(1-gamma);
OME = 1+gamma*beta;

set(h_axes,'nextplot','add');
plot(h_axes,elim,OME+SIG*elim,'--w');
set(h_axes,'nextplot','replacechildren');

xlim(h_axes,elim);
ylim(h_axes,slim);


