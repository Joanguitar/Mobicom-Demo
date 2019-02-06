%% Clears
clear
clc
%% Parameters
AntennaReference=32;
Antennas=[3, 8, 5, 14, 16, 10, 18, 24, 22, 28, 27, 1];
OnValue=6;
%% Amplitude
Gains_A=zeros(32, length(Antennas)+1); % Initialize to 0
Phase_A=Gains_A; % Set to 0
Gains_A(AntennaReference, 1)=OnValue; % Measure antenna reference amplitude
Gains_A(sub2ind([32, length(Antennas)+1], Antennas, 2:length(Antennas)+1))=OnValue; % Measure antennas amplitude
%% Phase
Gains_P=repmat(Gains_A(:, 1), 1, length(Antennas)*4)+kron(Gains_A(:, 2:end), ones(1, 4)); % Reference and each on for 4 measurements
Phase_P=kron(Gains_P(:, 1:4:end)>0, 0:3); % 0:3 pattern
Phase_P(AntennaReference, :)=0; % Set antenna reference phase to 0
%% Combine
Gains=[Gains_A, Gains_P];
Phase=[Phase_A, Phase_P];
%% Check number of beampatterns
if size(Gains, 2)>62
    error('Too many antennas to measure        Fuck You Hany!')
end
%% Derive
DistributionAmplifiers=(kron(eye(8), ones(1, 4))*Gains>0)*1;
Switch=repmat([0, 0, 0, 0, 1, 1, 0, 0], size(Gains, 2), 1).';
BPInfo=Params2BPInfo(Phase, Gains, DistributionAmplifiers, Switch);
BPInfo0=BRDFile2BPInfo('wil6210_orig.brd');
BPInfo0(:, 1:64)=0;
BPInfo0(:, 65-(1:size(BPInfo, 2)))=BPInfo;
BPInfo0(:, 1:2)=BPInfo(:, [1, 1]);
BPInfo2BRDFile(BPInfo0)