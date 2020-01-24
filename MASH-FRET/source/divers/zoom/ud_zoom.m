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
            p = h.param.TDP;
            proj = p.curr_proj;
            tpe = p.curr_type(proj);
            tag = p.curr_tag(proj);
            prm = p.proj{proj}.prm{tag,tpe};
            TDP = prm.plot{2};

            plot_prm{1} = prm.plot{1}(1,[2 3]); % TDP x & y limits
            plot_prm{2} = prm.plot{1}(1,1); % TDP x & y binning
            plot_prm{3} = prm.plot{1}(3,2); % conv./not TDP with Gaussian, o^2=0.0005
            plot_prm{4} = prm.plot{1}(3,3); % normalize/not TDP z-axis
            plot_prm{5} = prm.clst_start{3}; % cluster colours
            
            meth = prm.clst_start{1}(1);
            a = [];
            o = [];
            mu = [];
            clust = [];
            if ~isempty(prm.clst_res{1})
                if meth == 2 % GM
                    J = get(h.popupmenu_tdp_model,'Value')+1;
                    a = prm.clst_res{1}.a{J};
                    o = prm.clst_res{1}.o{J};
                else
                    J = prm.clst_res{3};
                end
                mu = prm.clst_res{1}.mu{J};
                clust = prm.clst_res{1}.clusters{J};
            end
                    
            clust_prm{1} = mu;
            clust_prm{2} = clust;
            clust_prm{3}.a = a;
            clust_prm{3}.o = o;
            
            plotTDP(curr_axes,h.colorbar_TA,TDP,plot_prm,clust_prm,h_fig);
            
        else
            xlim(curr_axes, 'auto');
            ylim(curr_axes, 'auto');
        end
        
    case 'pan'
        set(h.TTpan, 'Enable', 'on')
        set(h.zMenu_pan, 'Checked', 'on');
        set(h.TTzoom, 'Enable', 'off')
        set(h.zMenu_zoom, 'Checked', 'off');
        
        % reset cluster selection tool
        set(h.tooglebutton_TDPmanStart,'userdata',0);
        ud_selectToolPan(h_fig)
        
    case 'zoom'
        set(h.TTpan, 'Enable', 'off')
        set(h.zMenu_pan, 'Checked', 'off');
        set(h.TTzoom, 'Enable', 'on')
        set(h.zMenu_zoom, 'Checked', 'on');
        
        % reset cluster selection tool
        set(h.tooglebutton_TDPmanStart,'userdata',0);
        ud_selectToolPan(h_fig)
end
