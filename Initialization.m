%% Clears
clear
clc
%% Parameters
AP_ID=20;
STA_ID=17;
bool_init=true;
%% Define RouterConnectionPair
RouterConnection=RouterConnectionPair(AP_ID, STA_ID);
ssh_STA=ssh2_config(RouterConnection.IP_struct(RouterConnection.STA_ID), 'root', 'imdea');
ssh_AP=ssh2_config(RouterConnection.IP_struct(RouterConnection.AP_ID), 'root', 'imdea');
%% Initialization
if bool_init
    [ssh_AP, ~]=ssh2_command(ssh_AP, 'bash /joanscripts/initialization');
    [ssh_STA, ~]=ssh2_command(ssh_STA, 'bash /joanscripts/initialization');
    pause(1)
else
    [ssh_AP, ~]=ssh2_command(ssh_AP, 'bash /joanscripts/reassociate');
    [ssh_STA, ~]=ssh2_command(ssh_STA, 'bash /joanscripts/reassociate');
end