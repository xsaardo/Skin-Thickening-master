function [new_thickness,outliers] = thickness_smoothing(thickness_in)
% Remove anomalous outlier thickness values

thickness = abs(thickness_in);
mavg = 10;
new_thickness = thickness;
outliers = zeros(size(thickness));

% Outlier Labeling
for ii = 1:length(thickness)
    % Check for edge cases
    if ii-mavg < 1              
        first_index = 1;
    else 
        first_index = ii-mavg;
    end
    if ii+mavg > length(thickness)
        end_index = length(thickness);
    else
        end_index = ii + mavg;
    end
    
    if thickness(ii) > mean(thickness(first_index:end_index)) + ...
            0.25*std(thickness(first_index:end_index))
        outliers(ii) = 1;
    end
end

% Outlier Truncation
for ii = 2:length(thickness)-1
    if outliers(ii) == 1
        jj = 1;
        thick_l = thickness(ii-1);
        while outliers(ii-jj) == 1 && ii-jj > 2
            jj = jj + 1;
        end
        thick_l = thickness(ii-jj);
        
        jj = 1;
        thick_r = thickness(ii+1);
        while outliers(ii+jj) == 1 && ii+jj < length(thickness)-1
            jj = jj + 1;
        end
        thick_r = thickness(ii+jj);
        
        new_thickness(ii) = 0.5*(thick_l+thick_r);
        
    else
        new_thickness(ii) = thickness(ii);
    end
end
% new_thickness(new_thickness == 0) = [];
new_thickness(thickness_in < 0) = -new_thickness(thickness_in < 0);