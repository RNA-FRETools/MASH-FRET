function dat = formatSmart2File(tr_fret,mol,fps,coord)

n = mol(1);
N = mol(2);

dat{n,1}.name = '';
dat{n,1}.gp_num = NaN;
dat{n,1}.movie_num = 1;
dat{n,1}.movie_ser = 1;
dat{n,1}.trace_num = n;
dat{n,1}.spots_in_movie = N;
dat{n,1}.position_x = coord(n,1);
dat{n,1}.position_y = coord(n,2);
dat{n,1}.positions = coord;
dat{n,1}.fps = fps;
dat{n,1}.len = size(tr_fret,1);
dat{n,1}.nchannels = 2;

dat{n,2} = tr_fret;

dat{n,3} = true(size(tr_fret,1),1);