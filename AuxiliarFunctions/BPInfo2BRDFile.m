function [  ] = BPInfo2BRDFile( BPInfo )
load('BoardInfo.mat') % Load original file
if exist('MemorIm', 'var')
    FileOrigin(MemorI)=BPInfo(MemorIm); % Dump new beam-patterns
else
    FileOrigin(MemorI)=BPInfo; % Dump new beam-patterns
end
File8=bi2de(reshape(FileOrigin, 8, length(FileOrigin)/8).'); % Compute File in uint8
File8(17:20)=0; % Remove crc32
crc32code=crc32(File8); % Compute uint32 crc32
crc32code=bi2de(reshape(de2bi(crc32code, 32), 8, 4).'); % Convert to uint8
File8(17:20)=crc32code; % attach crc32
fid=fopen('wil6210.brd', 'w+'); % Open wil6210.brd for writting
fwrite(fid, File8); % Write file
fclose(fid); % Close file
end