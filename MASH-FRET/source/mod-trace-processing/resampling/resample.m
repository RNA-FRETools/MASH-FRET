function traj = resample(traj0,splt,splt0)

% formats data for time binning
L = size(traj0,1);
framenb = (1:L)';
colt = 1;
dat = [splt0*framenb,framenb,traj0];

% bins data
dat = binData(dat,splt,splt0,colt,colt+1);
if isempty(dat)
    return
end

% formats binned data and appends project data
traj = dat(:,(colt+2):end);