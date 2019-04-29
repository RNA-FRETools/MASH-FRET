function pnt = openMapping(img, lim_x)
% Openmapingtiff asks the user to open the average frame of the reference
% The cpselect tool opens to pick up 20 pairs minimum of coord. If
% the user picked up at least 20 pairs, the coord ares saved in a
% .txt file, with donor coord in the odd lines and acceptor
% coord in the even lines

pnt = {};
exit_choice = 'No';

while ~strcmp(exit_choice, 'Yes')
    
    pnt = beadsSelect(img, lim_x, pnt);

    nb_points = size(pnt,1);
    
    if nb_points >= 15 || nb_points == 0;
        exit_choice = 'Yes';
        
    else
        msgStr = {};
        msgStr = {msgStr{:} [num2str(nb_points) ' reference ' ...
            'coordinates have been selected.']};
        
        if nb_points < 2
            msgStr = {msgStr{:} ['No spatial transformation can be ' ...
                'calculated.']};
        
        else
            msgStr = {msgStr{:} ['You are able to perform following ' ...
                'spatial transformations:']};
            
            if nb_points >= 2
                msgStr = {msgStr{:} '- Nonrefective similarity'};
            end
            
            if nb_points >= 3
                msgStr = {msgStr{:} '- Similarity' '- Affine'};
            end
            
            if nb_points >= 4
                msgStr = {msgStr{:} '- Projective' '- Piecewise linear'};
            end
            
            if nb_points >= 6
                msgStr = {msgStr{:} '- Polynomial order 2'};
            end
            
            if nb_points >= 10
                msgStr = {msgStr{:} '- Polynomial order 3'};
            end
            
            if nb_points >= 12
                msgStr = {msgStr{:} '- Local weighted mean'};
            end
        end
        
        msgStr = {msgStr{:} '' 'Do you still want to exit?'};
        
        exit_choice = questdlg(msgStr);
    end
end

