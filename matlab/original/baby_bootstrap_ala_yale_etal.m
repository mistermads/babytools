function [p_z,z_score,TAB_1,TAB_huske] = baby_bootstrap_ala_yale_etal(seq1,tab1,seq2,tab2,Nboot)
% BABY_BOOTSTRAP_ALA_YALE_ETAL
%
%  Synopsis
%  ========
%
%  [p_z,z_score,TAB_1,TAB_boot] = baby_bootstrap_ala_yale_etal(seq1,tab1,seq2,tab2)
%  [p_z,z_score,TAB_1,TAB_boot] = baby_bootstrap_ala_yale_etal(seq1,tab1,seq2,tab2,Nboot)
% 
%  -- Author: Mads Dyrholm --
%     Department of Psychology, University of Copenhagen, Denmark.
%     March 2012
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
[AbB_1,BbA_1,AiB_1,BiA_1] = baby_tabulate(seq1,tab1,seq2,tab2);
TAB_1 = [AbB_1,BbA_1;
         AiB_1,BiA_1];

% bootstrap
[T1,statelist1,P1,e1,Nfr1] = baby_seq_markov(seq1);
[T2,statelist2,P2,e2,Nfr2] = baby_seq_markov(seq2);

TAB_huske = zeros(2,2,Nboot);

for bb=1:Nboot
  progress(Nboot,bb)
  % sample
  seq1_boot = baby_markov_run(T1,P1,statelist1,Nfr1);
  seq2_boot = baby_markov_run(T2,P2,statelist2,Nfr2);
  % tabulate
  [AbB,BbA,AiB,BiA] = baby_tabulate(seq1_boot,tab1,seq2_boot,tab2);
  TAB_huske(:,:,bb) = [AbB, BbA; AiB, BiA];
end

%ST = sort(TAB_huske,3);
%CI95_idx = .95 * Nboot
%for i=1:2
%  for j=1:2
%    max(find(TAB_1(i,j) > squeeze(ST(i,j,:))))
%  end
%end
%p_rank = sum(repmat(TAB_1,[1 1 Nboot]) > TAB_huske,3) / Nboot;

z_score =  ( TAB_1 - mean(TAB_huske,3) ) ./ std( TAB_huske,0,3) ;
p_z = 1-normcdf(z_score,0,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUX
function progress(N,n)
% progress
if floor(mod(n,N/100))==0, fprintf('.'); end
if floor(mod(n,N/10))==0, fprintf('%i%%',round(100*(n/N))); end
