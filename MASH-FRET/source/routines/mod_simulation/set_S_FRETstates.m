function set_S_FRETstates(J,FRET,wFRET,h_fig)
% set_S_FRETstates(J,FRET,wFRET,h_fig)
%
% Set FRET state configuration to proper values and update interface parameters
%
% J: number of states
% FRET: [J-by-1] FRET values
% wFRET: [J-by-1] deviations from FRET values
% h_fig: handle to main figure

h = guidata(h_fig);

for j = 1:J
    set(h.popupmenu_states,'value',j);
    popupmenu_states_Callback(h.popupmenu_states,[],h_fig);
    
    set(h.edit_stateVal,'string',num2str(FRET(j)));
    edit_stateVal_Callback(h.edit_stateVal,[],h_fig);
    
    set(h.edit_simFRETw,'string',num2str(wFRET(j)));
    edit_simFRETw_Callback(h.edit_simFRETw,[],h_fig);
end