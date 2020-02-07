function set_S_transitionRates(J,k,h_fig)
% set_S_transitionRates(J,k,h_fig)
%
% Set transition rate matrix to proper values and update interface parameters
%
% J: number of states
% k: [5-by-5] transiton rate matrix
% h_fig: handle to main figure

h = guidata(h_fig); % needed in eval()

for j = 1:J
    for j2 = 1:J
        if j2==j
            continue
        end
        h_edit = eval(cat(2,'h.edit',num2str(j),num2str(j2)));
        set(h_edit,'string',num2str(k(j,j2)));
        edit_kinCst_Callback(h_edit,[],h_fig);
    end
end