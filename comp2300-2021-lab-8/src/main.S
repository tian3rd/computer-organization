.syntax unified
.global main

.global dot_length @ 0x20000
.set dot_length, 0x20000

.type main, %function
main:
  nop

  bl red_led_init
  bl green_led_init

@   @ ex1. a led utility library
@   @ ex1 starts here
@   @ init red and green leds

@ sos:
@   bl blink_s
@   bl blink_letter
@   bl blink_o
@   bl blink_letter
@   bl blink_space
@   b sos

@ blink_s:
@   push {r0, r1, lr}
@   mov r1, #3
@ start_dot:
@   bl blink_dot
@   sub r1, #1
@   cmp r1, #0
@   bne start_dot
@   pop {r0, r1, lr}
@   bx lr

@ blink_o:
@   push {r0, r1, lr}
@   mov r1, #3
@ start_dash:
@   bl blink_dash
@   sub r1, #1
@   cmp r1, #0
@   bne start_dash
@   pop {r0, r1, lr}
@   bx lr 

@ blink_dot:
@   @ bl green_led_toggle @ is it necessary to toggle?
@   push {r0, r1, lr}
@   bl green_led_on
@   @ 0x20000 as a dot delay length for ~20000*(delay operations) cpu clock time
@   mov r0, dot_length
@   bl delay
  
@   bl green_led_off
@   mov r0, dot_length
@   bl delay
@   pop {r0, r1, lr}
@   bx lr

@ blink_dash:
@   push {r0, r1, lr}
@   bl green_led_on
@   @ a dash has longer time delay
@   mov r1, #3
@ dash_3dots:
@   mov r0, dot_length  
@   bl delay
@   sub r1, #1
@   cmp r1, 0
@   bne dash_3dots
@ pause:
@   bl green_led_off
@   mov r0, dot_length
@   bl delay
@   pop {r0, r1, lr}
@   bx lr

@ blink_space:
@   push {r0, r1, lr}
@   bl green_led_off
@   mov r1, #7
@ space_7dots:
@   mov r0, dot_length
@   bl delay
@   sub r1, #1
@   cmp r1, #0
@   bne space_7dots
@   pop {r0, r1, lr}
@   bx lr

@ blink_letter:
@   push {r0, r1, lr}
@   bl green_led_off
@   mov r1, #3
@ space_3dots:
@   mov r0, dot_length
@   bl delay
@   sub r1, #1
@   cmp r1, #0
@   bne space_3dots
@   pop {r0, r1, lr}
@   bx lr

@   @ ex1 ends here

@   @ ex2. a morse data structure
@   @ ex2 starts here
@   @ which letter
@ ex2_starts:
@   ldr r0, =b_letter
@   @ how many dots and dashes
@   ldr r1, [r0]
@ start_blink:
@   ldr r2, [r0, #4]!
@   cmp r2, 0
@   it eq
@     bleq blink_dot
@   it gt
@     blgt blink_dash
@   sub r1, #1
@   cmp r1, 0
@   bgt start_blink
@   @ delay for 3 dots length
@   bl blink_letter
@   @ loop
@   b ex2_starts
@   @ ex2 ends here

  @ ex3. ascii to morse conversion
  @ ex3 starts here
ex3_starts:
  @ long pause before it starts for easier obervation of led lights
  @ bl blink_space
  @ bl blink_space

  ldr r0, =input_string
  ldr r1, =morse_table
  @ r2: letter in the string; to calc offset from morse table
  ldr r2, [r0]
  @ get the ascii index of the last letter (since r2 loads 4 letters at a time)
  lsl r2, #24
  lsr r2, #24
blink_r2:
  @ case1: if r2 is a space
  cmp r2, #32
  it eq
    bleq blink_space
  cmp r2, #32
    beq next_letter

  @ case2: if r2 is a capital letter
  @ A: 65
  sub r2, r2, #65
  @ array of length 6
  mov r3, #6
  mul r2, r2, r3
  @ every word has 4 bytes, so have to lsl 2 to get the actual value
  @ r5: address of the destination letter
  add r5, r1, r2, lsl #2
  @ r3: the number of dots and dashes
  ldr r6, [r5]
blink_now:
  ldr r4, [r5, #4]!
  @ if r4 is 0: dot; 1: dash
  cmp r4, 0
  it eq
    bleq blink_dot
  cmp r4, 1
  it eq 
    bleq blink_dash
  sub r6, #1
  cmp r6, 0
  bgt blink_now
next_letter:
  @ first between letters, we have to pause for 3 dots' length
  bl blink_letter
  @ check if r2 is "0"(ascii 48) (end of the string), +1 instead of +4
  ldr r2, [r0, #1]!
  lsl r2, #24
  lsr r2, #24
  cmp r2, #48
  @ end of string, restart again (loop infinitely)
  beq ex3_starts
  @ if not, continue blinking next letter
  bne blink_r2
  
  @ ex3 ends here

@ the followings serve as the basic blink operations:
@ dot, dash, intervals between letters and words
blink_dot:
  @ bl green_led_toggle @ is it necessary to toggle?
  push {r0, r1, lr}
  bl green_led_on
  @ 0x20000 as a dot delay length for ~20000*(delay operations) cpu clock time
  mov r0, dot_length
  bl delay
  
  bl green_led_off
  mov r0, dot_length
  bl delay
  pop {r0, r1, lr}
  bx lr

blink_dash:
  push {r0, r1, lr}
  bl green_led_on
  @ a dash has longer time delay
  mov r1, #3
dash_3dots:
  mov r0, dot_length  
  bl delay
  sub r1, #1
  cmp r1, 0
  bne dash_3dots
pause:
  bl green_led_off
  mov r0, dot_length
  bl delay
  pop {r0, r1, lr}
  bx lr

blink_space:
  push {r0, r1, lr}
  bl green_led_off
  mov r1, #7
space_7dots:
  mov r0, dot_length
  bl delay
  sub r1, #1
  cmp r1, #0
  bne space_7dots
  pop {r0, r1, lr}
  bx lr

blink_letter:
  push {r0, r1, lr}
  bl green_led_off
  mov r1, #3
space_3dots:
  mov r0, dot_length
  bl delay
  sub r1, #1
  cmp r1, #0
  bne space_3dots
  pop {r0, r1, lr}
  bx lr

loop: 
  nop
  b loop

  b main
.size main, .-main

@ store morse code data in a array: the first number is how many dots and dashes; the following 0s and 1s indicate dots and dashes
.data
b_letter:
  .word 4, 1, 0, 0, 0, 0

@ extra code from course lab website https://cs.anu.edu.au/courses/comp2300/labs/08-data-structures/
.data
input_string:
.asciz "INPUT STRING0"

@ to make sure our table starts on a word boundary
.align 2

@ Each entry in the table is 6 words long
@ - The first word is the number of dots and dashes for this entry
@ - The next 5 words are 0 for a dot, 1 for a dash, or padding (value doesn't matter)
@
@ E.g., 'G' is dash-dash-dot. There are 2 extra words to pad the entry size to 6 words
morse_table:
  .word 2, 0, 1, 0, 0, 0 @ A
  .word 4, 1, 0, 0, 0, 0 @ B
  .word 4, 1, 0, 1, 0, 0 @ C
  .word 3, 1, 0, 0, 0, 0 @ D
  .word 1, 0, 0, 0, 0, 0 @ E
  .word 4, 0, 0, 1, 0, 0 @ F
  .word 3, 1, 1, 0, 0, 0 @ G
  .word 4, 0, 0, 0, 0, 0 @ H
  .word 2, 0, 0, 0, 0, 0 @ I
  .word 4, 0, 1, 1, 1, 0 @ J
  .word 3, 1, 0, 1, 0, 0 @ K
  .word 4, 0, 1, 0, 0, 0 @ L
  .word 2, 1, 1, 0, 0, 0 @ M
  .word 2, 1, 0, 0, 0, 0 @ N
  .word 3, 1, 1, 1, 0, 0 @ O
  .word 4, 0, 1, 1, 0, 0 @ P
  .word 4, 1, 1, 0, 1, 0 @ Q
  .word 3, 0, 1, 0, 0, 0 @ R
  .word 3, 0, 0, 0, 0, 0 @ S
  .word 1, 1, 0, 0, 0, 0 @ T
  .word 3, 0, 0, 1, 0, 0 @ U
  .word 4, 0, 0, 0, 1, 0 @ V
  .word 3, 0, 1, 1, 0, 0 @ W
  .word 4, 1, 0, 0, 1, 0 @ X
  .word 4, 1, 0, 1, 1, 0 @ Y
  .word 4, 1, 1, 0, 0, 0 @ Z