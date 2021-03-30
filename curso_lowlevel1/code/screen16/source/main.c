
#include <gba_base.h>
#include <gba_video.h>
#include <gba_systemcalls.h>
#include <gba_interrupt.h>

#define RGB16(r,g,b)  ((r)+((g)<<5)+((b)<<10)) 

int main()
{
	int x,y,g = 0;  

	// Set up the interrupt handlers
	irqInit();
	// Enable Vblank Interrupt to allow VblankIntrWait
	irqEnable(IRQ_VBLANK);
 
	// Allow Interrupts
	REG_IME = 1;

  // GBA's VRAM is located at address 0x6000000. 
  // Screen memory in MODE 3 is located at the same place
  volatile unsigned short* screen = (unsigned short*)0x6000000;
  // GBA's graphics chip is controled by registers located at 0x4000000 
  volatile unsigned int* video_regs = (unsigned int*) 0x4000000; // mode3, bg2 on (16 bits RGB)
  // Configure the screen at mode 3 using the display mode register
  video_regs[0] = 0x403; // mode3, bg2 on (16 bits RGB)

  // 240 * 160 
    for(y = 0; y<160*240; y++){
  		screen[y] = 0x7FFF;
    }
    
    unsigned short* ptr_one = &screen[20+10*240];
    
    for(y = 10 ; y < 150 ; ++y){
		*ptr_one = 0x0000;	
		ptr_one+=240;
	}
    
    for(y = 20 ; y < 220 ; ++y){
		*ptr_one++ = 0x0000;
	}
    for(y = 10 ; y < 150 ; ++y){
		*ptr_one = 0x0000;	
		ptr_one-=240;
	}
    for(y = 20 ; y < 220 ; ++y){
		*ptr_one-- = 0x0000;
	}
	
	//memset(ptr_one,0xFF,(20-220)*sizeof(unsigned short));
	

	
    
    
	while(1) {
		VBlankIntrWait();

    // Fill scren
    //for(y = 0; y<160; y++) 
    //  for(x = 0; x<240;x++)
    //    screen[x + y * 240] = RGB16(y & 31, g, x & 31);
    


    //g++;
  }
}


