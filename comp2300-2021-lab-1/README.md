# comp2300-2021-lab-1

<https://cs.anu.edu.au/courses/comp2300/labs/01-intro/>

## Q&A

1. What's the meaning of the followings: `.syntax`, `.global`, `.type`, `%function`, `.size`?

   1. `.syntax` directive allows you to set the intruction set syntax. By setting `.syntax` to `unified`, the GNU assembler will be using a modern syntax for Arm THUMB instructions. (What does it mean?)
   2. `.global` directive specified the name which can be used anywhere in the program. (more to add later)
   3. `.type` directive allows you to tell the assembler what type a symbol is. Most of the time `%function` or `%object` will suffice.
   4. `.size` directive tells the assembler how much space the data that symbol points to is using, so that the linker(explain) can exclude the function if it's unused.
   5. REF: https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/useful-assembler-directives-and-macros-for-the-gnu-assembler

2. Only a few registers (i.e., r0 to r12, lr, sp, pc, xPSR) exist, so what if you run out of them all?
   1. Use RAM
   2. lr: link register
   3. sp:
   4. pc: program counter
   5. xPSR:
   6. sN: single floating point register
   7. dN: double floating point registers
3.

## About Discovery Board (Discoboard)

1. > The first time you flash a Discoboard you might see a Error: init mode failed (unable to connect to target), this is solved by following the instructions in the “COMP2300: first time flash” command ([link to troubleshooting here](https://cs.anu.edu.au/courses/comp2300/resources/software-setup/#flash-failure)).

2. The Discovery kit STM32L476 is a ultra-low-power 32-bit MCU with features as followings, try to figure out the meanings of each parameter:
   1. 80 MHz/100 DMIPS
   2. 1 Mbyte of Flash memory
   3. 128 Kbytes of SRAM
   4. 9-axis motion sensors and MEMS microphone
   5. 128-Mbit Quad-SPI Flash
   6. Audio DAC with 3.5 mm connector
   7. USB OTG
   8. Embedded ST-LINK/V2-1 debugger/programmer
   9. Arm&#174; Mbed Enabled&#8482;

## Troubleshooting

1. When building, prompted with error "command not found"?
   "The extension does not activate unless you have a lab repo open as your root workspace folder"
