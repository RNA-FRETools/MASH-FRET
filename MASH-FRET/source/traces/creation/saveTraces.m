function saveTraces(s, pname, fname, prm, h_fig)
% Save single molecule intensities to ASCII files and/or HaMMy-/VbFRET-/
% QUB-/SMART-compatible files.
% "s" >> folder name
% "pname" >> folder 
% "fname" >> generated folder path
% "h_fig" >> MASH figure handle

% Last update: 20th of February 2019 by Mélodie C.A.S Hadzic
% --> add ebFRET-compatible export
% --> create ASCII,statistics,ebFRET,vbFRET,HaMMy,QUB,SMART folders
%
% update: 18th of February 2019 by Mélodie C.A.S Hadzic
% --> change folder to /intensities
% --> comment code and optimize synthax

% collect export settings
pexp = prm{1};
saveAsAscii = pexp(1);
allInOne = pexp(2);
onePerTrace = pexp(3);
saveAsHa = pexp(4);
saveAsVbfret = pexp(5);
saveAsQub = pexp(6);
saveAsSmart = pexp(7);
saveAsEbfret = pexp(8);
saveTraces = saveAsAscii|saveAsHa|saveAsVbfret|saveAsQub|saveAsSmart|...
    saveAsEbfret;

% collect experiment settings
N = size(s.coord,1);
nExc = size(s.intensities,3);
L = size(s.intensities,1)*nExc;
expT = s.frame_rate;
pix = s.pix_intgr;
nChan = s.nb_channel;
exc = s.excitations;
chanExc = s.chanExc;
FRET = prm{2};
nFRET = size(FRET,1);

% collect intensity data
I_all = zeros(L, nChan*N);
for l = 1:nExc
    I_all(l:nExc:L,:) = s.intensities(:,:,l);
end

% build destination directories and file name
[o,name,o] = fileparts(fname);
if saveTraces
    pname = setCorrectPath(cat(2,pname,'intensities'),h_fig);
    pname_stat = setCorrectPath(cat(2,pname,'statistics'),h_fig);
    if saveAsAscii
        pname_all = setCorrectPath(cat(2,pname,'traces_ASCII'),h_fig);
        if onePerTrace
            pname_one = setCorrectPath(cat(2,pname_all,'single_traces'),...
                h_fig);
        end
    end
    if saveAsHa
        pname_ha = setCorrectPath(cat(2,pname,'traces_HaMMy'),h_fig);
    end
    if saveAsVbfret
        pname_vbfret = setCorrectPath(cat(2,pname,'traces_vbFRET'),h_fig);
    end
    if saveAsQub
        pname_qub = setCorrectPath(cat(2,pname,'traces_QUB'),h_fig);
    end
    if saveAsSmart
        pname_smart = setCorrectPath(cat(2,pname,'traces_SMART'),h_fig);
    end
    if saveAsEbfret
        pname_ebfret = setCorrectPath(cat(2,pname,'traces_ebFRET'),h_fig);
    end
end

% save intensity statistics
if saveTraces
    
    % calculate intensity statistics and collect coordinates
    coord_tbl = [];
    I_tbl = [];
    for m = 1:N
        coord_n = [];
        I_n = [];
        for l = 1:nExc
            for c = 1:nChan
                if l == 1
                    coord_n = [coord_n s.coord(m,(2*c-1):2*c)];
                end
                I = s.intensities(:,(m-1)*nChan+c,l);
                I_n = [I_n mean(I) std(I)];
            end
        end
        I_tbl = [I_tbl;I_n];
        coord_tbl = [coord_tbl;coord_n];
    end
    
    % build file header
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
    str_tblH = cat(2,str_tbl1,str_tbl2,'\n');
    
    % build file structure
    str_crdFmt = repmat('%4.2f\t%4.2f\t',1,nChan);
    str_Ifmt = repmat('%d\t',1,2*nChan*nExc);
    str_tblFmt = cat(2,str_crdFmt,str_Ifmt,'\n');

    % write data to file
    fname_tbl = cat(2,name,'_all',num2str(N),'.tbl');
    f = fopen(cat(2,pname_stat,fname_tbl),'Wt');
    fprintf(f,str_tblH);
    fprintf(f,str_tblFmt,cat(2,coord_tbl,I_tbl)');
    fclose(f);
    
    % update action
    updateActPan(cat(2,'Intensity statistics saved to file: ',fname_tbl,...
        '\n in folder: ',pname_stat),h_fig);
end

% save intensity trajetories in ASCII file
if saveAsAscii
    
    % format trace parameters
    str_wl = '';
    for i = 1:nExc
        str_wl = cat(2,str_wl,'%4.2f nm\t');
    end
    str_wl = cat(2,str_wl,'\n');
    str_wl = sprintf(str_wl,s.excitations);
    
    str_expprm = [];
    for i = 1:size(s.exp_parameters,1)
        str = [];
        if ~isempty(s.exp_parameters{i,2})
            prm = strrep(s.exp_parameters{i,1}, '%', '%%');
            str = cat(2,str,'\t',prm,': ');
            if isnumeric(s.exp_parameters{i,2})
                prm = num2str(s.exp_parameters{i,2});
            else
                prm = s.exp_parameters{i,2};
            end
            str = cat(2,str,prm);
            if ~isempty(s.exp_parameters{i,3})
                prm = strrep(s.exp_parameters{i,3},'%','%%');
                str = cat(2,str,' ',prm);
            end
            str_expprm = cat(2,str_expprm,str,'\n');
        end
    end
    
    str_prm = cat(2,'creation date: %s\n', ...
        'MASH-FRET version: ',num2str(s.MASH_version),'\n',... 
        'movie file: %s\n',... 
        'coordinates file: %s\n',... 
        'number of channels: ',sprintf('%i',nChan),'\n',... 
        'excitation wavelengths: ',str_wl,... 
        'frame rate: ',sprintf('%d',1/expT),' fps \n',... 
        'integration area: ',sprintf('%i x %i',pix(1),pix(1)),'\n',... 
        'number of brightest pixels: ',sprintf('%i',pix(2)),'\n',...
        'experimental parameters: \n',str_expprm);
    
    % export all single molecules to one file
    if allInOne
        
        % build file header
        str_coord = [];
        str_dat_hd = 'time(s)\tframes';
        str_dat = '%d\t%i';
        for i = 1:N
            for j = 1:nChan
                str_coord = cat(2,str_coord,'\t%4.2f,%4.2f');
                str_dat_hd = cat(2,str_dat_hd,'\tI_',num2str(j),'(a.u.)');
                str_dat = cat(2,str_dat,'\t%d');
            end
        end
        str_hd_coord = cat(2,'coordinates:\t',str_coord,'\n');
        str_col_names = cat(2,str_dat_hd,'\n');
        str_dat = cat(2,str_dat,'\n');
        
        % build file name
        fname_all = cat(2,name,'_all',num2str(N),'.txt');
        
        % write data to file
        f = fopen(cat(2,pname_all,fname_all),'Wt');
        fprintf(f, str_prm,s.date_creation,s.movie_file,s.coord_file);
        fprintf(f, str_hd_coord,s.coord');
        fprintf(f, str_col_names);
        fprintf(f, str_dat,[expT*(1:L)',(1:L)',I_all]');
        fclose(f);
        
        % update action
        updateActPan(cat(2,'Traces saved to ASCII file: ',fname_all, ...
            '\n in folder: ',pname_all),h_fig);
    end
    
    % export single molecules to individual files
    if onePerTrace
        for n = 1:N
            
            % build header
            str_coord = [];
            str_dat_hd = 'time(s)\tframes';
            str_dat = '%d\t%i';
            for j = 1:nChan
                str_coord = cat(2,str_coord,'\t%4.2f,%4.2f');
                str_dat_hd = cat(2,str_dat_hd,'\tI_',num2str(j),'(a.u.)');
                str_dat = cat(2,str_dat,'\t%d');
            end
            str_hd_coord = cat(2,'coordinates:\t',str_coord,'\n');
            str_col_names = cat(2,str_dat_hd,'\n');
            str_dat = cat(2,str_dat,'\n');
            
            % build file name
            fname_one = cat(2,name,'_mol',num2str(n),'of',num2str(N),...
                '.txt');
            
            % write data to file
            f = fopen([pname_one fname_one], 'Wt');
            fprintf(f, str_prm,s.date_creation,s.movie_file,s.coord_file);
            fprintf(f, str_hd_coord, s.coord(n,:)');
            fprintf(f, str_col_names);
            fprintf(f, str_dat, [expT*(1:L)', ...
                (1:L)', I_all(:,nChan*(n-1)+1:nChan*n)]');
            fclose(f);
        end
        
        % update action
        updateActPan(cat(2,'Individual traces saved to ASCII files in ',...
            'folder: ',pname_one),h_fig);
    end
end

% export files compatible with external software
for j = 1:nFRET
    
    % build time column data
    [o,l,o] = find(exc==chanExc(FRET(1)));
    times =  expT*(l:nExc:L);
    
    % build file extension specific to FRET
    extf = [];
    if size(FRET,1) > 1
        extf = cat('FRET',num2str(FRET(1)),num2str(FRET(2)));
    end
    
    % save HaMMy-compatible files
    if saveAsHa
        for n = 1:N
            
            % build file name
            fname_ha = cat(2,name,'_mol',num2str(n),'of',num2str(N),extf,...
                '.dat');
            
            % format intensity data
            intensities = I_all(l:nExc:L,[nChan*(n-1)+FRET(j,1),...
                nChan*(n-1)+FRET(j,2)]);
            
            % write data to file
            f = fopen(cat(2,pname_ha,fname_ha),'Wt');
            fprintf(f,'%d\t%d\t%d\n',[times',intensities]');
            fclose(f);
        end
        
        % update action
        updateActPan(cat(2,'Traces saved to HaMMy-compatible files in ',...
            'folder: ',pname_ha),h_fig);
    end

    if saveAsVbfret
        
        % format intensity data
        data = cell(1,N);
        for n = 1:N
            data{n} = I_all(l:nExc:L,[nChan*(n-1)+FRET(j,1),...
                nChan*(n-1)+FRET(j,2)]);
        end
        
        % build file name
        fname_vbfret = cat(2,name,'_all',num2str(N),extf,'_vbFRET.mat');
        
        % write data to file
        save(cat(2,pname_vbfret,fname_vbfret),'data');
        
        % update action
        updateActPan(cat(2,'Traces saved to vbFRET-compatible file: ', ...
            fname_vbfret,'\n in folder: ',pname_vbfret),h_fig);
    end

    if saveAsQub
        
        % format data
        Ifret = [];
        for n = 1:N
            Ifret = cat(2,Ifret,I_all(l:nExc:L,[nChan*(n-1)+FRET(j,1),...
                nChan*(n-1)+FRET(j,2)]));
        end
        fmt = cat(2,repmat('%d\t',1,size(Ifret,2)),'\n');
        
        % build file name
        fname_QUB = cat(2,name,'_all',num2str(N),extf,'_QUB.txt');
        
        % write data to file
        f = fopen(cat(2,pname_qub,fname_QUB),'Wt');
        fprintf(f,fmt,Ifret'); 
        fclose(f);
        
        % update action
        updateActPan(cat(2,'Traces saved to QUB-compatible file: ',...
            fname_QUB,'\n in folder: ',pname_qub), h_fig);
    end

    if saveAsSmart
        
        % build file name
        fname_SMART = cat(2,name,'_all',num2str(N),extf,'_SMART.traces');
        
        % format intensity data
        group_data = cell(N,3);
        for n = 1:N
            ind_fret = [nChan*(n-1)+FRET(j,1) nChan*(n-1)+FRET(j,2)];
            Ifret = I_all(l:nExc:L,ind_fret);
            group_data{n,1}.name = fname_SMART;
            group_data{n,1}.gp_num = NaN;
            group_data{n,1}.movie_num = 1;
            group_data{n,1}.movie_ser = 1;
            group_data{n,1}.trace_num = n;
            group_data{n,1}.spots_in_movie = N;
            group_data{n,1}.position_x = s.coord(n,2*FRET(j,1)-1);
            group_data{n,1}.position_y = s.coord(n,2*FRET(j,1));
            group_data{n,1}.positions = s.coord;
            group_data{n,1}.fps = expT*nExc;
            group_data{n,1}.len = size(Ifret,1);
            group_data{n,1}.nchannels = 2;
            group_data{n,2} = Ifret;
            group_data{n,3} = true(size(Ifret,1),1);
        end

        % write data to file
        save(cat(2,pname_smart,fname_SMART),'group_data','-mat');
        
        % update action
        updateActPan(cat(2,'Traces saved to SMART-compatible file: ', ...
            fname_SMART,'\n in folder: ',pname_smart),h_fig);
    end
    
    if saveAsEbfret
        % format ebFRET data
        data_ebfret = [];
        for n = 1:N
            ind_fret = [nChan*(n-1)+FRET(j,1),nChan*(n-1)+FRET(j,2)];
            Ifret = I_all(l:nExc:L,ind_fret);
            data_ebfret = cat(1,data_ebfret,...
                cat(2,ones(size(Ifret,1),1)*n,Ifret));
        end
        
        % build file name
        fname_ebFRET = cat(2,name,'_all',num2str(N),extf,'_ebFRET.dat');
        
        % write data to file
        f = fopen(cat(2,pname_ebfret,fname_ebFRET),'Wt');
        fprintf(f,'%d\t%d\t%d\n',data_ebfret');
        fclose(f);
        
        % update action
        updateActPan(cat(2,'Traces saved to ebFRET-compatible file: ', ...
            fname_ebFRET,'\n in folder: ',pname_ebfret),h_fig);
    end
end

