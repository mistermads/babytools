
% path to the original babytools
addpath('../matlab/original/');

if 0
    Q_drive = '/Volumes/PSYKAPPS/FAELLES/Babylab'
    COMPUTER_STR = upper(computer)
    addpath(fullfile(Q_drive,'Mads/C3D_Code',['BTK_' COMPUTER_STR],'share/btk-0.1/Wrapping/Matlab/btk')) 
    % C3D toolbox
    addpath(fullfile(Q_drive,'Mads/C3D_Code/C3D'));
    if isunix
        % put homemade c3dserver.m up front to plug the toolbox
        addpath(fullfile(Q_drive,'Mads/C3D_Code'),'-BEGIN')
        % BABYTOOLS
        addpath(fullfile(getenv('HOME'), '/svn/babytools-current'));
    else
        addpath(fullfile(X_drive,'Mads','Babytools'));
    end
    
    % load C3D data
    c3dfile = '../data/030_MS_04mdr.c3d';
    [raw_c3d,markernames,units] = baby_load_c3d(c3dfile);
    
    % save
    save(strrep(c3dfile,'.c3d','_LoadedAsC3D'),'raw_c3d','markernames','units');

  
else
    load ../data/030_MS_04mdr_LoadedAsC3D.mat
    
      % compute velocity/speed and smoothe
    smoothpnts = 5;
    markername = 'Mvenstrehjrne';
    framerate = 60;
    [speed,velocity,unit] = baby_velocity_c3d(raw_c3d,framerate,markername,smoothpnts);
end