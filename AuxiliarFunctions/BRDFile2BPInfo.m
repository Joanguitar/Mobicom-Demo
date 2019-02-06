function [ BPInfo ] = BRDFile2BPInfo( BRD_name )

fid=fopen(BRD_name);
BRD=fread(fid, '*ubit1');
load('BoardInfo.mat')
BPInfo=BRD(MemorI);
fclose(fid);

end