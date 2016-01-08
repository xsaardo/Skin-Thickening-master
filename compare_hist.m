clc; close all; clear;

% Choose correct file seperator ('\');
sep = filesep;

directory = 'C:\Users\Behnam\Desktop\Skin-Thickening-master\Images\';
FileList = dir(directory);
N = size(FileList,1);
figure;

thick_mean = [];
for k = 1:N
    [pathstr, name, ext] = fileparts([directory sep FileList(k).name]);
    if strcmp(ext,'.png') == 1 
        
       original_img = imread([pathstr name ext]);
       resized_img = imresize(original_img, 1000/size(original_img,2));
       skin_info = skin(resized_img);
       thickness = skin_info(:,5);
       thickness = thickness_smoothing(thickness);
       thickness = thickness(2:end);
       plot(abs(thickness),'g');
       thick_mean = [thick_mean mean(abs(thickness))];
       hold on
       k
    end
end

directory = 'C:\Users\Behnam\Desktop\No Skin Thickening\';
FileList = dir(directory);
N = size(FileList,1);

no_thick_mean = [];
for k = 1:N
    [pathstr, name, ext] = fileparts([directory sep FileList(k).name]);
    if strcmp(ext,'.dcm') == 1 
        
       original_img = dicomread([pathstr name ext]);
       resized_img = imresize(original_img, 1000/size(original_img,2));
       skin_info = skin(resized_img);
       thickness = skin_info(:,5);
       thickness = thickness_smoothing(thickness);
       thickness = thickness(2:end);
       plot(abs(thickness),'r');
       no_thick_mean = [no_thick_mean mean(abs(thickness))];
       hold on
       k
    end
end
