@ void Paint (volatile unsigned short* dst,unsigned char* sprite,int stride_pixels,unsigned int color)
@ r0 -> volatile unsigned short* dst
@ r1 -> unsigned char* sprite
@ r2 -> int stride_pixels
@ r3 -> unsigned int color

.global Paint

Paint:

  stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}       @ Prolog

  mov r14, #0x1f;
  and r7, r3, r14             @int ball_r = color & 0x1f;
  and r8, r14, r3, lsr#5      @int ball_g = (color >> 5) & 0x1f;
  and r9, r14, r3, lsr#10     @int ball_b = (color >> 10) & 0x1f;

  mov r4, #16                 @y=16
first_for:
  mov r5, #16                 @x=16
second_for:

  ldrb r6, [r1], #1           @int t = *sprite;
  cmp r6, #0                  @if(t)
  beq transparent_pixel
  
  ldrh r6, [r0]               @unsigned int back_color = *dst;
  
  and r10, r14, r6            @int r = back_color & 0x1f;
  and r11, r14, r6, lsr #5    @int g = (back_color >> 5) & 0x1f;
  and r12, r14, r6, lsr #10   @int b = (back_color >> 10) & 0x1f;

  add r10, r10, r10, lsl #1   @r = (r << 1) + r
  add r10, r10, r7            @r = ((r << 1) + r + ball_r);
  mov r10, r10, asr #2        @r = ((r << 1) + r + ball_r) >> 2;

  add r11, r11, r11, lsl #1   @g = (r << 1) + g
  add r11, r11, r8            @g = ((r << 1) + g + ball_g);
  mov r11, r11, asr #2        @g = ((r << 1) + g + ball_g) >> 2;

  add r12, r12, r12, lsl #1   @b = (b << 1) + b
  add r12, r12, r9            @b = ((b << 1) + b + ball_b);
  mov r12, r12, asr #2        @b = ((b << 1) + b + ball_b) >> 2;

  orr r6, r10, r11, lsl #5    @*dst = r | (g << 5)
  orr r6, r6, r12, lsl #10    @*dst = r | (g << 5) | (b<<10);

  strh r6, [r0]   

transparent_pixel:
  
  add r0,r0, #2  @dst++;

  subs r5,r5, #1
  bgt second_for

  sub r6, r2, #16
  add r0, r0, r6, lsl #1    @ dst += stride_pixels - side;

  subs r4, r4, #1
  bgt first_for                                               
             

  ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}       @ Epilog
  bx      lr
