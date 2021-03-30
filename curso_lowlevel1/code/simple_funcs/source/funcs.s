


@ int Biggest (int a, int b); 
@ r0 -> a
@ r1 ->b
@ return in r0

  .globl Biggest


Biggest:
  cmp r1, r0
  movgt r0, r1
  bx lr


@ int Smallest (int a, int b); 
@ r0 -> a
@ r1 ->b
@ return in r0

  .globl Smallest

Smallest: 
  cmp r1, r0
  movge r0, r1 
  bx lr
  

@ int TotalOfArray (int *array, int len)
@ r0 -> array
@ r1 -> len

  .globl TotalOfArray

TotalOfArray:
    ldr    r2, [r0]    @ int res = *array;
    add r0,r0, #4    @ array = array + 1;
    sub r1, r1, #1    @ len--;

total_while:
    cmp r1, #0
    beq total_done

    ldr    r3, [r0]    @ int v = *array;
    add r0,r0, #4    @ array = array + 1;
    add r2, r2, r3    @ res += v;

    subs  r1, r1, #1    @ len--;
    b total_while

total_done:

    mov r0, r2    @ return res;
    bx lr


