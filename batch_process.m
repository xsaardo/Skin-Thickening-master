clc; close all; clear;

% Choose correct file seperator ('\');
sep = filesep;

directory = 'C:\Users\Behnam\Desktop\ThickCasesUnsorted\';
FileList = dir(directory);
N = size(FileList,1);

for k = 1:N
    [pathstr, name, ext] = fileparts([directory sep FileList(k).name]);
    if strcmp(ext,'.dcm') == 1 || strcmp(ext,'.png')
       plotskinlayers([pathstr name ext]);
       
    end
end