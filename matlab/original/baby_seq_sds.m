function [seq,statenames] = baby_seq_sds(raw_sds,framerate)
% BABY_SEQ_SDS
%
% [seq,statenames] = baby_seq_sds(raw_sds,framerate)
%
%  Input
%  =====
%
%  framerate - Desired framerate for the seq. Frames per second.

seq = [];
statenames = raw_sds.Header.statenames;
for idx = 1:length(raw_sds.states)
    state = raw_sds.states(idx);
    t1 = round(1+(raw_sds.t1times(idx) * framerate / 1000));
    t2 = round((raw_sds.t2times(idx) * framerate / 1000));
    seq = cat(1,seq,[t1,state]);
end
