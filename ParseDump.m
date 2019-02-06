function [ sec, rssi, qdb, mac ] = ParseDump( dump )

Start0=strfind(dump, 'Sector Sweep Dump: {');
End0=strfind(dump, '}');


if isempty([Start0, End0])
    sec=[];
    rssi=[];
    qdb=[];
else
    Start=Start0+21;
    End=End0-1;
    dump=dump(Start:End); % Crop
    ParS=find(dump=='('); % Find parenthesis (
    ParE=find(dump==')'); % Find parentheses )
    dump(cell2mat(arrayfun(@colon, ParS, ParE, 'UniformOutput', false)))=[]; % Eliminate parenthesis
    dump=reshape(dump, 63, length(dump)/63).';
    dump(:, [1, 2, end])=[];
    sec=str2num(dump(:, 6:9));
    rssi=str2num(dump(:, 15:23));
    qdb=str2num(dump(:, 28:32));
    mac=dump(:, 43:59);
end

end