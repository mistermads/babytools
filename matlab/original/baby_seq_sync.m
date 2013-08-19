function [seq1_new,seq2_new,delay_fr1,delay_fr2] = baby_seq_sync(seq1,seq2,delay_ms,fps)
% BABY_SEQ_DELAY
%
%  Synopsis
%  ========
%
%  [seq1_new,seq2_new,delay_fr1,delay_fr2] = baby_seq_sync(seq1,seq2,delay_frames)
%  [seq1_new,seq2_new,delay_fr1,delay_fr2] = baby_seq_sync(seq1,seq2,delay_ms,fps)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
%
%  Purpose
%  =======
%
%  Delay one or the other seq.
%
%  Inputs
%  ======
%
%  delay_frames - If negative the seq1 is delayed, if positive the seq2 is delayed.
%
%  delays_ms, fps - To specify delay in terms of time and frame rate.
%
%  Outputs
%  =======
%
%  Both seq1 and seq2 are returned, but one of them is delayed. delay_fr# 
%  returns the respective delays.

if nargin<=3
    delay_frames = delay_ms;
else
    delay_frames = delay_ms*fps/1000;
end

delay_fr1 = max(0, round(-delay_frames) );
delay_fr2 = max(0, round(+delay_frames) );

seq1_new = baby_seq_delay(seq1,delay_fr1);
seq2_new = baby_seq_delay(seq2,delay_fr2);
