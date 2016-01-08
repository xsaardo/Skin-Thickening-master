img = imread('Images/433.png');
img = imresize(img,1000/size(img,2));
W = graydiffweight(img,0);
R = 1;
C = 1;
[bw d]= imsegfmm(W,C,R,0.0001);
imshow(bw);