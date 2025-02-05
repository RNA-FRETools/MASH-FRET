function id = getASdataindex(varargin)
% id = getASdataindex
% id = getASdataindex('framewise')
% id = getASdataindex('molwise')
% id = getASdataindex('statewise')
%
% Get index in structure dat3 that correspond to data listed in popup menus
% popupmenu_selectXval and popupmenu_selectYval. The returned index vector
% maps data in dat3 structure. This allows to increment the list of data to 
% calculate without modifying all places in the code where indexes are
% used.
%
% 1: original time traces (frame-wise): not in dat3
% 2: state trajectories (frame-wise): 1 in dat3
% 3: means (molecule-wise): 2 in dat3
% 4: minima (molecule-wise): 3 in dat3
% 5: maxima (molecule-wise): 4 in dat3
% 6: medians (molecule-wise): 5 in dat3
% 7: SNR (molecule-wise): 12 in dat3
% 8: nb. of states (molecule-wise): 6 in dat3
% 9: nb. of transitions (molecule-wise): 7 in dat3
% 10: mean state dwell time (molecule-wise): 8 in dat3
% 11: state values (state-wise): 9 in dat3
% 12: state dwell times (state-wise): 10 in dat3
% 13: state lifetimes (state-wise): 11 in dat3

id = [0,1,2,3,4,5,12,6,7,8,9,10,11];

if nargin>0
    switch varargin{1}
        case 'framewise'
            id = id(1:2);
        case 'molwise'
            id = id(3:10);
        case 'statewise'
            id = id(11:13);
        case 'discr'
            id = id([2,8:13]);
        otherwise
            disp(['getASdataindex: input argument must be ''framewise'',',...
                ' ''molwise'' or ''statewise''.']);
            id = [];
    end
end