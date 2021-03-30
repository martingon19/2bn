@ void SeedParticles (const Source* sources, Particle* particles, int nparticles, unsigned short* screen)
@ r0 - const Source* sources
@ r1 - Particle* particles
@ r2 - int nparticles
@ r3 - unsigned short* screen

.global SeedParticles

SeedParticles:

  stmdb   sp!,{r4,r5,r6,r7,r8,r9}
    
  mov     r8,#8     @ int nsources = NUM_SOURCES

seed_loop:

  ldrb    r4,[r1,#2]  @alive
  cmp     r4,#0
  bne     not_dead

  ldrh    r4,[r0]    @ int x = sources->x;  
  ldrh    r5,[r0,#2]    @ int y = soources->y;

  mov   r9,#240
  mul   r9,r5,r9
  add   r9,r9,r4
  add   r9,r9,r9
  add   r9,r3,r9
  ldrh  r9,[r9]
  cmp   r9,#0
  bne   source_filled
        
  strb    r4,[r1]     @ particles->x = x;
  strb    r5,[r1,#1]     @ particles->y = y;
  mov     r7,#1
  strb    r7,[r1,#2]     @ &particles->alive = 1;

 source_filled:

  add     r0,r0,#4    @ sources++
  sub     r8,r8,#1    @ nsources-- 

not_dead:

  add     r1,r1,#4        @ particles++
  sub     r2,r2,#1        @ nparticles--
    
  cmp     r2,#0           
  beq     seed_loop_done  @ if (nparticles == 0 ) break;

  cmp     r8,#0
  bne     seed_loop       @ if (nparticles != 0 ) repeat;
    
seed_loop_done:
  ldmia   sp!,{r4,r5,r6,r7,r8,r9}
  bx  lr



@void UpdateParticles (Particle* particles, int nparticles, unsigned short* screen);
@ r0 - Particle* particles
@ r1 - int nparticles
@ r2 - unsigned short* screen

.global UpdateParticles

UpdateParticles:

    stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10}

do_while:

    ldrb r3, [r0, #2]     @ desplazo para coger el alive
    cmp r3, #0            @ comparo
    beq particles_dead    @ if (particles->alive)

    ldrb r3, [r0]         @ int x = particles->x;
    ldrb r4, [r0, #1]     @ int y = particles->y;

    mov r5, #240          @ SCREEN_W = 240
    mul r5, r4, r5        @ SCREEN_W * y
    add r5, r5, r3        @ x + SCREEN_W * y
    @add r5, r5, r5        @ Lo multiplicamos por dos dado que los unsigned short son dos bytes
    add r5, r2, r5, lsl #1        @ screen mas offset current = &screen [x + SCREEN_W * y];

    add r6, r5, #480      @ down = current + SCREEN_W * size of short;
    mov r7, #66           @ int new_x = 66;

    mov r9, r6 
    ldrh r8, [r9]         @ cargo down[0]
    cmp r8, #0            @ down[0] == BLACK
    moveq r7, #0          @ new_x = 0
    beq positions_checked
    
    ldrh r8, [r9, #-2]    @ down[-1]
    cmp r8,#0             @ if (down[-1] == BLACK)
    moveq r7, #-1         @ new_x = -1;
    beq positions_checked

    ldrh r8, [r9, #2]       @ down[1]
    cmp r8,#0             @ if (down[1] == BLACK)
    moveq r7, #1
  
positions_checked:
    cmp r7, #66
    moveq r3, #0
    streqb r3, [r0, #2]   @ particles->alive = 0;
    beq particles_dead    @ if (new_x != 66) {
    mov r10, #0           @ cargo black
    strh r10, [r5]        @*current = BLACK;
    mov r10, #0x7F00      @ WHITE
    add r10, r10, #0xFF   @ WHITE
    add r9, r7, r7        @ el doble por el sizeof
    strh r10, [r6, r9]    @ down[new_x] = WHITE;
    add r3, r3, r7 
    strb r3, [r0]         @ particles->x = x + new_x;
    add r4, r4, #1
    strb r4, [r0, #1]     @ particles->y = y + 1;
    b particles_dead    
    

particles_dead:
      
    add r0, r0, #4        @ particles++;
    subs r1, r1, #1       @ nparticles--;
    
    bne do_while
  
    ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10}
    bx      lr


