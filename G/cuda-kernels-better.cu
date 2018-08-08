__global__ void sobelKernel(unsigned char* img_in, unsigned char* img_out, int width, int height)
{
    const float SX[3][3]={{-1,0,1},{-2,0,2},{-1,0,1}};
    const float SY[3][3]={{-1,-2,-1},{0,0,0},{1,2,1}};

    int i = threadIdx.x+blockIdx.x*blockDim.x;
    int j = threadIdx.y+blockIdx.y*blockDim.y;

    if (i<width && j<height)
    {
    	int adrIn;
    	int adrOut=(i+j*width)*4;
        int i_new, j_new;
        unsigned char r,a;
        float bw, gX = 0.0f, gY = 0.0f;
        
        if (i == 0 || i == width-1 || j == 0 || j == height -1) { //%\label{line:sobelBoarder}%
            bw = 0;
        } else {
            for (int k = -1; k <= 1; k++) {        
                for (int l = -1; l <= 1; l++) {
                    i_new = i+k;
                    j_new = j+l;
    
                    adrIn=(i_new+j_new*width)*4;
                    r = img_in[adrIn];

                    gX += SX[1+k][1+l] * r;         //%\label{line:sobelSum}%
                    gY += SY[1+k][1+l] * r;                
                }
            }                                       

            bw = sqrtf (gX*gX + gY*gY);             //%\label{line:sobelNorm}%
            bw = bw < 0? 0 : bw;
            bw = bw > 255? 255 : bw;
        }
        adrIn = adrOut;
        a = img_in[adrIn+3];        //%\label{line:sobelLoadAlpha}%
        
        img_out[adrOut+0] = (unsigned char)bw; 
        img_out[adrOut+1] = (unsigned char)bw;
        img_out[adrOut+2] = (unsigned char)bw;
        img_out[adrOut+3] = a;
    }
}
