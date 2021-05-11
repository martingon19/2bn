
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <SDL.h>

static inline int sat (int s, int min, int max)
{
  if (s < min) s = min;
  if (s > max) s = max;
  return s;
}

int main (int a, char** b)
{
    int x, y;
    SDL_Surface *temp;
 
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
	    printf("Unable to initialize SDL: %s\n", SDL_GetError());
	    return 1;
    }

    temp = SDL_LoadBMP(b[1]);
    if (temp == NULL) {
	    printf("Unable to load bitmap: %s\n", SDL_GetError());
	    return 1;
    }
     
    SDL_LockSurface (temp);

    unsigned char* pix = (unsigned char*)temp->pixels;
    unsigned char* grey = (unsigned char*) malloc(temp->w * temp->h);
    for (y=0; y<temp->h; y++)
        for (x=0; x<temp->w; x++) {
          /*int r = *pix++; 
          int g = *pix++;
          int b = *pix++;
          int l = (r + g + b) / 3;*/
          int l = *pix++;
          grey[x + y * temp->w] = l;
        }    

    static int cnt = 0;
    for (y=0; y<temp->h;y++) {
        for (x=0; x<temp->w; x++) {
          int xp = (x < (temp->w - 1)) ? x + 1 : x;
          int yp = (y < (temp->h - 1)) ? y + 1 : y;

          int lc = grey[x + y * temp->w];
          int lxp = grey[xp + y * temp->w];
          int lyp = grey[x + yp * temp->w];
          
          int dx = (lxp - lc) / 5;
          int dy = (lyp - lc) / 5;
          dx = sat(dx, -128, 127);
          dy = sat(dy, -64,  63);
         
          int offs = dx + dy * 512;
          //fprintf (stderr, "%d %d %d\n", dx, dy, offs);

          if (cnt == 0)
              fprintf (stdout, "const signed short bump[%d * %d] = {\n    ", temp->w, temp->h);

          fprintf (stdout, "%d,", offs);

          if ((cnt % 8) == 7)
              fprintf (stdout, "\n    ");
          cnt++;
        } 
    } 

    fprintf (stdout, "};\n\n");

    SDL_UnlockSurface (temp);

    SDL_FreeSurface(temp);

    return 1;
}

