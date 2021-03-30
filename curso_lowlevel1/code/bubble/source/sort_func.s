
.globl SortArray

@ static void SortArray (signed char *array, int len)
@ signed char *array - r0
@ int len - r1

SortArray:
  stmdb   sp!,{r4,r5,r6,r7,r8}     @ prolog

  subs r1, r1, #1
  mov   r7,r1  @ full_length = len
while_loop:
  @cmp   r1,#1     
  ble   sort_done   @ while (len < 1)

  mov   r2,#1     @ ordered = 1    
  mov   r3,r7     @ i = full_length

for_loop:
  @cmp   r3,#0
  ble   for_done

  ldr r4,[r0,r3, lsl #2]    @ t0 = array[i]
  sub   r6,r3,#1      @ i - 1
  ldr r5,[r0,r6, lsl #2]    @ t1 = array[i-1]
  
  strgt  r5,[r0,r3, lsl #2]    @ array[i] = t1
  strgt  r4,[r0,r6, lsl #2]    @ array[i+1] = t0
  movgt   r2,#0         @ ordered = 0

  subs   r3,r3,#1   @ i--
  b     for_loop



for_done:
  cmp   r2,#0
  bne   sort_done   @ if (ordered) return
  subs   r1,r1,#1    @ len--
  b     while_loop

sort_done:
  ldmia   sp!,{r4,r5,r6,r7,r8}    @ epilog
  bx      lr

