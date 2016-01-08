sep = filesep;
directory = 'C:\Users\Behnam\Desktop\Left_Right_Nonthickening';
FileList = dir(directory);
N = size(FileList,1);

thick_mean1 = zeros(1,N);
thick_mean2 = zeros(1,N);
thick_folder = cell(1,N);

for k = 1:100
    k
    [pathstr, name, ext] = fileparts([directory sep FileList(k).name]);
    tempdir = [pathstr sep name];
    tempFileList = dir(tempdir);
    
    for ii = 1:3
        try
            original_img = dicomread([pathstr sep name sep tempFileList(ii).name]);
            
            resized_img = imresize(original_img, 1000/size(original_img,2));
            skin_info = skin(resized_img);
            thickness = skin_info(:,5);
            for times = 1:4
                [thickness, outliers] = thickness_smoothing(thickness);
            end
            thick_mean1(k) = mean(abs(thickness));
            
            original_img = dicomread([pathstr sep name sep tempFileList(ii+1).name]);
            resized_img = imresize(original_img, 1000/size(original_img,2));
            skin_info = skin(resized_img);
            thickness = skin_info(:,5);
            thickness = thickness_smoothing(thickness);
            for times = 1:4
                [thickness, outliers] = thickness_smoothing(thickness);
            end
            thick_mean2(k) = mean(abs(thickness));
        catch me
            continue;
        end
    end
    
    thick_folder{k} = name;
end
