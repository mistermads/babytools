function raw_qualisys = baby_qualisys_speed(speed)
% BABY_QUALISYS_SPEED
%
% raw_qualisys = baby_qualisys_speed(speed)
%
% get speed from baby_velocity_c3d

raw_qualisys.HEADER.DATA_INCLUDED = 'Velocity';
raw_qualisys.A = speed;
raw_qualisys.HEADER.FREQUENCY = 60;
raw_qualisys.HEADER.NO_OF_FRAMES = length(speed);
