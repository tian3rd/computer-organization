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

  @ ex2. a morse data structure
  @ ex2 starts here
  @ which letter
ex2_starts:
  ldr r0, =b_letter
  @ how many dots and dashes
  ldr r1, [r0]
start_blink:
  ldr r2, [r0, #4]!
  cmp r2, 0
  it eq
    bleq blink_dot
  it gt
    blgt blink_dash
  sub r1, #1
  cmp r1, 0
  bgt start_blink
  @ delay for 3 dots length
  bl blink_letter
  @ loop
  b ex2_starts

  @ ex2 ends here

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