@void Voronoid (unsigned short* screen, const TPoint* points, int npoints, const unsigned short* palette)

.global Voronoid
Voronoid:

    stmdb   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}

    

    ldmia   sp!,{r4,r5,r6,r7,r8,r9,r10,r11,r12,r14}
    bx      lr
