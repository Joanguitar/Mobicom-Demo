function [ CG ] = LoadCG( filename )
%LOADCG Summary of this function goes here
%   Detailed explanation goes here
fileID = fopen(filename);
data = textscan(fileID, ['%d %f %s %d %d %d %d %d %d %d %d %d %d %d %d' ...
' %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d' ...
' %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d' ...
' %d %d %d %d %d %d %d %d %d %d %d %d %d'], 'Delimiter', ',');
fclose(fileID);
data=data([1 7 9:end]);
L=min(cellfun(@length, data));
data=cellfun(@(a)a(1:L), data, 'UniformOutput', false);
data = double(cell2mat(data));
data = data(((data(:,1) == 0) & (data(:,2) == 0)),:);
% Remove rows that all zeros
data(all(data==0,2),:) = [];
phaseFirstColumn=3;
amplitudeFirstColumn=35;
phase = 2 * pi * data(:, phaseFirstColumn + (0:31))/1024;
amplitude = data(:, amplitudeFirstColumn + (0:31))/178;
CG = amplitude .* exp(1j * phase);

end