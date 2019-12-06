function pushbutton_trMap_Callback(obj, evd, h_fig)
[fname, pname, o] = uigetfile({ ...
    '*.png;*.tif', 'Image file(*.png;*.tif)';
    '*.*',  'All Files (*.*)'}, ...
    'Select an image file for mapping', ...
    setCorrectPath('average_images', h_fig));

if ~isempty(fname) && sum(fname)
    [o,o,fext] = fileparts(fname);
    if ~(strcmp(fext,'.png') || strcmp(fext,'.tif'))
        updateActPan(...
            'Wrong file format. Only PNG and TIF files are supported', ...
            h_fig, 'success');
    end
    cd(pname);
    h = guidata(h_fig);
    p = h.param.movPr;
    img = imread([pname fname]);
    nC = p.nChan;
    res_x = size(img,2);
    lim_x = [0 (1:nC-1)*round(res_x/nC) res_x];
    
    pnt = openMapping(img, lim_x);
    coord = zeros([numel(pnt)/2 2]);
    if ~isempty(pnt)
        for i = 1:nC
            coord(i:nC:end,:) = pnt(:,2*i-1:2*i);
        end
    end
    
    if ~isempty(coord)
        coord2save = coord;
        q{1}(:,1) = 1:nC;
        q{1}(:,2) = nC;
        q{1}(:,3) = zeros(1,nC);
        q{2}(1) = 1;
        q{2}(2) = 2;
        coord = orgCoordCol(coord, 'rw', q, nC, res_x);
        isItg = 0;
        if nC > 1
            p.trsf_coordRef = coord;
        elseif isempty(p.coordItg)
            p.coordItg = coord;
            isItg = 1;
        end
        
        saved = 0;

        [o,defName,o] = fileparts(fname);
        defName = [setCorrectPath('mapping', h_fig) defName ...
            '.map'];
        [fname,pname,o] = uiputfile({...
            '*.map', 'Mapped coordinates files(*.map)'; ...
            '*.*', 'All files(*.*)'}, ...
            'Export coordinates', defName);

        if ~isempty(fname) && sum(fname)
            cd(pname);
            [o,fname,o] = fileparts(fname);
            fname = getCorrName([fname '.map'], pname, h_fig);

            if ~isempty(fname) && sum(fname)
                if nC > 1
                    p.trsf_coordRef_file = fname;
                elseif isItg
                    p.coordItg_file = fname;
                    p.itg_coordFullPth = [pname fname];
                end
                
                f = fopen([pname fname], 'Wt');
                fprintf(f, 'x\ty\n');
                fprintf(f, '%d\t%d\n', coord2save');
                fclose(f);
                updateActPan(['Reference coordinates successfully ' ...
                    'loaded and saved to file: ' fname '\n in folder: ' ...
                    pname], h_fig, 'success');
               
                saved = 1;
            end
        end

        if ~saved
            if nC > 1
                p.trsf_coordRef_file = [];
            elseif isItg
                p.coordItg_file = [];
                p.itg_coordFullPth = [];
            end
            updateActPan('Reference coordinates loaded but not saved', ...
                h_fig, 'process');
        end
        h.param.movPr = p;
        guidata(h_fig, h);
        updateFields(h_fig, 'movPr');
    end
end