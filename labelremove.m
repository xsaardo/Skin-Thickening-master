FileList = dir('C:\Users\xsaardo\Desktop\mstudy2_cancer_masses_full_images\');
N = size(FileList,1);

for k = 1:N
    if (FileList(k).isdir == 0 && ~isempty(strfind(FileList(k).name, 'thickening')))
        imagename = FileList(k).name;
        image = imread(['C:\Users\xsaardo\Desktop\mstudy2_cancer_masses_full_images\' imagename]);
        [height, width] = size(image);
        image(1:round(height/4),1:round(width/3)) = 0;
        imshow(image);
        imwrite(image,['C:\Users\xsaardo\Desktop\Skin Thickening\' num2str(k) '.png']);
    end
end
