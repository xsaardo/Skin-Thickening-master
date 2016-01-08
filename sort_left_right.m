%% Searches through Mstudy2 folder for all CC images

% thickening_cases = {'M00010', 'M00037', 'M00065', 'M00115', 'M00120', 'M00121', 'M00122', 'M00228', 'M00230', 'M00236', 'M00264', 'M00306', 'M00323'};

i = 1;
for ii = 1:331
    if ii < 10
        folder = ['M0000' num2str(ii)];
    elseif ii < 100
        folder = ['M000' num2str(ii)];
    else
        folder = ['M00' num2str(ii)];
    end
    non_thickening_cases{i} = folder;
    i = i+1;
end

sep = filesep;
directory = 'C:\Users\Behnam\Desktop\Mstudy2\';
FileList = dir(directory);
N = size(FileList,1);
m = 0;

for k = 1:N
    [pathstr, name, ext] = fileparts([directory sep FileList(k).name]);
    %     for ii = thickening_cases
    %         if strcmp(ii,name)
    %             inner_directory = [pathstr sep name];
    %             innerFileList = dir(inner_directory);
    %             L = size(innerFileList,1);
    %             for jj = 1:L
    %                 if strfind(innerFileList(jj).name,'_CC_')
    %                     mkdir('C:\Users\Behnam\Desktop\Left_Right_Thickening', name);
    %                     copyfile([pathstr name sep innerFileList(jj).name],['C:\Users\Behnam\Desktop\Left_Right_Thickening\' name sep]);
    %                 end
    %             end
    %         end
    %     end
    for ii = non_thickening_cases
        if strcmp(ii,name)
            inner_directory = [pathstr sep name];
            innerFileList = dir(inner_directory);
            L = size(innerFileList,1);
            try
                for jj = 1:4
                    [~,~,innerext] = fileparts([inner_directory sep innerFileList{jj}.name]);
                    if strfind(innerFileList(jj).name,'_CC_') && strcmp(innerext,'.dcm')
                        mkdir('C:\Users\Behnam\Desktop\Left_Right_Nonthickening', name);
                        copyfile([pathstr name sep innerFileList(jj).name],['C:\Users\Behnam\Desktop\Left_Right_Nonthickening\' name sep]);
                    end
                end
            catch me
                continue
            end
        end
    end
end
