.syntax unified
.global main

.type main, %function
main:
  @ ex0. bit shifting practice
@   @ ex0 starts here
@   ldr r0, =0xcafe0000
@   ldr r1, =0xffff
@   @ load 0xcafeffff into r3
@   eor r3, r0, r1
@   @ load 0xcafe into r4
@   lsr r4, r0, #16
@   @ load 0xcaff0000 into r5
@   eor r5, r0, #0x10000
@   @ load 0xc0fe0000 into r6
@   eor r6, r0, #0xa000000
@ loop:
@   nop
@   b loop
@   @ ex0 ends here

  @ ex1. using labels, ldr, and str
@   @ ex1 starts here
@   @ get a hang of ldr
@   ldr r0, =#0xfff
@   mov r1, #0xfff
@   @ calculate size of 'mov r3, 1'
@ instruction_start:
@   movs r3, 1
@ instruction_end:
@   ldr r0, =instruction_end
@   ldr r1, =instruction_start
@   @ calculate the byte size
@   sub r2, r0, r1
@   @ every byte is 8 bits
@   lsr r2, #3
@ loop: 
@   nop
@   b loop
@   @ ex1 ends here

@   @ ex2. the load-twiddle-store pattern
@   @ ex2 starts here
@   @ load r1 with an offset to get to the 4th of "2300"
@   ldr r1, =storage + 12
@   mov r0, #1
@   @ store new value to address
@   str r0, [r1]

@   nop
@   b main

@ .data
@ storage:
@   .word 2, 3, 0, 0
@   @ ex2 ends here

  @ ex3. hello, LED!
  @ @ ex3 starts here
  @ @ 1. turn on GPIO PortB Clock
  @ @ load base address of RCC/ResetClockControl
  @ ldr r1, =#0x40021000
  @ @ offset to get to AHB2ENR
  @ ldr r2, [r1, #0x4c]
  @ @ toggle second bit for GPIOPB
  @ eor r2, #0x2
  @ @ store back the toggled value
  @ str r2, [r1, #0x4c]

  @ @ 2. set GPIO PB to output mode
  @ @ load base address of GPIOB_MODER
  @ ldr r1, =#0x48000400
  @ @ offset is #0x0, so we can skip offset;
  @ ldr r2, [r1] 
  @ @ B is Mode2, so set the 4th and 5th: clear bit 5, set bit 4
  @ mov r3, #0xffdf 
  @ and r2, r3 @ clear bit 5
  @ orr r2, #0x10 @ set bit 4
  @ @ store back
  @ str r2, [r1]

  @ @ 3. send on signal to GPIOB_ODR (OutputDataRegister) pin 2
  @ ldr r1, =#0x48000400
  @ ldr r2, [r1, #0x14]
  @ orr r2, #0x4 @ set bit 2 for pin 2
  @ str r2, [r1, #0x14]
  @ nop 
  @ b main
  @ @ ex3 ends here

  @ ex4. functions review
@   @ ex4 starts here
@   @ 1. naive way (commented out)
@   @ @ enable the clock for E:4th index
@   @ bl set_bit_0x40021000_0x4c_4
@   @ @ set the output mode
@   @ bl clear_bit_0x48001000_0x0_17
@   @ bl set_bit_0x48001000_0x0_16
@   @ @ send signal
@   @ bl set_bit_0x48001000_0x14_8

@   @ 2. function view for red light
@   ldr r0, =#0x40021000
@   mov r1, #0x4c
@   mov r2, #1
@   bl set_bit
@   ldr r0, =#0x48000400
@   mov r1, #0x0
@   mov r2, #4
@   bl set_bit
@   mov r2, #5
@   bl clear_bit
@   mov r1, #0x14
@   mov r2, #2
@   bl set_bit

@   @ turn it off
@   bl clear_bit
@   nop 
@   b main

@ set_bit_0x40021000_0x4c_4:
@   str lr, [sp, #-4]!

@   ldr r1, =#0x40021000
@   ldr r2, [r1, #0x4c]
@   orr r2, #0x10 @ set bit 4 for port E
@   str r2, [r1, #0x4c]

@   ldr lr, [sp], #4
@   bx lr
@ clear_bit_0x48001000_0x0_17:
@   str lr, [sp, #-4]!

@   ldr r1, =#0x48001000
@   ldr r2, [r1, #0x0]
@   mov r3, #0xfffdffff
@   and r2, r3
@   str r2, [r1, #0x0]

@   ldr lr, [sp], #4
@   bx lr

@ set_bit_0x48001000_0x0_16:
@   str lr, [sp, #-4]!

@   ldr r1, =#0x48001000
@   ldr r2, [r1, #0x0]
@   orr r2, #0x10000
@   str r2, [r1, #0x0]

@   ldr lr, [sp], #4
@   bx lr 

@ set_bit_0x48001000_0x14_8:
@   str lr, [sp, #-4]!

@   ldr r1, =#0x48001000
@   ldr r2, [r1, #0x14]
@   orr r2, #0x100
@   str r2, [r1, #0x14]

@   ldr lr, [sp], #4
@   bx lr

@ @ args: r0 base addr; r1 offset(hex); r2 index (decimal)
@ @ result: set [r0+r1]'s r2th index value to be 1
@ set_bit:
@   @ if it's leaf function doesn't need to remember lr actually
@   str lr, [sp, #-4]! 
@   ldr r4, [r0, r1]
@   mov r3, #1
@   lsl r3, r3, r2
@   orr r4, r3
@   str r4, [r0, r1]
@   ldr lr, [sp], #4
@   bx lr

@ clear_bit:
@   str lr, [sp, #-4]!
@   ldr r3, [r0, r1]
@   mov r4, #1
@   lsl r4, r4, r2
@   bic r3, r3, r4
@   str r3, [r0, r1]
@   ldr lr, [sp], #4
@   bx lr

@   @ ex4 ends here

  @ ex6. FizzBlink
@   @ ex6 starts here 
@   mov r0, #0
@   mov r1, #3
@   mov r2, #5
@   mov r3, #15

@ fizzblink:
@   str lr, [sp, #-4]!
@ fizzblink_loop:
@   add r0, #1
@   sub r1, #1
@   sub r2, #1
@   sub r3, #1
@ checkfizz_redgreen:
@   cmps r3, #0
@   beq redgreen_blink
@ checkfizzred:
@   cmps r1, #0
@   beq red_blink
@ checkfizzgreen:
@   cmps r2, #0
@   beq green_blink
@ check_outofrange:
@   cmps r0, #100
@   bge end_fizzblink
@   blt fizzblink_loop

@ end_fizzblink:
@   nop 
@   b end_fizzblink

@ redgreen_blink:
@   bl red_on
@   bl green_on
@   bl delay
@   bl red_off
@   bl green_off
@   mov r3, #15
@   b checkfizzred

@ red_blink: 
@   @ str lr, [sp, #-4]!
@   bl red_on
@   bl delay
@   bl red_off
@   mov r1, #3
@   @ ldr lr, [sp], #4
@   b checkfizzgreen

@ red_on:
@   stmdb sp!, {r0-r4, lr}
@   ldr r0, =#0x40021000
@   mov r1, #0x4c
@   mov r2, #1
@   bl set_bit
@   ldr r0, =#0x48000400
@   mov r1, #0x0
@   mov r2, #4
@   bl set_bit
@   mov r2, #5
@   bl clear_bit
@   mov r1, #0x14
@   mov r2, #2
@   bl set_bit
@   ldmia sp!, {r0-r4, lr}
@   bx lr

@ red_off:
@   stmdb sp!, {r0-r4, lr}
@   @ simplified to just clear_bit if r0, r1, r2 aren't changed in delay or restored
@   ldr r0, =#0x48000400
@   mov r1, #0x14
@   mov r2, #2
@   bl clear_bit
@   ldmia sp!, {r0-r4, lr}
@   bx lr

@ green_blink:
@   @ str lr, [sp, #-4]!
@   bl green_on
@   bl delay
@   bl green_off
@   mov r2, #5
@   @ ldr lr, [sp], #4
@   b check_outofrange

@ green_on:
@   stmdb sp!, {r0-r4, lr}
@   ldr r0, =#0x40021000
@   mov r1, #0x4c
@   mov r2, #4
@   bl set_bit
@   ldr r0, =#0x48001000
@   mov r1, #0x0
@   mov r2, #16
@   bl set_bit
@   mov r2, #17
@   bl clear_bit
@   mov r1, #0x14
@   mov r2, #8
@   bl set_bit
@   ldmia sp!, {r0-r4, lr}
@   bx lr

@ green_off:
@   stmdb sp!, {r0-r4, lr}
@   ldr r0, =#0x48001000
@   mov r1, #0x14
@   mov r2, #8
@   bl clear_bit
@   ldmia sp!, {r0-r4, lr}
@   bx lr 

@ delay: 
@   stmdb sp!, {r0, r1, lr}
@   ldr r0, =#0x100000
@   bl delay_loop
@   ldmia sp!, {r0, r1, lr}
@   bx lr

@ delay_loop:
@   str lr, [sp, #-4]!
@ continue_loop:
@   @ how to delay?
@   sub r0, #1
@   cmps r0, #0
@   bgt continue_loop
@   ble end_delay
@ end_delay:
@   ldr lr, [sp], #4
@   bx lr

@ set_bit:
@   @ if it's leaf function doesn't need to remember lr actually
@   str lr, [sp, #-4]! 
@   ldr r4, [r0, r1]
@   mov r3, #1
@   lsl r3, r3, r2
@   orr r4, r3
@   str r4, [r0, r1]
@   ldr lr, [sp], #4
@   bx lr

@ clear_bit:
@   str lr, [sp, #-4]!
@   ldr r3, [r0, r1]
@   mov r4, #1
@   lsl r4, r4, r2
@   bic r3, r3, r4
@   str r3, [r0, r1]
@   ldr lr, [sp], #4
@   bx lr

@ loop:
@   nop
@   b loop
@   @ ex6 ends here

  @ extra: make it breathe?
  @ turn the red on for longer time, turn it off for a shorter time?


mov r3, #2      @ r3
mov r1, #1000   @ r3:r1 to 100% of brightness
mov r5, #3      @ every brightness duration loop cycles
mov r7, #2      @ every step of r3 change (r3 = r3 + r7, r7 can < 0)

start_here:

@ args: r3:(r1-r3)=on:off to adjust brightness
loop:
  mov r0, r3
  bl red_on
  bl delay
  mov r0, r3
  sub r0, r1, r0
  bl red_off
  bl delay
  mov r0, r3
  sub r5, #1
  cmp r5, 0
  bgt loop
  ble change_brightness

change_brightness:
  add r3, r3, r7
  cmp r3, r1
  it eq
  bleq reset_r7
  cmp r3, #0
  it eq
  bleq reset_r7
  mov r5, #2
  
  b start_here

reset_r7:
  @ if r3 reaches maximum r1 value, decrease r3 to 0;
  @ if r3 reaches minimum 0, increase to r1
  rsb r7, r7, #0
  bx lr

@ args: r0 delay operations ==> delay time
delay:
  sub r0, #1
  cmps r0, #0
  bgt delay
  ble end_delay
end_delay:
  bx lr 

red_on:
  stmdb sp!, {r0-r2, lr}
  ldr r0, =#0x40021000
  mov r1, #0x4c
  mov r2, #1
  bl set_bit
  ldr r0, =#0x48000400
  mov r1, #0x0
  mov r2, #4
  bl set_bit
  mov r2, #5
  bl clear_bit
  mov r1, #0x14
  mov r2, #2
  bl set_bit
  ldmia sp!, {r0-r2, lr}
  bx lr

red_off:
  stmdb sp!, {r0-r2, lr}
  @ simplified to just clear_bit if r0, r1, r2 aren't changed in delay or restored
  ldr r0, =#0x48000400
  mov r1, #0x14
  mov r2, #2
  bl clear_bit
  ldmia sp!, {r0-r2, lr}
  bx lr

set_bit:
  @ if it's leaf function doesn't need to remember lr actually
  stmdb sp!, {r0-r4, lr}
  ldr r4, [r0, r1]
  mov r3, #1
  lsl r3, r3, r2
  orr r4, r3
  str r4, [r0, r1]
  ldmia sp!, {r0-r4, lr}
  bx lr

clear_bit:
  stmdb sp!, {r0-r4, lr}
  ldr r3, [r0, r1]
  mov r4, #1
  lsl r4, r4, r2
  bic r3, r3, r4
  str r3, [r0, r1]
  ldmia sp!, {r0-r4, lr}
  bx lr