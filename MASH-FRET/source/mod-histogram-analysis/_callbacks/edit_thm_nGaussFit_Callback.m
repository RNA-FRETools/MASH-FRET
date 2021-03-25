function edit_thm_nGaussFit_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    tag = p.curr_tag(proj);
    prm = p.proj{proj}.prm{tag,tpe};
    K = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(K));
    if ~(numel(K)==1 && ~isnan(K) && K>0)
        setContPan(['The number of Gaussians should be a positive ' ...
            'integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    elseif K~=size(prm.thm_start{3},1)
        set(obj, 'BackgroundColor', [1 1 1]);
        if size(prm.thm_start{3},1)<K
            states = linspace(0,1,K+2);
            states = states(2:end-1);
            thm_start = prm.thm_start{3};
            for i = size(thm_start,1)+1:K
                thm_start(i,:) = thm_start(i-1,:);
                thm_start(i,5) = states(i);
            end
            prm.thm_start{3} = thm_start;
        end
        prm.thm_start{3} = prm.thm_start{3}(1:K,:);
        prm.thm_res(2,1:3) = {[] [] []};
        p.proj{proj}.prm{tag,tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end