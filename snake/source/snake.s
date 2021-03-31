
@static int UpdateSnake (int keypad, Snake* snake, unsigned short* screen)
@r0 ->  int keypad
@r1 ->  Snake* snake
@r2 ->  unsigned short* screen

.global UpdateSnake
UpdateSnake:

  stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}

  mov r12, #240
  ldrh r8, [r1, #4]         @ Me "traigo" snake->len
  ldr r3, [r1]              @ Slab* slabs = snake->slabs

  ldrh r4, [r1, #6]         @ int head_slab = snake->head_slab;
    
  add r6, r4, #1            @ int tail = snake->head_slab + 1;
  cmp r6, r8                @ if (tail >= snake->len)
  movge r6, #0

  add r14, r3, r6, lsl #3   @ offset, tail * 8 para obtener su posicion en slabs
  ldr r6, [r14]             @ slabs[tail].x
  ldr r7, [r14, #4]         @ slabs[tail].y
  mul r14, r7, r12          @ slabs[tail].y * 240
  add r14, r14, r6          @ slabs[tail].x + slabs[tail].y * 240
  add r14, r2, r14, lsl #1  @ Multiplico por dos y sumo el screen
  mov r6, #0                @ 0 para subirlo a la posicion
  strh r6, [r14]            @ Lo subo

  add r14, r3, r4, lsl #3   @ offset, head * 8 para obtener su posicion en slabs
  ldr r6, [r14]             @ int new_x = slabs[head_slab].x
  ldr r7, [r14, #4]         @ int new_y = slabs[head_slab].y

  add r4, r4, #1            @ head_slab++

  cmp r4, r8                @ Comparo head_slab con snake->len
  movge r4, #0              @ si r4(head_slab) es mayor que r7(snake->len) lo igualo a 0
  strh r4, [r1, #6]         @ snake->head_slab = head_slab;

  ldr r8, [r1, #8]          @ int speed_x = snake->speed_x;
  ldr r9, [r1, #12]         @ int speed_y = snake->speed_y; 

  cmp r0, #0
  bne keypad
no_keypad:

  add r6, r6, r8            @ new_x += speed_x;
  add r7, r7, r9            @ new_y += speed_y;

  mul r8, r7, r12           @ new_y * 240
  add r8, r8, r6            @ new_x + new_y * 240
  add r8, r2, r8, lsl #1    @ screen + (new_x + new_y * 240);

  
  ldrh r9, [r8]
  cmp r9, #0                @ if (*head_pix == 0)
  beq head_pos_black
  

  mov r0, #1
  

end_update:

  ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
  bx      lr

head_pos_black:

  mov r9, #0x7f00           
  orr r9, r9, #0x00ff       @ *head_pix = 0xffff;
  strh r9, [r8]

  add r14, r3, r4, lsl #3   
  str r6, [r14]             @ slabs[head_slab].x = new_x;
  str r7, [r14, #4]         @ slabs[head_slab].y = new_y;
  
  mov r0, #0

  b end_update


keypad:

  mov r8, #0
  mov r9, #0

  ands r14, r0, #1
  movne r8, #1

  ands r14, r0, #2
  movne r8, #-1

  ands r14, r0, #4
  movne r9, #-1

  ands r14, r0, #8
  movne r9, #1
  
  str r8, [r1, #8]          @ int speed_x = snake->speed_x;
  str r9, [r1, #12]         @ int speed_y = snake->speed_y; 

  b no_keypad











  
