function edit_thm_threshNb_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    prm = p.proj{proj}.prm{tag,tpe};
    N = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(N));
    if ~(numel(N)==1 && ~isnan(N) && N>0)
        setContPan(['The number of thresholds should be a positive ' ...
            'integer'], 'error', h_fig);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    elseif N~=numel(prm.thm_start{2})
        set(obj, 'BackgroundColor', [1 1 1]);
        if numel(prm.thm_start{2})<N
            thm_start = prm.thm_start{2};
            thresh = (linspace(thm_start(end),1.2,N+2))';
            thresh = thresh(2:end-1,1);
            for i = size(thm_start,1)+1:N
                thm_start(i,1) = thresh(i,1);
            end
            prm.thm_start{2} = thm_start;
        end
        prm.thm_start{2} = prm.thm_start{2}(1:N,:);
        prm.thm_res(1,1:3) = {[] [] []};
        p.proj{proj}.prm{tag,tpe} = prm;
        h.param.thm = p;
        guidata(h_fig, h);
        updateFields(h_fig, 'thm');
    end
end