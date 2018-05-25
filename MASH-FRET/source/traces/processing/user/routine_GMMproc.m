function routine_GMMproc(h_fig)

proj_file = {'standard_2states';'standard_3states'; ...
    'standard_4states';'standard_5states'; ...
    'standard_6states';'standard_7states'; ...
    'standard_8states';'standard_9states'};
for n = 1:size(proj_file,1)
    N{n} = n+1;
    meth{n} = [2 4 5];
end
namemeth{2} = '_VbFRET';
namemeth{4} = '_CPA';
namemeth{5} = '_STaSI';
%             [1 2  0  0 0  0  0 2
%              1 2  0  0 5  0  0 2
%              1 1  0  0 0  0  0 0
%              1 2  0  0 50 90 2 2
%              1 30 0  0 0  0  0 2]
dscr_prm{2} = [1 2 0 0 5   0  0 2];
dscr_prm{4} = [1 2 0 0 100 90 2 2];
dscr_prm{5} = [1 2 0 0 0   0  0 2];
figname = get(h_fig, 'Name');
a = strfind(figname, 'MASH-FRET ');
b = a + numel('MASH-FRET ');
vers = figname(b:end);

for pj = 1:size(proj_file,1)

    proj_name = proj_file{pj};
    pname = ['D:\Melodie\Analysis\Me\MASHsmFRET_test\' ...
        'publication\traces_processing'];

    disp(sprintf('treat project n:°%i: %s', pj, proj_name));

    h = guidata(h_fig);
    p = h.param.ttPr;
    p.curr_proj = pj;
    p = ud_projLst(p, h.listbox_traceSet);
    h.param.ttPr = p;
    guidata(h_fig, h);

    ud_TTprojPrm(h_fig);
    ud_trSetTbl(h_fig);
    updateFields(h_fig, 'ttPr');

    for nStates = N{pj}
        for method = meth{pj}
            fname = [proj_name namemeth{method}];
            p.proj{pj}.fix{2}(6) = 0; % fix first frame for all molecules
            nMol = numel(p.proj{1}.coord_incl);
            for m = 1:nMol
                p.proj{pj}.curr{m}{1}{1}(2) = 0; % apply denoising
                p.proj{pj}.curr{m}{2}{1}(1) = 0; % apply cutoff
                % Background correction
                p.proj{pj}.curr{m}{3}{1}(1,1:2) = 1; % apply correction
                p.proj{pj}.curr{m}{3}{2}(1,1:2) = 2; % method
                % method/apply to FRET/recalc states
                p.proj{pj}.curr{m}{4}{1} = [method 1 0];
                dscr_prm{method}(2) = nStates;
                p.proj{pj}.curr{m}{4}{2}(method,:,1) = ...
                        dscr_prm{method};
                p.proj{pj}.curr{m}{5}{1}{1,1} = 0.07;
                p.proj{pj}.curr{m}{5}{1}{1,2} = 0;
                % additional factors
                p.proj{pj}.curr{m}{5}{3}(1,1:2) = 1;
            end

            p.proj{pj}.exp.process = 1;
            p.proj{pj}.exp.traces{1}(1) = 1;
            if method==2
                p.proj{pj}.exp.traces{1}(2) = 7;
            else
                p.proj{pj}.exp.traces{1}(2) = 1;
            end
            p.proj{pj}.exp.hist{1}(1) = 0;
            p.proj{pj}.exp.dt{1} = 0;
            p.proj{pj}.fig{1}(1) = 1; % export figure

            h.param.ttPr = p;
            guidata(h_fig, h);

            saveProcAscii(h_fig, p, p.proj{pj}.exp, ...
                [pname filesep], fname);

            h = guidata(h_fig);
            p = h.param.ttPr;

            fname_proj = [pname filesep fname '.mash'];

            dat = p.proj{pj};
            dat = rmfield(dat, {'prm', 'exp'});
            dat.prmTT = p.proj{pj}.prm;
            dat.expTT = p.proj{pj}.exp;
            dat.cnt_p_sec = dat.fix{2}(4);
            dat.cnt_p_pix = dat.fix{2}(5);
            dat.MASH_version = vers;
            dat.proj_file = fname_proj;
            dat.date_last_modif = datestr(now);

            save(fname_proj, '-struct', 'dat');
            updateActPan(['Project ' fname ' has been ' ...
                'successfully exported to folder: ' pname], ...
                h_fig, 'success');
        end
    end
end

