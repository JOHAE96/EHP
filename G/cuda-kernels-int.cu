//CUDA Kernels für Verwendung von Integer in Aufgabe 3.2

#define getR(img) (((unsigned int)img&0xFF000000)>>24)
#define getG(img) (((unsigned int)img&0x00FF0000)>>16)
#define getB(img) (((unsigned int)img&0x0000FF00)>>8)
#define getA(img) (((unsigned int)img&0x000000FF))
#define output(r,g,b,a) (((unsigned int)r<<24)+((unsigned int)g<<16)+((unsigned int)b<<8) + ((unsigned int)a<<0))

__global__ void copyImgKernel(unsigned int* img_in, unsigned int* img_out, int width, int height)
{
   int i = threadIdx.x+blockIdx.x*blockDim.x;
   int j = threadIdx.y+blockIdx.y*blockDim.y;

   if (i<width && j<height)
   {
      int adrIn=(i+j*width);
      int adrOut=adrIn;
      unsigned int r,g,b,a,in;
      in = img_in[adrIn];

      r = getR(in);
      g = getG(in);
      b = getB(in);
      a = getA(in);

      img_out[adrOut] = output(r,g,b,a);
   }
}

__global__ void linearTransformKernel(unsigned int* img_in, unsigned int* img_out, int width, int height, float alpha, float beta)
{
  int i = threadIdx.x+blockIdx.x*blockDim.x;
  int j = threadIdx.y+blockIdx.y*blockDim.y;


  if (i<width && j<height)
  {
      int adrIn=(i+j*width);
      int adrOut=adrIn;
      unsigned int r,g,b,a,in;
      float r_new, g_new, b_new;

      in = img_in[adrIn];

      r = getR(in);
      g = getG(in);
      b = getB(in);
      a = getA(in);

      r_new = alpha*r + beta;
      r_new = r_new < 0?     0 : r_new;
      r_new = r_new > 255? 255 : r_new;

      g_new = alpha*g + beta;
      g_new = g_new < 0?     0 : g_new;
      g_new = g_new > 255? 255 : g_new;

      b_new = alpha*b + beta;
      b_new = b_new < 0?     0 : b_new;
      b_new = b_new > 255? 255 : b_new;

      img_out[adrOut] = output((unsigned int)r_new, (unsigned int)g_new, (unsigned int)b_new, a);
  }
}

__global__ void mirrorKernel(unsigned int* img_in, unsigned int* img_out, int width, int height)
{
  int i = threadIdx.x+blockIdx.x*blockDim.x;
  int j = threadIdx.y+blockIdx.y*blockDim.y;


  if (i<width && j<height)
  {
      int adrIn=(i+j*width);
      int adrOut=adrIn;
      unsigned int r,g,b,a,in;

      if (i < width/2) {
          adrIn=adrOut;

      } else {
          adrIn=(width-i+j*width);
      }

      in = img_in[adrIn];

      r = getR(in);
      g = getG(in);
      b = getB(in);
      a = getA(in);

      img_out[adrOut] = output(r,g,b,a);
    }
}

__global__ void bwKernel(unsigned int* img_in, unsigned int* img_out, int width, int height)
{
  int i = threadIdx.x+blockIdx.x*blockDim.x;
  int j = threadIdx.y+blockIdx.y*blockDim.y;

  if (i<width && j<height)
  {
     int adrIn=(i+j*width);
     int adrOut=adrIn;
     unsigned int r,g,b,a,in,bw;
     in = img_in[adrIn];

     r = getR(in);
     g = getG(in);
     b = getB(in);
     a = getA(in);

     bw = (r+b+g)/3;

     img_out[adrOut] = output(bw,bw,bw,a);
  }
}

__global__ void sobelKernel(unsigned int* img_in, unsigned int* img_out, int width, int height)
{

   const float SX[3][3]={{-1,0,1},{-2,0,2},{-1,0,1}};
   const float SY[3][3]={{-1,-2,-1},{0,0,0},{1,2,1}};

   int i = threadIdx.x+blockIdx.x*blockDim.x;
   int j = threadIdx.y+blockIdx.y*blockDim.y;

   if (i<width && j<height)
   {
     int adrIn;
     int adrOut=(i+j*width);
     int i_new, j_new;
     unsigned int r,a,bw;    // is enough since r=g=b in a grayscale picture

     float gX = 0.0f, gY = 0.0f;

     for (int k = -1; k <= 1; k++) {
         for (int l = -1; l <= 1; l++) {
             i_new = i+k;
             j_new = j+l;

             if (i_new < 0 || i_new > width-1 || j_new < 0 || j_new > height-1) {
                 r = 0;
             } else {
               adrIn=(i_new+j_new*width);
               r = getR(img_in[adrIn]);
             }

             gX += SX[1+k][1+l] * r;
             gY += SY[1+k][1+l] * r;
         }
     }

     adrIn = adrOut;
     a = getA(img_in[adrIn]);

     bw = (unsigned int)sqrtf (gX*gX + gY*gY);

     img_out[adrOut] = output(bw,bw,bw,a);
   }

}
