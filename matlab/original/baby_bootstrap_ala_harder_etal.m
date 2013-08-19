function [z_score,TAB_1,TAB_boot,MM1,MM2] = baby_bootstrap_ala_harder_etal(seq1,tab1,seq2,tab2,Nboot)
% BABY_BOOTSTRAP_ALA_HARDER_ETAL
%
%  Synopsis
%  ========
%
%  [z_score,TAB_1,TAB_boot,MM1,MM2] = baby_bootstrap_ala_harder_etal(seq1,tab1,seq2,tab2)
%  [z_score,TAB_1,TAB_boot,MM1,MM2] = baby_bootstrap_ala_harder_etal(seq1,tab1,seq2,tab2,Nboot)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     September 2012
%
%  Purpose
%  =======
%  
%  Inputs
%  ======
% 
%  Outputs
%  =======
%
%  [ AbB , BbA ;
%    AiB , BiA ]

if nargin<5
  Nboot = 1999;
end

% this one
[AbB_1,BbA_1,AiB_1,BiA_1] = baby_tabulate_nansafe(seq1,tab1,seq2,tab2);
TAB_1 = [AbB_1,BbA_1;
         AiB_1,BiA_1];

% bootstrap

[T1,statelist1,P1,e1,startfr1,endfr1] = baby_seq_markov(seq1);
[T2,statelist2,P2,e2,startfr2,endfr2] = baby_seq_markov(seq2);

TAB_boot = zeros(2,2,Nboot);

for bb=1:Nboot
    fprintf('sample %i\n',bb);
    % sample
    seq1_boot = baby_markov_run(T1,P1,statelist1,endfr1);
    seq1_boot = baby_seq_copynan(seq1,seq1_boot);
    seq2_boot = baby_markov_run(T2,P2,statelist2,endfr2);
    %seq2_boot = baby_seq_copynan(seq2,seq2_boot);
    % tabulate
    [AbB,BbA,AiB,BiA] = baby_tabulate_nansafe(seq1_boot,tab1,seq2_boot,tab2);
    TAB_boot(:,:,bb) = [AbB, BbA; AiB, BiA];
end

z_score =  ( TAB_1 - mean(TAB_boot,3) ) ./ std( TAB_boot,0,3) ;

MM1.T = T1;
MM1.statelist = statelist1;
MM1.P = P1;
MM1.e = e1;
MM1.endfr = endfr1;
MM1.startfr = startfr1;

MM2.T = T2;
MM2.statelist = statelist2;
MM2.P = P2;
MM2.e = e2;
MM2.endfr = endfr2;
MM2.startfr = startfr2;

