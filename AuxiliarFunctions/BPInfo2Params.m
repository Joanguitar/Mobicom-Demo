function [ PhaseShift, Gains, DistributionAmplifiers, Switch ] = BPInfo2Params(BPInfo)

BPInfo(129:192, :)=BPInfo([161:192, 129:160], :); % New version bit sweep
BPInfo(1:64, :)=BPInfo([33:64, 1:32], :); % New version bit sweep
BPInfo(65:128, :)=BPInfo([97:128, 65:96], :); % Change bits 1-2 to fit Daniel's parsing

BPInfo(1:64, :)=BPInfo([1:2:63, 2:2:64], :);
PhaseShift=BPInfo(33:64, :)*2+BPInfo(1:32, :);
Gains=BPInfo(129:160, :)*4+BPInfo(97:128, :)*2+BPInfo(65:96, :);
BPInfo(161:184, :)=BPInfo([161:3:182, 162:3:183, 163:3:184], :); % Reorder
DistributionAmplifiers=BPInfo(177:184, :)*4+BPInfo(169:176, :)*2+BPInfo(161:168, :);
Switch=BPInfo(185:192, :)*1;

end