function saveTraces(s, pname, fname, prm, h_fig)
% Save raw traces to ASCII and/or HaMMy-/VbFRET-/QUB-/SMART-compatible
% files.
% "s" >> folder name
% "pname" >> folder 
% "fname" >> generated folder path
% "h_fig" >> MASH figure handle

% Last update: 18th of March 2014 by Mélodie C.A.S Hadzic

p = prm{1};
q = prm{2};
saveAsAscii = p(1);
allInOne = p(2);
onePerTrace = p(3);
saveAsHa = p(4);
saveAsVbfret = p(5);
saveAsQUB = p(6);
saveAsSMART = p(7);
saveTraces = ~~sum([saveAsAscii saveAsHa saveAsVbfret saveAsQUB ...
    saveAsSMART]);

nMol = size(s.coord,1);
nExc = size(s.intensities,3);
nFrames = size(s.intensities,1)*nExc;
nChan = s.nb_channel;
exc = s.excitations;
chanExc = s.chanExc;

[o,name,o] = fileparts(fname);

if saveTraces
    coord_tbl = [];
    I_tbl = [];
    for m = 1:nMol
        coord_mol = [];
        I_mol = [];
        for l = 1:nExc
            for c = 1:nChan
                if l == 1
                    coord_mol = [coord_mol s.coord(m,(2*c-1):2*c)];
                end
                I = s.intensities(:,(m-1)*nChan+c,l);
                I_mol = [I_mol mean(I) std(I)];
            end
        end
        I_tbl = [I_tbl;I_mol];
        coord_tbl = [coord_tbl;coord_mol];
    end
    str_tbl1 = [];
    str_tbl2 = [];
    for l = 1:nExc
        for c = 1:nChan
            if l == 1
                str_tbl1 = strcat(str_tbl1, 'x', num2str(c), '\ty', ...
                    num2str(c), '\t');
            end
            str_tbl2 = strcat(str_tbl2, 'signal', num2str(c), ' at ', ...
                '', num2str(s.excitations(l)), 'nm(average)\tnoise', ...
                num2str(c), ' at ', num2str(s.excitations(l)), 'nm\t');
        end
    end
   
    str_tblH = strcat(str_tbl1, str_tbl2, '\n');
    str_crdFmt = repmat('%4.2f\t%4.2f\t', 1, nChan);
    str_Ifmt = repmat('%d\t', 1, 2*nChan*nExc);
    str_tblFmt = strcat(str_crdFmt, str_Ifmt, '\n');
    fname_tbl = [name '_all' num2str(nMol) '.tbl'];
    f = fopen([pname fname_tbl], 'Wt');
    fprintf(f, str_tblH);
    fprintf(f, str_tblFmt, [coord_tbl I_tbl]');
    fclose(f);
end

I_all = zeros(nFrames, nChan*nMol);
for l = 1:nExc
    I_all(l:nExc:nFrames,:) = s.intensities(:,:,l);
end

if saveAsAscii
    
    str_wl = [];
    for i = 1:nExc
        str_wl = [str_wl '%4.2f nm\t'];
    end
    str_wl = [str_wl '\n'];
    str_wl = sprintf(str_wl, s.excitations);
    
    str_prm_tot = [];
    for i = 1:size(s.exp_parameters,1)
        str_prm = [];
        if ~isempty(s.exp_parameters{i,2})
            prm = strrep(s.exp_parameters{i,1}, '%', '%%');
            str_prm = [str_prm '\t' prm ': '];
            if isnumeric(s.exp_parameters{i,2})
                prm = num2str(s.exp_parameters{i,2});
            else
                prm = s.exp_parameters{i,2};
            end
            str_prm = [str_prm prm];
            if ~isempty(s.exp_parameters{i,3})
                prm = strrep(s.exp_parameters{i,3}, '%', '%%');
                str_prm = [str_prm ' ' prm];
            end
            str_prm_tot = [str_prm_tot str_prm '\n'];
        end
    end
    
    str_header = ['creation date: %s\n' ...
        'MASH-FRET version: %s\n' ... 
        'movie file: %s\n' ... 
        'coordinates file: %s\n' ... 
        'number of channels: %i\n' ... 
        'excitation wavelengths: ' str_wl ... 
        'frame rate: %d s-1 \n' ... 
        'integration area: %i x %i\n' ... 
        'number of brightest pixels: %i\n' ...
        'experimental parameters: \n' str_prm_tot];
    
    if allInOne
        str_coord = [];
        str_dat_hd = 'time(s)\tframes';
        str_dat = '%d\t%i';
        for i = 1:nMol
            for j = 1:nChan
                str_coord = [str_coord '\t%4.2f,%4.2f'];
                str_dat_hd = [str_dat_hd '\tintensity(a.u.)'];
                str_dat = [str_dat '\t%d'];
            end
        end
        str_hd_coord = ['coordinates:\t' str_coord '\n'];
        str_col_names = [str_dat_hd '\n'];
        str_dat = [str_dat '\n'];
        
        fname_all = [name '_all' num2str(nMol) '.txt'];
        f = fopen([pname fname_all], 'Wt');
        
        fprintf(f, str_header, s.date_creation, ...
            num2str(s.MASH_version), s.movie_file, s.coord_file, ...
            s.nb_channel, s.frame_rate, s.pix_intgr(1), ...
            s.pix_intgr(1), s.pix_intgr(2));
        
        fprintf(f, str_hd_coord, s.coord');
        
        fprintf(f, str_col_names);
        
        fprintf(f, str_dat, [s.frame_rate*(1:nFrames)', ...
            (1:nFrames)', I_all]');
        
        fclose(f);
           
        updateActPan(['Traces saved to ASCII file: ' [name '.txt'] ...
            '\n in folder: ' pname], h_fig);
    end
    
    if onePerTrace
        pname_one = setCorrectPath([pname 'single_ASCII_traces'], h_fig);
        for mol = 1:nMol
            str_coord = [];
            str_dat_hd = 'time(s)\tframes';
            str_dat = '%d\t%i';
            for j = 1:nChan
                str_coord = [str_coord '\t%4.2f,%4.2f'];
                str_dat_hd = [str_dat_hd '\tI_' num2str(j) '(a.u.)'];
                str_dat = [str_dat '\t%d'];
            end
            str_hd_coord = ['coordinates:\t' str_coord '\n'];
            str_col_names = [str_dat_hd '\n'];
            str_dat = [str_dat '\n'];

            fname_one = [name '_mol' num2str(mol) 'of' num2str(nMol) ...
                '.txt'];
            f = fopen([pname_one fname_one], 'Wt');

            fprintf(f, str_header, s.date_creation, ...
                num2str(s.MASH_version), s.movie_file, s.coord_file, ...
                s.nb_channel, s.frame_rate, s.pix_intgr(1), ...
                s.pix_intgr(1), s.pix_intgr(2));

            fprintf(f, str_hd_coord, s.coord(mol,:)');

            fprintf(f, str_col_names);

            fprintf(f, str_dat, [s.frame_rate*(1:nFrames)', ...
                (1:nFrames)', I_all(:,nChan*(mol-1)+1:nChan*mol)]');

            fclose(f);

            updateActPan(['Traces of molecule n:°' num2str(mol) ...
                ' saved to ASCII file: ' fname_one '\n in ' ...
                'folder: ' pname_one], h_fig);
        end
    end
end

for j = 1:size(q,1)
    FRETfrom = q(j,1);
    FRETto = q(j,2);
    [o,las_FRET,o] = find(exc==chanExc(FRETfrom));
    ind_fret_las = (las_FRET:nExc:nFrames);
    ext_f = [];
    if size(q,1) > 1
        ext_f = ['FRET' num2str(FRETfrom) num2str(FRETto)];
    end
    
    if saveAsHa
        pname_ha = setCorrectPath([pname 'HaMMy-compatible'], h_fig);
        for mol = 1:nMol
            ind_fret = [nChan*(mol-1)+FRETfrom nChan*(mol-1)+FRETto];
            fname_ha = [name '_mol' num2str(mol) 'of' num2str(nMol) ...
                ext_f '_HaMMy.dat'];
            
            f = fopen([pname_ha fname_ha], 'Wt');
            fprintf(f, '%d\t%d\t%d\n', [s.frame_rate*ind_fret_las', ...
                    I_all(ind_fret_las,ind_fret)]');
            fclose(f);

            updateActPan(['Traces of molecule n:°' num2str(mol) ...
                ' saved to HaMMy-compatible file: ' fname_ha '\n in ' ...
                'folder: ' pname_ha], h_fig);
        end
    end

    if saveAsVbfret
        fname_vbfret = [name '_all' num2str(nMol) ext_f '_VbFRET.mat'];
        data = {};
        for mol = 1:nMol
            ind_fret = [nChan*(mol-1)+FRETfrom nChan*(mol-1)+FRETto];
            data{mol} = I_all(ind_fret_las,ind_fret);
        end
        save([pname fname_vbfret], 'data');
        updateActPan(['Traces saved to VbFRET-compatible file: ' ...
            fname_vbfret '\n in folder: ' pname], h_fig);
    end

    if saveAsQUB
        fname_QUB = [name '_all' num2str(nMol) ext_f '_QUB.txt'];
        f = fopen([pname fname_QUB], 'Wt');
        str_output = [];
        tr_fret = [];
        for mol = 1:nMol
            ind_fret = [nChan*(mol-1)+FRETfrom nChan*(mol-1)+FRETto];
            tr_fret = [tr_fret I_all(ind_fret_las,ind_fret)];
            str_output = [str_output '\t%d\t%d'];
        end
        str_output = [str_output '\n'];
        fprintf(f, str_output, tr_fret'); 
        fclose(f);
        updateActPan(['Traces saved to QUB-compatible file: ' fname_QUB ...
            '\n in folder: ' pname], h_fig);
    end

    if saveAsSMART
        fname_SMART = [name '_all' num2str(nMol) ext_f '_SMART.traces'];
        group_data = {};
        for mol = 1:nMol
            ind_fret = [nChan*(mol-1)+FRETfrom nChan*(mol-1)+FRETto];
            tr_fret = I_all(ind_fret_las,ind_fret);
            group_data{mol,1}.name = fname_SMART;
            group_data{mol,1}.gp_num = NaN;
            group_data{mol,1}.movie_num = 1;
            group_data{mol,1}.movie_ser = 1;
            group_data{mol,1}.trace_num = mol;
            group_data{mol,1}.spots_in_movie = nMol;
            group_data{mol,1}.position_x = s.coord(mol,2*FRETfrom-1);
            group_data{mol,1}.position_y = s.coord(mol,2*FRETfrom);
            group_data{mol,1}.positions = s.coord;
            group_data{mol,1}.fps = s.frame_rate*nExc;
            group_data{mol,1}.len = size(tr_fret,1);
            group_data{mol,1}.nchannels = 2;
            group_data{mol,2} = tr_fret;
            group_data{mol,3} = true(size(tr_fret,1),1);
        end

        save([pname fname_SMART], 'group_data', '-mat');
        updateActPan(['Traces saved to SMART-compatible file: ' ...
            fname_SMART '\n in folder: ' pname], h_fig);
    end
end

