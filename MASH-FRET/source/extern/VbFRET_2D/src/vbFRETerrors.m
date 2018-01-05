function  vbFRETerrors(flag)
%this function makes pop up windows for all the errors/warnings in vbFRET
%it takes the flag structure as input for which errors/warnings to
%generate. label is an optional variable which contains the file/trace that
%is responsible for the problem.

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

switch flag.type
    case 'importData'
        switch flag.problem
            % no variable name 'data'
            case 'no data'
                msgboxText{1} = sprintf('Unable to find traces in %s. Traces must be stored in a cell array named ''data''. Labels for the traces must be storred in a cell array named ''labels''. If no variable named ''labels'' can be located then traces will be labeled sequentially.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'error'));
            case 'not cell'
                msgboxText{1} = sprintf('Error loading traces in %s. For .mat files, traces must be storred as a cell array named ''data''. Labels for the traces must be storred in a cell array named ''labels''. If no variable named ''labels'' can be located then traces will be labeled sequentially.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'error'));               
            case 'label length'
                msgboxText{1} = sprintf('The number of labels in %s did not match the number of traces. Traces will be labeled sequentially.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'warn'));
            case 'load data error'
                msgboxText{1} = sprintf('There was a problem loading the trace data from %s. Please check that the data is in an acceptable format.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'error'));
            case 'read dat'
                msgboxText{1} = sprintf('There was a problem reading the file %s. Please check that the data is in an acceptable format.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'error'));
            case 'odd columns'
                msgboxText{1} = sprintf('There was a problem loading the trace data from %s. An extra column of data was present in the file.',flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Error', 'error'));
            case 'unique traces'
                msgboxText{1} = sprintf('Warning: The traces loaded do not all have unique labels.');
                uiwait(msgbox(msgboxText,'Data Loading Warning', 'warn'));
            case 'saved session plus others'
                msgboxText{1} = sprintf('Warning: Restoring saved session %s. No other files will be loaded.', flag.filname);
                uiwait(msgbox(msgboxText,'Data Loading Warning', 'warn'));
                
        end

    case 'analysis error'
        switch flag.problem
            
            case 'k_range'
                msgboxText{1} = sprintf('The minimum number of states possible must be less than or equal to the maximum number of states possible.');
                uiwait(msgbox(msgboxText,'Data Analysis Error', 'error'));
            case 'cannot db'
                msgboxText{1} = sprintf('One or more traces were loaded too late during data analysis to have their blur states cleaned.');
                uiwait(msgbox(msgboxText,'Data Analysis Error', 'warn'));                
        end
        
    case 'guess_string'
        if isequal(flag.problem,'guess_string_2D')
            msgboxText{1} = sprintf('Guesses for channel 1 and 2 must be the same length.');
            msgboxText{2} = sprintf('Until the error is fixed this field will be ignored.');
            uiwait(msgbox(msgboxText,'Non-Numeric Warning', 'warn'));
        elseif isequal(flag.problem,'non_numeric')
            msgboxText{1} = sprintf('At least part of the string entered was non-numeric.');
            msgboxText{2} = sprintf('Until the error is fixed this field will be ignored.');
            uiwait(msgbox(msgboxText,'Non-Numeric Warning', 'warn'));
        elseif  isequal(flag.problem,'dim_mismatch')
            msgboxText{1} = sprintf('The dimension of the starting guesses does not match the dimension of data analysis. Starting guesses will be initialized at random.');
            uiwait(msgbox(msgboxText,'Non-Numeric Warning', 'warn'));
        end
                
    case 'pushed during analysis'
        switch flag.problem
            case 'pushbutton'
                msgboxText{1} = sprintf('This function cannot be performed while data is being analyzed. Please pause data analysis first.');
                uiwait(msgbox(msgboxText,'Analysis Running Warning', 'warn'));
            case 'debleach'
                msgboxText{1} = sprintf('Traces cannot have photobleaching removed if any of them have been analyzed. Clear data analysis before using this function.');
                uiwait(msgbox(msgboxText,'Analysis Running Warning', 'warn'));
            case 'advanced analysis settings'
                msgboxText{1} = sprintf('One or more of these analysis settings cannot be changed while data is being analyzed. Clear analysis or wait until analysis is complete to save these changes.');
                uiwait(msgbox(msgboxText,'Analysis Running Warning', 'warn'));
            case 'delete traces'
                msgboxText{1} = sprintf('Traces cannot be deleted while analysis is running/paused. Clear analysis or wait until analysis is complete before deleting traces.');
                uiwait(msgbox(msgboxText,'Analysis Running Warning', 'warn'));               
        end
        
    case 'saving'
        switch flag.problem
            case 'fail save'
                msgboxText{1} = sprintf('There was an error while attempting to save your data.');
                uiwait(msgbox(msgboxText,'Save Data Error', 'error'));
            case 'no x_hat'
                msgboxText{1} = sprintf('At least one trace must be analyzed before best fits of the data can be saved.');
                uiwait(msgbox(msgboxText,'Save Data Error', 'error'));
            case 'no traces'
                msgboxText{1} = sprintf('No traces are loaded.');
                uiwait(msgbox(msgboxText,'Save Data Error', 'error'));
            case 'no analysis'
                msgboxText{1} = sprintf('No traces have been analyzed by vbFRET yet.');
                uiwait(msgbox(msgboxText,'Save Data Error', 'error'));
                
        end 
        
    case 'incomplete data'
        switch flag.problem
            case 'no cleaned traces'
                msgboxText{1} = sprintf('No blur cleaned traces have been analyzed by vbFRET yet. To use this function with non-blur cleaned data, uncheck the ''Display cleaned results'' checkbox in Advanced Analysis Settings.');
                uiwait(msgbox(msgboxText,'Incomplete Data', 'warn'));
            case 'incomplete analysis'
                msgboxText{1} = sprintf('Not all traces have been analyzed. Only analyzed traces will be used.');
                uiwait(msgbox(msgboxText,'Incomplete Data', 'warn'));
        end
       
end