function ttPr_routine(obj, evd, routine, h_fig)

try
    switch routine
        case 1
            routine1(h_fig);

        case 2
            routine2(h_fig);

        case 3
            routine3(h_fig);

        case 4
            routine4(h_fig);

    end
    
catch err
    msgbox({['Routine ' num2str(routine) ' is undefined or incorrect.'] ...
        'The error described below occured:' '' ['"' err.message ', ' ...
        'line ' num2str(err.stack(1).line) '".'] '' ['To create or ' ...
        'edit a routine go to file: ' err.stack(1).file] ['function: ' ...
        err.stack(1).name]}, 'Routine error', 'warn');
end
        
