function utd = initUptodateArr(varargin)

utd = setKey({},...
    'sim',{},...
    'vp',{},...
    'tp',{},...
    'ha',{},...
    'ta',{}...
);

% simulation
utd = setKey(utd,'sim',{
    'vidprm',0
    'mol',0
    'expsetup',0
    'expopt',0
});

% video processing
utd = setKey(utd,'vp',{
    'plot',0
    'expset',0
    'ednexpvid',0
    'molcoord',0
    'intintgr',0
});

% trace processing
utd = setKey(utd,'tp',{
    'updatecurr',0
    'updateall',0
});

% histogram analysis
utd = setKey(utd,'ha',{
    'histnplot',0
    'stateconfig',0
    'statepop',0
});

% transition analysis
utd = setKey(utd,'ta',{
    'tdp',0
    'stateconfig',0
    'dthist',0
    'kinmdl',0
});
