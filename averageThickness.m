function avgThickness = averageThickness(img)
skin_info = skin(img);
thickness = skin_info(:,5);
thickness = thickness_smoothing(thickness);
avgThickness = mean(abs(thickness));
end