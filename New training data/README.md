Corresponding to every 28 by 28 image matrix a 56 by 56 image matrix is constructed by spliiting a grid point into 4 new points, each with the same pixel value as before.
A new average image matrix of size 56 by 56 is now constructed from this matrix by assigning to each grid point the average pixel value computed by 
considering its 8 neighbors.

This process is iterated 2 more times to get an 224 by 224 averaged image matrix. These matrices are now considered for analysis.
