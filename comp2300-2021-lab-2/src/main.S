.syntax unified
.global main

.type main, %function
main:
  @ TODO 
  @ ex1. 2+2 task
  @ @ comment starts here for ex1
  @ mov r0, 2
  @ add r1, r0, #2
  @ @ comment ends here for ex1

  @ TODO
  @ ex2. reverse engineering
  @ @ comment starts here for ex2
  @ .hword 0xdead
  @ @ refer to manual A7.7.75 MOV (immediate)
  @ movs r1, #3
  @ .hword 0xbeef
  @ @ comment ends here for ex2
  
  @ TODO
  @ ex3. hand-crafted, artisinal organic instructions
  @ @ comment starts here for ex3
  @ @ refer to A7.7.75 for MOVS; 
  @ @ tip: when writing the .hword, the order is not changed, only the view in memory changes according to little endian
  @ .hword 0x2103
  @ @ refer to A7.7.171 for SUBS
  @ .hword 0x3901
  @ @ comment ends here for ex3

  @ TODO
  @ ex4. bit vectors
  @ comment starts here for ex4
cope:
  .ascii "COPE"
  @ because r1 is a 32-bit register, so after loading, there're 4 bytes in r1
  @ view disassembly for the following (it is transformed into ldr.w	r1, [pc, #-8])
  ldr r1, cope
  @ change 'C' to 'H' by adding 5
  add r2, r1, #5
  @ if a is 0 or 1, then a xor 0 == a; a xor 1 == not a
  eor r3, r2, #0x16000000
loop:
  @ just add some instructions here for better observations of registers
  movs r0, #1
  adds r0, #2
  @ comment ends here for ex4
  nop
  b loop
  nop
  b main

@ the .size is essential for the disassembler (vscode: view disassembly) to work correctly, 
@ as it tells the assembler the size of the main func.
.size main, .-main