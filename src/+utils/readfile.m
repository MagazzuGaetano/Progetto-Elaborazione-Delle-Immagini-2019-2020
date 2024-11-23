function out = readfile(path)
%READFILE Read a text file

f = fopen(path);
l = textscan(f, '%s', 'delimiter', '\n');
out = l{:};
fclose(f);
end