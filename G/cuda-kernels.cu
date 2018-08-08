__global__ void copyImgKernel(unsigned char* img_in, unsigned char* img_out, int width, int height)
{
   int i = threadIdx.x+blockIdx.x*blockDim.x;
   int j = threadIdx.y+blockIdx.y*blockDim.y;

   if (i<width && j<height)
   {
      int adrIn=(i+j*width)*4;
      int adrOut=adrIn;
      unsigned char r,g,b,a;

      r = img_in[adrIn+0];
      g = img_in[adrIn+1];
      b = img_in[adrIn+2];
      a = img_in[adrIn+3];
    
      img_out[adrOut+0] = r; 
      img_out[adrOut+1] = g;
      img_out[adrOut+2] = b;
      img_out[adrOut+3] = a;
   }
}

__global__ void linearTransformKernel(unsigned char* img_in, unsigned char* img_out, int width, int height, float alpha, float beta)
{
    int i = threadIdx.x+blockIdx.x*blockDim.x;
    int j = threadIdx.y+blockIdx.y*blockDim.y;

    
    if (i<width && j<height)
    {
        int adrIn=(i+j*width)*4;
        int adrOut=adrIn;
        unsigned char r,g,b,a;
        float r_new, g_new, b_new;
        
        r = img_in[adrIn+0];
        g = img_in[adrIn+1];
        b = img_in[adrIn+2];
        a = img_in[adrIn+3];
        
        r_new = alpha*r + beta;             //%\label{line:linearStart}%
        r_new = r_new < 0?     0 : r_new;
        r_new = r_new > 255? 255 : r_new;

        g_new = alpha*g + beta;
        g_new = g_new < 0?     0 : g_new;
        g_new = g_new > 255? 255 : g_new;

        b_new = alpha*b + beta;
        b_new = b_new < 0?     0 : b_new;
        b_new = b_new > 255? 255 : b_new;   //%\label{line:linearEnd}%

        img_out[adrOut+0] = (unsigned char)r_new; 
        img_out[adrOut+1] = (unsigned char)g_new;
        img_out[adrOut+2] = (unsigned char)b_new;
        img_out[adrOut+3] = a;
    }
}

__global__ void mirrorKernel(unsigned char* img_in, unsigned char* img_out, int width, int height)
{
    int i = threadIdx.x+blockIdx.x*blockDim.x;
    int j = threadIdx.y+blockIdx.y*blockDim.y;

    
    if (i<width && j<height)
    {
        int adrIn;
        int adrOut=(i+j*width)*4;
        unsigned char r,g,b,a;
        
        if (i < width/2) {      // //%Adressberechnung nach Formel (\ref{eq:mirror})%
            adrIn=adrOut;
        
        } else {
            adrIn=(width-i+j*width)*4; %\label{line:mirror}%
        }
        r = img_in[adrIn+0];
        g = img_in[adrIn+1];
        b = img_in[adrIn+2];
        a = img_in[adrIn+3];

        img_out[adrOut+0] = r; 
        img_out[adrOut+1] = g;
        img_out[adrOut+2] = b;
        img_out[adrOut+3] = a;
    }
}

__global__ void bwKernel(unsigned char* img_in, unsigned char* img_out, int width, int height)
{
    int i = threadIdx.x+blockIdx.x*blockDim.x;
    int j = threadIdx.y+blockIdx.y*blockDim.y;

    if (i<width && j<height)
    {
        int adrIn=(i+j*width)*4;
        int adrOut=adrIn;
        unsigned char r,g,b,a;
        unsigned char bw;

        r = img_in[adrIn+0];
        g = img_in[adrIn+1];
        b = img_in[adrIn+2];
        a = img_in[adrIn+3];
    
        bw = (r+g+b)/3;

        img_out[adrOut+0] = bw; 
        img_out[adrOut+1] = bw;
        img_out[adrOut+2] = bw;
        img_out[adrOut+3] = a;
    }
}

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
        int i_new, j_new, bw;
        unsigned char r,a;

        float gX = 0.0f, gY = 0.0f;

        for (int k = -1; k <= 1; k++) {
            for (int l = -1; l <= 1; l++) {
                i_new = i+k;
                j_new = j+l;

                if (i_new < 0 || i_new > width || j_new < 0 || j_new > height) { //%\label{line:sobelOldIf}%
                    r = 0;
                } else {
                    adrIn=(i_new+j_new*width)*4;
                    r = img_in[adrIn];
                }

                gX += SX[1+k][1+l] * r;
                gY += SY[1+k][1+l] * r;                
            }
        }
        
        adrIn = adrOut;
        a = img_in[adrIn+3];

        bw = sqrtf (gX*gX + gY*gY);

        img_out[adrOut+0] = bw; 
        img_out[adrOut+1] = bw;
        img_out[adrOut+2] = bw;
        img_out[adrOut+3] = a;
    }
}
