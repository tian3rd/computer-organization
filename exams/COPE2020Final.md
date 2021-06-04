# Attempted answers (including code snippets)

> As well as some questions that may need special attention.

1. conditional codes

   1. A, B, C, D
   2. Hint: look it up in the [cheatsheet](../arm-assembly-cheat-sheet.pdf) `conditional codes` section

2. digital logic circuit question

   1. B, C, D

3. interrupts

   1. A, B, C, D, F, G
   2. Hints:
      1. The previous value of `r0` has been saved on the stack by the NVIC: correct.
      2. The previous value of `r6` has been saved on the stack by the NVIC: if there's a `r6` in the first place
      3. After returning from an interrupt handler, your program will have to restore `r0-r3`: scratch registers are popped out from the stack. (refer to p290)
      4.

```assembly

.syntax unified
.global main

.type main, %function
main:
  nop
  @ Q11 fibonotchi series
  mov r0, 5
  bl series_n
loop:
  nop
  b loop
@ args: r0 as n
@ returns: r3 as n_th number in fib
.type series_n, %function
series_n:
  push {r4-r5, lr}
  cmp r0, 1
  ble just_return_2or3
  bgt recursive_calls
recursive_calls:
  sub r4, r0, 1
  sub r5, r0, 2
  mov r0, r4
  bl series_n
  mov r4, r3
  mov r0, r5
  bl series_n
  add r3, r3, r4
  b end_recursive_calls
just_return_2or3:
  add r3, r0, 2
  b end_recursive_calls
end_recursive_calls:
  pop {r4-r5, lr}
  bx lr
.size series_n, .-series_n

  b main
.size main, .-main

@ main:
@   nop
@   @ Q9. even or not in memory
@ even_or_not:
@   @ address for x is 0x20000000
@   ldr r3, =address4x
@   ldr r0, [r3]
@   bl check_even
@   cmp r1, 0
@   beq double
@   bne plus_2
@ double:
@   lsl r0, #1
@   str r0, [r3]
@   b loop
@ plus_2:
@   add r0, 2
@   str r0, [r3]
@   b loop
@ loop:
@   nop
@   b loop

@ @ args: r0 as the number to check
@ @ returns: r1 as the indicator (r1=0 means r0 is even, r1=1 means r0 is odd)
@ check_even:
@   push {lr}
@   mov r2, r0
@   asr r2, #1
@   lsl r2, #1
@   cmp r2, r0
@   beq even
@   bne odd
@ even:
@   mov r1, 0
@   b end
@ odd:
@   mov r1, 1
@   b end
@ end:
@   pop {lr}
@   bx lr

@   b main
@ .size main, .-main

@ .data
@ address4x:
@   .word 8

@ main:
@   nop
@   @ Q10. iterate over array
@   bl calculate_avg_in_array
@ loop:
@   nop
@   b loop

@ calculate_avg_in_array:
@   push {lr}
@   ldr r0, =discovector
@   @ r1 as counter
@   mov r1, 1
@   @ r2 returns the final avg (first sum, then divided by 32)
@   mov r2, 0
@ avg:
@ add_next:
@   ldr r3, [r0], 4
@   add r2, r2, r3
@   add r1, 1
@   cmp r1, 32
@   ble add_next
@   bgt calc_avg
@ calc_avg:
@   mov r4, 32
@   sdiv r2, r2, r4
@   b return_avg
@ return_avg:
@   pop {lr}
@   bx lr

@   b main
@ .size main, .-main

@ .data
@ discovector:
@   @ here are 32 32-bit signed int
@   .word 0
@   .word 1
@   .word 2
@   .word 3
@   .word 4
@   .word 5
@   .word 6
@   .word 7
@   .word 8
@   .word 9
@   .word 10
@   .word 11
@   .word 12
@   .word 13
@   .word 14
@   .word 15
@   .word 16
@   .word 17
@   .word 18
@   .word 19
@   .word 20
@   .word 21
@   .word 22
@   .word 23
@   .word 24
@   .word 25
@   .word 26
@   .word 27
@   .word 28
@   .word 29
@   .word 30
@   .word 31

```
