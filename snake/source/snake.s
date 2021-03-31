
@static int UpdateSnake (int keypad, Snake* snake, unsigned short* screen)
@r0 ->  int keypad
@r1 ->  Snake* snake
@r2 ->  unsigned short* screen

.global UpdateSnake
UpdateSnake:

  stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}

  mov r12, #240

  ldr r3, [r1]            @ Slab* slabs = snake->slabs

  ldrh r4, [r1, #6]       @ int head_slab = snake->head_slab;

  add r14, r3, r4, lsl #3     @ offset, head * 8 para obtener su posicion en slabs
  ldr r6, [r14]            @ int new_x = slabs[head_slab].x
  ldr r7, [r14, #4]       @ int new_y = slabs[head_slab].y

  add r4, r4, #1          @ head_slab++
  ldrh r8, [r1, #4]        @ Me "traigo" snake->len
  cmp r4, r8              @ Comparo head_slab con snake->len
  movge r4, #0            @ si r4(head_slab) es mayor que r7(snake->len) lo igualo a 0
  strh r4, [r1, #6]       @ snake->head_slab = head_slab;

  ldr r8, [r1, #8]        @ int speed_x = snake->speed_x;
  ldr r9, [r1, #12]       @ int speed_y = snake->speed_y; 


  add r6, r6, r8          @ new_x += speed_x;
  add r7, r7, r9          @ new_y += speed_y;

  mul r8, r7, r12          @ new_y * 240
  add r8, r8, r6          @ new_x + new_y * 240
  add r8, r2, r8, lsl #1  @ screen + (new_x + new_y * 240);

  

  mov r9, #0x7f00
  orr r9, r9, #0x00ff
  strh r9, [r8]

  add r14, r3, r4, lsl #3
  str r6, [r14]
  str r7, [r14, #4]

  mov r0, #0
  




  ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
  bx      lr
