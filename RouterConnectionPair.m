classdef RouterConnectionPair < handle
    
    properties
        AP_ID;
        STA_ID;
        IP_struct=@(id)sprintf('192.168.4.%i', id+1);
        ssh_STA;
        ssh_AP;
    end
    
    methods
        function obj = RouterConnectionPair(AP_ID, STA_ID)
            obj.AP_ID=AP_ID;
            obj.STA_ID=STA_ID;
            obj.ssh_STA=ssh2_config(obj.IP_struct(obj.STA_ID), 'root', 'imdea');
            obj.ssh_AP=ssh2_config(obj.IP_struct(obj.AP_ID), 'root', 'imdea');
        end
        % Send command to AP
        function [msg] = fun_SSH_AP(obj, command)
            [obj.ssh_STA, msg]=ssh2_command(obj.ssh_STA, command);
            msg=cell2mat(cellfun(@(a)[a, newline], msg.', 'UniformOutput', false));
        end
        % Send command to STA
        function [msg] = fun_SSH_STA(obj, command)
            [obj.ssh_AP, msg]=ssh2_command(obj.ssh_AP, command);
            msg=cell2mat(cellfun(@(a)[a, newline], msg.', 'UniformOutput', false));
        end
%         % Send command to AP
%         function [msg] = fun_SSH_AP(obj, command)
%             [~, msg]=system(sprintf('ssh root@%s "%s"', obj.IP_struct(obj.AP_ID), command)); % Send command to deviceID
%         end
%         % Send command to STA
%         function [msg] = fun_SSH_STA(obj, command)
%             [~, msg]=system(sprintf('ssh root@%s "%s"', obj.IP_struct(obj.STA_ID), command)); % Send command to deviceID
%         end
        % Get measurement information
        function [sec, rssi, qdb] = Measure(obj, dev)
            if nargin<2
                dev='STA';
            end
            dev=upper(dev);
            switch dev
                case 'AP'
                    dump=obj.fun_SSH_AP('bash /joanscripts/opendump');
                case 'STA'
                    dump=obj.fun_SSH_STA('bash /joanscripts/opendump');
                otherwise
                    error('No existing device: %s', dev)
            end
            [sec, rssi, qdb]=ParseDump(dump);
        end
        % Get measurement decomposed
        function Measure_start(obj, dev)
            if nargin<2
                dev='STA';
            end
            dev=upper(dev);
            switch dev
                case 'AP'
                    fun_fun=@(a)obj.fun_SSH_AP(a);
                case 'STA'
                    fun_fun=@(a)obj.fun_SSH_STA(a);
                otherwise
                    error(sprintf('No existing device: %s', dev))
            end
            fun_fun('bash /joanscripts/startsweepdump');
            fun_fun('bash /joanscripts/clearsweepdump');
        end
        function [sec, rssi, qdb] = Measure_stop(obj, dev)
            if nargin<2
                dev='STA';
            end
            dev=upper(dev);
            switch dev
                case 'AP'
                    fun_fun=@(a)obj.fun_SSH_AP(a);
                case 'STA'
                    fun_fun=@(a)obj.fun_SSH_STA(a);
                otherwise
                    error(sprintf('No existing device: %s', dev))
            end
            fun_fun('bash /joanscripts/stopsweepdump');
            dump=fun_fun('cat /joanscripts/variables/sweepdump');
            [sec, rssi, qdb]=ParseDump(dump);
        end
        % Inject BRD
        function InjectBRD(obj, dev)
            if nargin<2
                dev='STA';
            end
            dev=upper(dev);
            switch dev
                case 'AP'
                    [~, temp]=system(sprintf('scp wil6210.brd root@%s:/lib/firmware', obj.IP_struct(obj.AP_ID)));
                    while ~isempty(temp)
                        [~, temp]=system(sprintf('scp wil6210.brd root@%s:/lib/firmware', obj.IP_struct(obj.AP_ID)));
                    end
                case 'STA'
                    [~, temp]=system(sprintf('scp wil6210.brd root@%s:/lib/firmware', obj.IP_struct(obj.STA_ID)));
                    while ~isempty(temp)
                        [~, temp]=system(sprintf('scp wil6210.brd root@%s:/lib/firmware', obj.IP_struct(obj.STA_ID)));
                    end
                otherwise
                    error(sprintf('No existing device: %s', dev))
            end
        end
    end
end