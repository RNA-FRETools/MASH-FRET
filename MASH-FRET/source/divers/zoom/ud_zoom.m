function ud_zoom(obj, evd, action, h_fig)

h = guidata(h_fig);
curr_axes = get(h_fig, 'CurrentAxes');

switch action
    
    case 'reset'
        if sum(double(curr_axes == ...
                [h.axes_movie, h.axes_example_mov]))
            axis(curr_axes, 'image');

        elseif sum(double(curr_axes == [h.axes_top h.axes_topRight ...
                h.axes_bottom h.axes_bottomRight]))
            p = h.param.ttPr;
            proj = p.curr_proj;
            mol = p.curr_mol(proj);
            axes.axes_traceTop = h.axes_top;
            axes.axes_histTop = h.axes_topRight;
            axes.axes_traceBottom = h.axes_bottom;
            axes.axes_histBottom = h.axes_bottomRight;
            
            plotData(mol, p, axes, p.proj{proj}.prm{mol}, 1);
            
        elseif curr_axes == h.axes_TDPcmap
            ylim(curr_axes, 'auto');
            xlim(curr_axes, [0 100]);

        elseif isfield(h, 'axes_subImg') && ...
                sum(double(isfield(h, 'axes_subImg'))) && ...
                sum(double(curr_axes == h.axes_subImg))
            axes = h.axes_subImg;
            p = h.param.ttPr;
            proj = p.curr_proj;
            mol = p.curr_mol(proj);
            
            p = plotSubImg(mol, p, axes);
            
            h = guidata(h_fig);
            h.param.ttPr = p;

        elseif curr_axes == h.axes_hist1 || curr_axes == h.axes_hist2 ||...
                curr_axes == h.axes_thm_BIC
            ud_thmPlot(h_fig);
            
        elseif curr_axes == h.axes_TDPplot1
            updateTAplots(h_fig);
            
        elseif curr_axes == h.axes_tdp_BIC
            p = h.param.TDP;
            proj = p.curr_proj;
            tag = p.curr_tag(proj);
            tpe = p.curr_type(proj);
            plotBIC_TA(h.axes_tdp_BIC,p.proj{proj}.prm{tag,tpe});
            
        else
            xlim(curr_axes, 'auto');
            ylim(curr_axes, 'auto');
        end
        
    case 'pan'
        set(h.TTpan, 'Enable', 'on')
        set(h.zMenu_pan, 'Checked', 'on');
        set(h.TTzoom, 'Enable', 'off')
        set(h.zMenu_zoom, 'Checked', 'off');
        
        ud = get(h.axes_TDPplot1,'userdata');
        if ~isempty(ud{1}) && numel(ud{1})==2
            if ishandle(ud{1}(1))
                delete(ud{1}(1));
            end
            if ishandle(ud{1}(2))
                delete(ud{1}(2));
            end
        end
        
        % reset cluster selection tool
        set(h.tooglebutton_TDPmanStart,'userdata',1);
        ud_clustersPan(h_fig)
        
    case 'zoom'
        set(h.TTpan, 'Enable', 'off')
        set(h.zMenu_pan, 'Checked', 'off');
        set(h.TTzoom, 'Enable', 'on')
        set(h.zMenu_zoom, 'Checked', 'on');
        
        ud = get(h.axes_TDPplot1,'userdata');
        if ~isempty(ud{1}) && numel(ud{1})==2
            if ishandle(ud{1}(1))
                delete(ud{1}(1));
            end
            if ishandle(ud{1}(2))
                delete(ud{1}(2));
            end
        end
        
        % reset cluster selection tool
        set(h.tooglebutton_TDPmanStart,'userdata',1);
        ud_clustersPan(h_fig)
end
