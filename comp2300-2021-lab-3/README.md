# comp2300-2021-lab-3

<https://cs.anu.edu.au/courses/comp2300/labs/03-maths-to-machine-code/>

## Q&A

1. What's the biggest number a register can store?

   1. (for unsigned integer number, 2^32-1; for signed integer number, 2^31-1; what about floating point number?)

2. In xPSR(program status register), what is a "Thumb State(T)"? (N, Z, C, V, Q, GE, Interrupt Number, ICI/IT?)

   - Extension: check `MSR` and `MRS` instructions in the manual to use xPSR registers.

   Take 4-bit system as an example. A greate reference here: [stackoverflow](https://d.pr/r0E3Sm)

   ![CPU Clock](https://i.stack.imgur.com/6yNJY.gif)
   ![CPU Clock-anit](https://i.stack.imgur.com/j0lcP.gif)

   1. Negative (N) set when: e.g. `movs r0, #0b1100`
   2. Zero (Z) set when:
   3. Carry/Borrow set when:
   4. Overflow set when:
   5. Saturaration set when:

3. How can the machine tell if a number in a register is signed or unsigned?

4. Why does intruction `movs r0, #0x1` set the carry flag to 1?
