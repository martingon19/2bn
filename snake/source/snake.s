
@static int UpdateSnake (int keypad, Snake* snake, unsigned short* screen)
@r0 ->  int keypad
@r1 ->  Snake* snake
@r2 ->  unsigned short* screen

.global UpdateSnake
UpdateSnake:

  stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}

  ldr r3, [r1]            @ Slab* slabs = snake->slabs
  ldrh r4, [r1, #6]       @ int head_slab = snake->head_slab;

  mov r14, r4, lsr #3     @ offset, head * 8 para obtener su posicion en slabs
  ldr r6, [r3], r14       @ int new_x = slabs[head_slab].x
  ldr r7, [r3], r14, #4   @ int new_y = slabs[head_slab].y

  add r4, r4, #1          @ head_slab++
  ldr r7, [r1], #4        @ Me "traigo" snake->len
  cmp r4, r7              @ Comparo head_slab con snake->len
  movge r4, #0            @ si r4(head_slab) es mayor que r7(snake->len) lo igualo a 0
  strh 


  



  ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
  bx      lr
