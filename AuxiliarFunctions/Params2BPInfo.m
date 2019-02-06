function [ BPInfo ] = Params2BPInfo(PhaseShift, Gains, DistributionAmplifiers, Switch)
BPInfo=zeros(192, size(PhaseShift, 2), 'logical');
BPInfo(33:64, :)=PhaseShift>1; PhaseShift=mod(PhaseShift, 2);
BPInfo(1:32, :)=PhaseShift>0;
BPInfo([1:2:63, 2:2:64], :)=BPInfo(1:64, :);
BPInfo(129:160, :)=Gains>3; Gains=mod(Gains, 4);
BPInfo(97:128, :)=Gains>1; Gains=mod(Gains, 2);
BPInfo(65:96, :)=Gains>0;
BPInfo(65:128, :)=BPInfo([97:128, 65:96], :); % Change bits 1-2 to fit Daniel's parsing
BPInfo(177:184, :)=DistributionAmplifiers>3; DistributionAmplifiers=mod(DistributionAmplifiers, 4);
BPInfo(169:176, :)=DistributionAmplifiers>1; DistributionAmplifiers=mod(DistributionAmplifiers, 2);
BPInfo(161:168, :)=DistributionAmplifiers>0;
BPInfo([161:3:182, 162:3:183, 163:3:184], :)=BPInfo(161:184, :); % Reorder
BPInfo(185:192, :)=Switch>0;

BPInfo(129:192, :)=BPInfo([161:192, 129:160], :); % New version bit sweep
BPInfo(1:64, :)=BPInfo([33:64, 1:32], :); % New version bit sweep
end