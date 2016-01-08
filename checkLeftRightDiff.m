thres = 2;
sep = filesep;

skin_thickness_diff = abs(thick_mean1 - thick_mean2);

for ii = 39:length(skin_thickness_diff)
    if skin_thickness_diff(ii) > thres
        
        M_folder = thick_folder{ii};
        path =['C:\Users\Behnam\Desktop\Left_Right_Nonthickening\' M_folder sep];
        left_right_img_files = dir(path);
        
        
        try
            left_file = [path sep left_right_img_files(3).name];
            right_file = [path sep left_right_img_files( 4).name];
            
            plotskinlayers(left_file);
            plotskinlayers(right_file);
        catch me
            continue;
        end
        
        pause;
        close all;
    end
end
