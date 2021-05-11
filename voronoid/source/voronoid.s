@void Voronoid (unsigned short* screen, const TPoint* points, int npoints, const unsigned short* palette)

@ r0 screen
@ r1 points
@ r2 npoints
@ r3 palette

.extern Closest

.global Voronoid
Voronoid:

    stmdb   sp!,{r4,r5,r6,r7,r8,r9}
    
  mov r4, r0          @ screen
  mov r5, r1          @ points
  mov r6, r2          @ npoints
  mov r7, r3          @ palette
  
  mov r8, #0          @ Y
first_loop_y:

  mov r9, #0          @ X  
second_loop_x:
  
  mov r0, r5          @ Le pongo los valores que le voy a pasar a closest
  mov r1, r6
  mov r2, r9
  mov r3, r8 
  
  bl Closest          @ Llamo a closest
  
  mov r0, r0, lsl #1    @ Lo desplazo dos
  ldrh r0, [r7, r0]
  strh r0, [r4]         @ *screen = palette [c];
  
  add r4, r4, #2        @ Screen++
  
  add r9, r9, #1        @ x++
  cmp r9, #240          @ Si no ha llegado a 240 salto
  blt second_loop_x
  
  add r8, r8, #1        @ y++
  cmp r8, #160          @ Si no llega a 160 salto
  blt first_loop_y
  
  

    

    ldmia   sp!,{r4,r5,r6,r7,r8,r9}
    bx      lr
