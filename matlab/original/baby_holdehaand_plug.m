function [TrialName, ChildLowerArmRadius,ChildUpperArmRadius,MotherLowerArmRadius,MotherUpperArmRadius,C3Dfilename,StartFrameNo,EndFrameNo] = baby_holdehaand_plug(C3Dfilename,EndFrameNo)
% BABY_HOLDEHAAND_PLUG
%
% baby_holdehaand_plug(C3Dfilename)
%
% Author: Mads Dyrholm

[dummy,TrialName,dummyext] = fileparts(C3Dfilename); %'CorolaFreja_4mdr';

StartFrameNo = -1;
if nargin<2
    EndFrameNo = 36000;
end
% Child arm approximation initialization
ChildLowerArmRadius = 0.02;
ChildUpperArmRadius = 0.02;

MotherLowerArmRadius = 0.04;
MotherUpperArmRadius = 0.04;

