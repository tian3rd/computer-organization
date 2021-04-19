# comp2300-2021-lab-6

<https://cs.anu.edu.au/courses/comp2300/labs/06-blinky/>

## Q&A

1. What does `ldr r0, =label` do? What's the value of `label` here?

- It loads r0 with the value of `label` which contains the address of the instruction right after it in the program.

2. > To configure pin 2 for output mode to power the LED, you need to ensure the mode bits for pin 2 (MODE2 in the diagram) are 01 for output mode (i.e. clear bit 5, set bit 4).

   1. How to turn it off?
   2. What are `10` or `11` modes?

3. How to effectively delay the blink?

   1. "The CPU clock speed is 4 MHz for labs. A simple delay loop might take 2-5 cycles, depending on what you do (generally an arithmetic operation, a comparison, and a conditional branch). So 50k loops is approximately 200k CPU cycles, which is very small compared to the 4 million cycles per second the CPU is running at. Maybe try a larger value."
   2. Set the loops as `0x10000` can have a pretty obvious blinks.

4. What's the difference when using immediate value encoding between _Thumb 2_ instruction set used in our disco board and the ARM set?
5. _Thumb 2_ rules found online [here](http://class.ece.iastate.edu/cpre288/resources/docs/Thumb-2SupplementReferenceManual.pdf):
   1. Shifted 8-bit values
      If the constant lies in the range 0-255, then imm12 is the unmodified constant.
      Otherwise, the 32-bit constant is rotated left until the most significant bit is bit[7]. The size of the left
      rotation is encoded in bits[11:7], overwriting bit[7]. imm12 is bits[11:0] of the result.
      For example, the constant 0x01100000 has its most significant bit at bit position 24. To rotate this bit to bit[7], a left rotation by 15 bits is required. The result of the rotation is 0b10001000. The 12-bit encoding of the constant consists of the 5-bit encoding of the rotation amount 15 followed by the bottom 7 bits of this result, and so is 0b011110001000.
      Constants of the form 0x00XY00XY
      Bits[11:8] of imm12 are set to 0b0001, and bits[7:0] are set to 0xXY. This form is UNPREDICT ABLE if bits[7:0] == 0x00.
      Constants of the form 0xXY00XY00
      Bits[11:8] of imm12 are set to 0b0010, and bits[7:0] are set to 0xXY. This form is UNPREDICT ABLE if bits[7:0] == 0x00.
      Constants of the form 0xXYXYXYXY
      Bits[11:8] of imm12 are set to 0b0011, and bits[7:0] are set to 0xXY. This form is UNPREDICTABLE ifbits[7:0] == 0x00.
   2. ARM rules see link attached in lab2.
6. How to branch and link under certain condition, e.g., if `r0>0` then `bl` to `label1`, else just carry on?

   1. Use `IT` block:
   2. ```assembly
        cmp r0, 0
        IT ge
        blge label1
        @ else stuff here, next todos
      label1:
      @ when r0>0, do stuff here, the position of label1 doesn't matter
      bx lr
      ```
   3. Alternatively, just use a label:
   4. ```assembly
      label1:
        @ when r0>0, do stuff here.
        b next_step

        @ ...other stuff in between

        cmp r0, 0
        bge label1
      next_step:  @ if label1 is before the cmp, you have to set a label here
        @ next todos
      ```

7. `fp` is a frame pointer pointing the start of the instructions, fixed; while `sp` stack pointer is changing all the time, e.g. allocating new varibles by decrementing (for negatively growing stack).

## Useful link

[Compiler Explorer](https://godbolt.org) to translate higher level code to assembly code.
