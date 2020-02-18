function pushbutton_TP_updateAll_Callback(obj, evd, h_fig)

% Last update by MH, 14.1.2020: separate trace update into 3 successive processes (1) update all intensity correction (2) calculate gamma factors (3) discretize traces; this allows stable ES histogram for linear regression

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    nMol = size(p.proj{proj}.coord_incl,2);
    
    setContPan('Process all molecule data ...','process',h_fig);
    
    % loading bar parameters-----------------------------------------------
      err = loading_bar('init',h_fig ,3*nMol,'Process all molecule ...');
      if err
          return;
      end
      h = guidata(h_fig);
      h.barData.prev_var = h.barData.curr_var;
      guidata(h_fig, h);
    % ---------------------------------------------------------------------
    
    try
        % update all intensities
        opt = cell(1,nMol);
        for m = 1:nMol
            % display action
            disp(cat(2,'process data of molecule n:°',num2str(m)));

            % cancelled by MH, 14.1.2020
%             % process data
%             p = updateTraces(h_fig, 'ttPr', m, p, []);
            
            % added by MH, 14.1.2020
            % reset traces according to changes in parameters
            [p,opt{m}] = resetMol(m, 'ttPr', p);
            p = plotSubImg(m, p, []);
            [p,~] = updateIntensities(opt{m},m,p);
            
            % loading bar update-------------------------------------------
              err = loading_bar('update',h_fig);
              if err
                  h = guidata(h_fig);
                  h.param.ttPr = p;
                  guidata(h_fig, h);
                  return
              end
            % -------------------------------------------------------------
        end
        
        % added by MH, 14.1.2020
        % calculate correction factors and discretize traces
        for m = 1:nMol
            if strcmp(opt{m}, 'gamma') || strcmp(opt{m}, 'debleach') || ...
                    strcmp(opt{m}, 'denoise') || strcmp(opt{m}, 'cross') || ...
                    strcmp(opt{m}, 'ttBg') || strcmp(opt{m}, 'ttPr')
                p = updateGammaFactor(h_fig,m,p);
            end
            % loading bar update-------------------------------------------
              err = loading_bar('update',h_fig);
              if err
                  h = guidata(h_fig);
                  h.param.ttPr = p;
                  guidata(h_fig, h);
                  return
              end
            % -------------------------------------------------------------
        end
        for m = 1:nMol
            p = updateStateSequences(h_fig, m, p);

            % loading bar update-------------------------------------------
              err = loading_bar('update',h_fig);
              if err
                  h = guidata(h_fig);
                  h.param.ttPr = p;
                  guidata(h_fig, h);
                  return
              end
            % -------------------------------------------------------------
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
    
    updateFields(h_fig,'ttPr');
    
    setContPan('Update completed !','success',h_fig);
    
end