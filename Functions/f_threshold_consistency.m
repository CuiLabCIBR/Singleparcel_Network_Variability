function [W_thr, Wcv] = f_threshold_consistency(Ws, p)
%THRESHOLD_CONSISTENCY    Threshold edges ranked by consistency
%
%   W_thr = threshold_consistency(Ws, p);
%
%   This function "thresholds" the group mean connectivity matrix of a set
%   of connectivity matrices by preserving a proportion p (0<p<1) of the
%   edges with the smallest coefficient of variation across the group. All
%   other weights, and all weights on the main diagonal (self-self
%   connections) are set to 0.
%
%   Inputs: Ws,     N-by-N-by-M group of M weighted connectivity matrices,
%                   M = Number of subject
%           p,      proportion of weights to preserve
%                       range:  p=1 (all weights) to
%                               p=0 (no weights)
%
%   Output: W_thr,  thresholded group mean connectivity matrix
%	    Wcv, coefficient of variation
%		
%
%   Reference: Roberts and Breakspear (2016)
%
%   James Roberts, QIMR Berghofer, 2015
%   Above comments based on BCT's threshold_proportional.m 
%   (BCT: brain-connectivity-toolbox.net)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%           Jinbo Zhang EDIT 2020           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wmean=mean(Ws,3); % group mean connectivity matrix
Wcv=std(Ws,0,3)./Wmean; % coefficient of variation across the group
W_thr=f_threshold_arbmeasure(Wmean,-Wcv,p);
