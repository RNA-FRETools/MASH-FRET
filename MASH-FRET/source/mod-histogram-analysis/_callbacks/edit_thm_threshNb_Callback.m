function edit_thm_threshNb_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};
    
N = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(N));
if ~(numel(N)==1 && ~isnan(N) && N>0)
    setContPan('The number of thresholds should be a positive integer', ...
        'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end
if N==numel(curr.thm_start{2})
    return
end

if numel(curr.thm_start{2})<N
    thm_start = curr.thm_start{2};
    thresh = (linspace(thm_start(end),1.2,N+2))';
    thresh = thresh(2:end-1,1);
    for i = size(thm_start,1)+1:N
        thm_start(i,1) = thresh(i,1);
    end
    curr.thm_start{2} = thm_start;
end
curr.thm_start{2} = curr.thm_start{2}(1:N,:);
curr.thm_res(1,1:3) = {[] [] []};

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
