function pushbutton_TDPautoStart_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    prm = p.proj{proj}.prm{tpe};
    meth = prm.clst_start{1}(1);
    
    if meth == 1 % kmean
        Kmax = prm.clst_start{1}(3);
        min_x = prm.plot{1}(1,2);
        max_x = prm.plot{1}(1,3);
        min_y = prm.plot{1}(2,2);
        max_y = prm.plot{1}(2,3);

        delta = (max([max_x max_y])-min([min_x min_y]))/(Kmax+1);
        
        prm.clst_start{2}(:,1) = min([min_x min_y]) + delta*(1:Kmax)';
        prm.clst_start{2}(:,2) = Inf*ones(Kmax,1);
        for i = 1:Kmax*(Kmax-1)
            if i > size(prm.clst_start{3},1)
                prm.clst_start{3}(i,:) = p.colList(i,:);
            end
        end
        
        p.proj{proj}.prm{tpe} = prm;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end