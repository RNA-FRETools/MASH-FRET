function trace = getIntTrace(lim, aDim, nPix, fDat)
% Build the intensity trace for one molecule for slow computers: works only
% for *.sif and *.sira movie file.
% Reads directly into the file, for each frame, intensity values belonging
% to the "binning*binning" area arround the SM coordinates and calculate
% the mean value over the "biningArea" pixels.
% Returns the intensity trace along all movie frames.

trace = [];
movFile = fDat{1};
fCurs = fDat{2}{1};
vid = fDat{2}{2};
s = fDat{3};
zTot = fDat{4};

nCoord = numel(lim.Xinf);
isMov = ~isempty(vid);

[o,o,fFormat] = fileparts(movFile);

switch fFormat
    
    case '.sif'
        if isMov
            if memAlloc(zTot*nCoord*aDim^2*4);
                trace = tracesFromMatrix(vid,zTot,lim,aDim,nPix);
                return;
            end
        end
        f = fopen(movFile, 'r');
        if f < 0 
            errordlg('Could not open the file.');
            return;
        end
        tline = fgetl(f);
        if ~isequal(tline,'Andor Technology Multi-Channel File')
            fclose(f);
            errordlg('Not an Andor SIF image file.');
        end

        nCoord = numel(lim.Xinf);
        prev = 0;
        trace_vect = zeros(zTot,nCoord,aDim^2);
        for zz = 1:zTot
            for c = 1:nCoord
                kk = 1;
                vect = zeros(1,1,aDim^2);

                % Move cursor from (1,1,1) to (Yinf,Xinf-1,zz)
                fseek(f, fCurs + 4*((zz-1)*prod(s) + ...
                    s(2)*(lim.Yinf(c)-1) + (lim.Xinf(c)-1)), -1);

                for yy = 1:aDim
                    if yy ~= 1
                        % Move cursor to coord 
                        % ((Xinf-1),(Yinf+yy),zz)
                        fseek(f, 4*(s(2)-aDim), 0);
                    end
                    for xx = 1:aDim
                        % Read (move one step forward) and store 
                        % one intensity (4bytes)
                        I = fread(f, 1, '*single');
                        vect(1,1,kk) = I;
                        kk = kk + 1;
                    end
                end
                trace_vect(zz,c,1:numel(vect)) = vect;
            end

            if round(100*zz/zTot) > prev
                prev = round(100*zz/zTot);
                disp(['Generating intensity-time traces: ' ...
                    num2str(prev) '%']);
            end
        end
        fclose(f);
        
        trace = getNpixFromVect(trace_vect, nPix);
        return;
        
    case '.sira'

        if isMov
            if memAlloc(zTot*nCoord*aDim^2*4);
                trace = tracesFromMatrix(vid,zTot,lim,aDim,nPix);
                return;
            end
        end
        
        [vers,is_sgl,is_os] = getSiraDat(movFile,[]);
        if is_sgl
            prec = 'single';
        else
            prec = 'uint16';
        end
        
        f = fopen(movFile, 'r');

        prev = 0;
        trace_vect = zeros(zTot,nCoord,aDim^2);
        for zz = 1:zTot
            for c = 1:nCoord
                kk = 1;
                vect = zeros(1,1,aDim^2);

                % Move cursor from (1,1,1) to ((Yinf-1),Xinf,zz)
                fseek(f,fCurs+2*(1+double(is_sgl))*((zz-1)* ...
                    (prod(s)+double(is_os))+s(1)*(lim.Xinf(c)-1)+ ...
                    (lim.Yinf(c)-1)),-1);

                for xx = 1:aDim
                    if xx ~= 1
                        % Move cursor to coord ((Yinf-1),(Xinf+xx),zz)
                        fseek(f,2*(1+double(is_sgl))*(s(1)-aDim),0);
                    end
                    for yy = 1:aDim
                        % Read (move one step forward) and store one 
                        % intensity (2bytes)
                        I = fread(f,1,prec);
                        vect(1,1,kk) = I;
                        kk = kk + 1;
                    end
                end
                trace_vect(zz,c,1:numel(vect)) = vect;

                if round(100*zz/zTot) > prev
                    prev = round(100*zz/zTot);
                    disp(['Generating intensity-time traces: ' ...
                        num2str(prev) '%']);
                end
            end
            if is_os
                % Move cursor from (1,1,1) to (end,end,zz)
                fseek(f, fCurs + 2*(1+double(is_sgl))*((zz-1)* ...
                    (prod(s)+is_os)+prod(s)),-1);
                os = fread(f, 1, prec);
                trace_vect(zz,:,:) = trace_vect(zz,:,:)-os;
            end
        end
        fclose(f);

        trace = getNpixFromVect(trace_vect, nPix);
        return;
        
    case '.tif'
        imgInfo = imfinfo(movFile);
        zTot = size(imgInfo,1);
        nCoord = numel(lim.Xinf);
        prev = 0;
        trace_vect = zeros(zTot,nCoord,aDim^2);
        for zz = 1:zTot
            img = double(imread(movFile, 'Index', zz, 'Info', imgInfo));
            for c = 1:nCoord
                vect = reshape(img(lim.Yinf(c):(lim.Yinf(c)+aDim-1), ...
                    lim.Xinf(c):(lim.Xinf(c)+aDim-1)), [1 aDim^2]);
                trace_vect(zz,c,1:numel(vect)) = permute(vect,[1 3 2]);
            end

            if round(100*zz/zTot) > prev
                prev = round(100*zz/zTot);
                disp(['Generating intensity-time traces: ' ...
                    num2str(prev) '%']);
            end
        end
        
        trace = getNpixFromVect(trace_vect, nPix);
        return;
        
    case '.gif'
        imgInfo = imfinfo(movFile);
        zTot = size(imgInfo,1);
        nCoord = numel(lim.Xinf);
        prev = 0;
        trace_vect = zeros(zTot,nCoord,aDim^2);
        for zz = 1:zTot
            img = double(imread(movFile, zz));
            for c = 1:nCoord
                vect = reshape(img(lim.Yinf(c):(lim.Yinf(c)+aDim-1), ...
                    lim.Xinf(c):(lim.Xinf(c)+aDim-1)), [1 aDim^2]);
                trace_vect(zz,c,1:numel(vect)) = permute(vect,[1 3 2]);
            end

            if round(100*zz/zTot) > prev
                prev = round(100*zz/zTot);
                disp(['Generating intensity-time traces: ' ...
                    num2str(prev) '%']);
            end
        end
        
        trace = getNpixFromVect(trace_vect, nPix);
        return;
        
    case '.png'
        
        nCoord = numel(lim.Xinf);
        trace_vect = zeros(1,nCoord,aDim^2);
        
        info = imfinfo(movFile); % information array of .tif file
        max_img = 1; min_img = 0; max_bit = 1;
        if isfield(info, 'Description')
            % time delay between each frame
            descr = info(1,1).Description;
            if ~isnan(sum(str2num(descr))) && size(str2num(descr),2)==3
                descr = str2num(descr);
                max_img = descr(2);
                min_img = descr(3);
                max_bit = 65535;
            end
        end
    
        img = round(min_img+(double(imread(movFile))/max_bit)* ...
            (max_img-min_img));
        for c = 1:nCoord
            vect = reshape(img(lim.Yinf(c):(lim.Yinf(c)+aDim-1), ...
                lim.Xinf(c):(lim.Xinf(c)+aDim-1)), [1 aDim^2]);
            trace_vect(1,c,1:numel(vect)) = permute(vect,[1 3 2]);
        end
        
        trace = getNpixFromVect(trace_vect, nPix);
        return;
        
    case '.pma'
        f = fopen(movFile, 'r');
        if f < 0 
            errordlg('Could not open the file.');
        else
            prev = 0;
            trace_vect = zeros(zTot,nCoord,aDim^2);
            for zz = 1:zTot;
                for c = 1:nCoord
                    kk = 1;
                    vect = zeros(1,1,aDim^2);

                    % Move cursor from (1,1,1) to ((Yinf-1),Xinf,zz)
                    fseek(f, fCurs + ((zz-1)*(2+prod(s)) + ...
                        (s(1)*(lim.Yinf(c)-1) + (lim.Xinf(c)-1))), -1);

                    for xx = 1:aDim
                        if xx ~= 1
                            % Move cursor to coord ((Yinf-1),(Xinf+xx),zz)
                            fseek(f, (s(1) - aDim), 0);
                        end
                        for yy = 1:aDim
                            % Read (move one step forward) and store one 
                            % intensity (2bytes)
                            vect(1,1,kk) = fread(f, 1, 'uint8');
                            kk = kk + 1;
                        end
                    end
                    
                    trace_vect(zz,c,1:numel(vect)) = vect;
                    
                    if round(100*zz/zTot) > prev
                        prev = round(100*zz/zTot);
                        disp(['Generating intensity-time traces: ' ...
                            num2str(prev) '%']);
                    end
                end
            end
            fclose(f);
        end
        
        trace = getNpixFromVect(trace_vect, nPix);
        return;
end


function trace = tracesFromMatrix(matrix,zTot,lim,aDim,nPix)
nCoord = numel(lim.Xinf);
aDim2 = aDim^2;
trace = zeros(zTot,nCoord);
prev = 0;
for c = 1:nCoord
    
    if round(100*c/nCoord)>prev
        prev = round(100*c/nCoord);
        disp(cat(2,'Generating intensity-time traces: ',num2str(prev),...
            '%'));
    end
    
    y0 = lim.Yinf(c);
    x0 = lim.Xinf(c);
    
    % get average sub-image
    id_x = x0:(x0+aDim-1);
    id_y = y0:(y0+aDim-1);
    trace_vect = reshape(matrix(id_y,id_x,:),[aDim2,zTot])';
    [o,id] = sort(mean(trace_vect,1),2,'descend');

    trace(:,c) = sum(trace_vect(:,id(1:nPix)),2);

end


function trace = getNpixFromVect(trace_vect, nPix)
% find the brightest pixels in the average intensity vectors for each
% position and calculate average intensity over these pixels on each frame

[zTot,nMol,o] = size(trace_vect);
trace = zeros(zTot,nMol);

ave_vect = permute(mean(trace_vect,1),[3 2 1]);
[o,id_pix] = sort(ave_vect,1,'descend');

id_pix = id_pix(1:nPix,:);

for m = 1:nMol
    trace(:,m) = sum(trace_vect(:,m,id_pix(:,m)'),3);
end


