@ typedef struct
@ {
@   unsigned char*  prev;   //  0   //  ldrb
@   unsigned char*  curr;   //  4   //  ldrb
@   unsigned char*  next;   //  8   //  ldrb
@   unsigned char*  output; //  12  //  ldrb
@   unsigned short* screen; //  16  //  ldrh
@ } tconway_line;


@ static void SolveLine (tconway_line* line)
@ r0 line

.global SolveLine

SolveLine:

stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}

ldr r1, [r0, #16]   @ Me "traigo" screen
ldr r2, [r0, #12]   @ Me "traigo" output
ldr r3, [r0, #4]    @ Me "traigo" curr
mov r4, #0
strh r4, [r1]       @ line->screen[0] = 0;
ldrb r4, [r3]       @ Me "traigo" line->curr[0];
ldrb r4, [r2]       @ line->output[0] = line->curr[0];  



ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
bx      lr
