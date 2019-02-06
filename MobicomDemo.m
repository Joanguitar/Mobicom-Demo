%% Clears
clear
clc
%% Add Folders
IncludeFolder('MyFunctions', 'SimulationTools', 'MeasureCSI')
%% Parameters
AntennaReference=32;
Antennas=[3, 8, 5, 14, 16, 10, 18, 24, 22, 28, 27, 1];
AP_IP='192.168.4.2';
STA_IP='192.168.4.3';
Colors=[1, 0, 0;...
    0, 0, 1;...
    0, 0.75, 0];
N_spline=2^10;
param_LineWidth=2;
%% Load BP information
[PhaseShift, Gains]=BPInfo2Params(BRDFile2BPInfo('wil6210_orig.brd'));
BP_orig=bsxfun(@rdivide, double(Gains>0), sqrt(sum(Gains>0))).*exp((pi/2*1i)*double(PhaseShift));
BP_orig(isnan(BP_orig))=0;
load('complex_gains.mat')
g_full=g(el==0, :);
g_full(isnan(g_full))=0;
g=g(el==0, [AntennaReference, Antennas]);
g(isnan(g))=0;
az=az(el==0);
clear el PhaseShift Gains
R_orig=abs(g_full*conj(BP_orig)).^2;
az_spline=linspace(az(1), az(end), N_spline).';
R_orig_spline=spline(az, R_orig.', az_spline.').';
%% Create plot
figure(1), clf
hold on
plot(nan, 'Color', Colors(1, :), 'LineWidth', param_LineWidth);
plot(cos(linspace(0, pi, 1024)), sin(linspace(0, pi, 1024)), '-k', 'LineWidth', param_LineWidth);
plot([zeros(1, 7); cos(linspace(0, pi, 7))], [zeros(1, 7); sin(linspace(0, pi, 7))], '--k', 'LineWidth', 0.5)
plot_STA=plot(cos((90-az_spline)*pi/180), sin((90-az_spline)*pi/180), 'Color', Colors(1, :), 'LineWidth', param_LineWidth);
hold off
axis equal
title('Angular spectrum')
%% Define SSH connection
ssh_STA=ssh2_config(STA_IP, 'root', '12345');
ssh_AP=ssh2_config(AP_IP, 'root', '12345');
%% Loop
tic
dump=cell(1, 2);
while true
    tic
    %% Measurement parallel
    [ssh_STA, dump]=ssh2_command(ssh_STA, 'bash /joanscripts/opendump');
    dump=cell2mat(cellfun(@(a)[a, ' '], dump.', 'UniformOutput', false));
    [sec_STA, rssi_STA, qdb_STA]=ParseDump(dump);
    %% Process
    CG_STA=SecRSSI2CG(sec_STA, rssi_STA, length(Antennas));
    CG_STA(isnan(CG_STA))=0;
    %% Draw beampattern
    if sum(abs(CG_STA).^2)>0
        R_STA=abs(g*CG_STA'/sqrt(sum(abs(CG_STA).^2))).^2;
        R_CBP=abs(g*AdaptCBP(CG_STA)').^2;
    else
        R_STA=zeros(size(R_STA));
        R_CBP=zeros(size(R_CBP));
    end
    mmax=max(R_STA);
    set(plot_STA, 'Xdata', R_STA/mmax.*cos((90-az)*pi/180), 'Ydata', R_STA/mmax.*sin((90-az)*pi/180))
    %% Draw
    drawnow
end