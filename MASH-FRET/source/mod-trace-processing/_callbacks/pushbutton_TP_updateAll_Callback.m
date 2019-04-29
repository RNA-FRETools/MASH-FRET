function pushbutton_TP_updateAll_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    h_fig = h.figure_MASH;
    proj = p.curr_proj;
    nMol = size(p.proj{proj}.coord_incl,2);
    
    setContPan('Process all molecule data ...','process',h_fig);
    
    % loading bar parameters-----------------------------------------------
      err = loading_bar('init',h_fig ,nMol,...
          'Process all molecule data ...');
      if err
          return;
      end
      h = guidata(h_fig);
      h.barData.prev_var = h.barData.curr_var;
      guidata(h_fig, h);
    % ---------------------------------------------------------------------
    
    try
        for m = 1:nMol
            % display action
            disp(cat(2,'process data of molecule n:°',num2str(m)));

            % process data
            p = updateTraces(h_fig, 'ttPr', m, p, []);

            % loading bar update-----------------------------------------------
              err = loading_bar('update',h_fig);
              if err
                  h = guidata(h_fig);
                  h.param.ttPr = p;
                  guidata(h_fig, h);
                  return;
              end
            % -----------------------------------------------------------------

        end
        
    catch err
        updateActPan(['An error occurred during processing of molecule n:°' ...
            num2str(m) ':\n' err.message],h_fig,'error');
        for i = 1:size(err.stack,1)
            disp(['function: ' err.stack(i,1).name ', line: ' ...
                num2str(err.stack(i,1).line)]);
        end
        h = guidata(h_fig);
        h.param.ttPr = p;
        guidata(h_fig, h);
        return;
    end
    
    % collect processed data
    h = guidata(h_fig);
    h.param.ttPr = p;
    guidata(h_fig, h);
    
    loading_bar('close',h_fig);
    
    setContPan('Update completed !','success',h_fig);
    
end