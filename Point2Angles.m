%% Clears
clear
clc
%% Parameters
I=[1703, 400, 107, 90, 300, 1000];
%% Load BP information
load('complex_gains.mat')
g(isnan(g))=0;
%% Compute Beam-patterns
for ii=1:length(I)
    fprintf('Beampattern %2i pointing to: (az=%3.2f, el%3.2f)\n', ii-1, az(I(ii)), el(I(ii)))
    BP(:, ii)=AdaptCBP(g(I(ii), :)).';
end
%% Extract
Phase=mod(round(angle(BP)*2/pi), 4); % Load transmission BPs
Gains=(abs(BP)>0)*1; % Load transmission BPs
%% Create Codebook
DistributionAmplifiers=(kron(eye(8), ones(1, 4))*Gains>0)*1;
Switch=repmat([0, 0, 0, 0, 1, 1, 0, 0], size(Gains, 2), 1).';
BPInfo=Params2BPInfo(Phase, Gains, DistributionAmplifiers, Switch);
BPInfo0=BRDFile2BPInfo('wil6210_orig.brd');
BPInfo0(:, 1:64)=0;
BPInfo0(:, 65-(1:size(BPInfo, 2)))=BPInfo;
BPInfo0(:, 1:2)=BPInfo(:, [1, 1]);
BPInfo2BRDFile(BPInfo0)