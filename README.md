# Skin-Thickening

plotskinlayers.m plots the internal skin layer points on top of the original image as well as a plot of thickness vs position and average thickness.
skin.m generates a matrix containing the breast boundary coordinates and corresponding normal vectors and skin thickness for use in plotskinlayers.m.

The images folder contains all of the images after processing with the above scripts

### Description of algorithm:
Images are resized otherwise it would take forever to process a single image

Segmentation of breast region using thresholding of image gradient since only the breast region has gradient values.
Leftover blobs are removed using bwareopen.
The breast boundary coordinates are obtained from the thresholded image and sorted .

At each boundary coordinate the vector normal to the boundary is generated using geometry over a small ROI around each boundary coordinate.
improfile generates the pixel information along the normal vector.  The internal skin location and thickness is selected through the minimum of the gradient of the normal vector pixel profile.  

A thickness value is assigned to each boundary coordinate.  Outputs are the average thickness value and respective plots located in the images folder.

### For further analysis: 
Better outlier suppression - anomalous thickness values are still present with the current outlier truncation method 

~~Closer fit for external skin layer - Current method of using image gradient to segment results in an external boundary pixels away from the actual boundary.~~ Done!
