function [skin_info_final,img] = skin(img)
% Given path to an image, constructs matrix containing breast boundary
% coordinates, corresponding normal vector, and skin thickness

%% Parameters
roi_size = 50;  % Dimension of ROI for determining direction is square with sides (2*roi_size+1)
dist = 50;      % Distance of pixels perpendicular to breast outline to check

original_img = img;
% original_img = dicomread(imgpath);

%% Segmentation to identify breast boundary points

W = graydiffweight(original_img,0);
R = 1;
C = 1;
[bw_img]= imsegfmm(W,C,R,0.0001);

% External breast boundary points determined after contouring
figure;
[cont] = imcontour(bw_img,1);
[edge_cols, edge_rows, ~] = C2xyz(cont);

% Choose contour with most elements
current_size = 0;
for numcontours = 1:numel(edge_cols)
    if size(edge_cols{numcontours},2) > current_size
        edge_col = edge_cols{numcontours}';
        edge_row = edge_rows{numcontours}';
    end
    current_size = size(edge_col,1);
end
close
% Initialize direction matrix/thickness vector for each edge pixel
dirs = zeros(length(edge_col),2);
thickness = zeros(length(edge_col),1);

%% Find corresponding internal skin layer thickness for each boundary pixel
for i = 1:5:length(edge_col)
    
    % Ignore edge pixels close to image boundaries
    if edge_row(i) - roi_size < 1 || edge_row(i) + roi_size > size(original_img,1) ...
            || edge_col(i) - roi_size < 1 || edge_col(i) + roi_size > size(original_img,2)
        continue
    end
    
    % Identify thresholded ROI around each boundary pixel
    roi = bw_img((edge_row(i)-roi_size):(edge_row(i)+roi_size), ...
        (edge_col(i)-roi_size):(edge_col(i)+roi_size));
    
    % Find angle of breast boundary for each ROI
    a = find(imgradient(roi(1,:)),1);
    b = find(imgradient(roi(end,:)),1);
    c = find(imgradient(roi(:,1)),1);
    d = find(imgradient(roi(:,end)),1);
    
    angle = 0;
    
    if ~isempty(c) && ~isempty(d)
        angle = atan((c(1)-d(1))/size(roi,1));
    elseif ~isempty(b) && ~isempty(d)
        angle = atan((size(roi,1)-d(1))/(size(roi,1)-b(1)));
    elseif ~isempty(b) && ~isempty(c)
        angle = atan(-(size(roi,1)-c(1))/b(1));
    elseif ~isempty(a) && ~isempty(d)
        angle = atan(-d(1)/(size(roi,1)-a(1)));
    elseif ~isempty(a) && ~isempty(c)
        angle = atan(c(1))/(a(1));
    elseif ~isempty(a) && ~isempty(b)
        angle = atan(size(roi,1)/(a(1)-b(1)));
    end
    
    % Given angle of breast boundary, find angle perp to breast boundary
    if angle >= 0
        angle = angle - pi/2;
    elseif angle < 0
        angle = angle + pi/2;
    end
    
    % Normal vector to breast boundary
    dirs(i,:) = [cos(-angle) sin(-angle)];
    
    % Pixel intensity profile of line perpendicular to edge
    outflag = 0;
    yi = [edge_row(i),edge_row(i) + dist*dirs(i,2)];
    xi = [edge_col(i),edge_col(i) + dist*dirs(i,1)];
    linelength = round(sqrt((dist*dirs(i,1))^2+(dist*dirs(i,2))^2));
    skinhist = improfile(original_img,xi,yi,linelength);
    
    % alternate line profile if curvature induces normal pointing outside breast
    if mean(skinhist) < 10
        yi = [edge_row(i),edge_row(i) - dist*dirs(i,2)];
        xi = [edge_col(i),edge_col(i) - dist*dirs(i,1)];
        skinhist = improfile(original_img,xi,yi,linelength);
        outflag = 1;
    end
    
    % Find internal skin pixel based on gradient minimum
    skinhist = gradient(skinhist);
    [pks,loc] = findpeaks(-skinhist);   % Find local gradient minima
    pks(pks < 7) = 0;                   % Remove small local minima (no visible skin layer)
    loc = loc(pks == max(pks));         % Select pixel location of highest gradient
    if isempty(loc)
        continue;
    end
    
    % If normal points outward then thickness is negative
    if outflag
        thickness(i) = -loc(1);
    else
        thickness(i) = loc(1);
    end
end


% For each breast boundary coordinate, store normal vector and skin
% thickness
skin_info_final = [edge_col,edge_row,dirs,thickness];

% Remove rows without the above information due to skipped boundary points
skin_info_final(skin_info_final(:,5) == 0,:) = [];

end