%% Clears
clear
clc
%% Parameters
AP_IP='192.168.4.2';
STA_IP='192.168.4.3';
bool_init=false;
%% Define RouterConnectionPair
ssh_STA=ssh2_config(STA_IP, 'root', '12345');
ssh_AP=ssh2_config(AP_IP, 'root', '12345');
%% Initialization
if bool_init
    [ssh_AP, ~]=ssh2_command(ssh_AP, 'bash /joanscripts/initialization');
    [ssh_STA, ~]=ssh2_command(ssh_STA, 'bash /joanscripts/initialization');
    pause(1)
else
    [ssh_AP, ~]=ssh2_command(ssh_AP, 'bash /joanscripts/reassociate');
    [ssh_STA, ~]=ssh2_command(ssh_STA, 'bash /joanscripts/reassociate');
end