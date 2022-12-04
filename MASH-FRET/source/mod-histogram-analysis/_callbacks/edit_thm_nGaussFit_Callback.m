function edit_thm_nGaussFit_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};

K = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(K));
if ~(numel(K)==1 && ~isnan(K) && K>0)
    setContPan(['The number of Gaussians should be a positive ' ...
        'integer'], 'error', h.figure_MASH);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

if K==size(curr.thm_start{3},1)
    return
end
if size(curr.thm_start{3},1)<K
    states = linspace(0,1,K+2);
    states = states(2:end-1);
    thm_start = curr.thm_start{3};
    for i = size(thm_start,1)+1:K
        thm_start(i,:) = thm_start(i-1,:);
        thm_start(i,5) = states(i);
    end
    curr.thm_start{3} = thm_start;
end
curr.thm_start{3} = curr.thm_start{3}(1:K,:);
curr.thm_res(2,1:3) = {[] [] []};

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
