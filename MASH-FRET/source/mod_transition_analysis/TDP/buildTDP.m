function [p,ok,str] = buildTDP(p,tag,tpe)

% collect interface parameters
proj = p.curr_proj;
prm = p.proj{proj}.prm{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};

if isfield(prm,'plot') && isequal(prm.plot,curr.plot)
    ok = 1;
    str = '';
    return
end

% make current settings the processing parameters at last update
prm.plot = curr.plot;

% processing parameters
xaxis = prm.plot{1}(1,:);
onecount = prm.plot{1}(4,1);
rearrng = prm.plot{1}(4,2);

% build TDP matrix
[TDP,dt_bin,ok,str] = getTDPmat(tpe, tag, [xaxis,onecount,rearrng], ...
    p.proj{proj});

prm.plot{2} = TDP;
prm.plot{3} = dt_bin;

% save modifications of processing parameters in current settings
curr.plot = prm.plot;

% save modifications
p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = curr;


