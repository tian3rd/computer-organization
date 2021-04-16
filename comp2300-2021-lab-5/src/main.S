.syntax unified
.global main

.type main, %function
main:
  @ ex1. a baisc calculator
@   @ ex1 starts here
@   @ set up the arguments
@   mov r0, #66
@   mov r1, #73
@   mov r2, #71

@   @ call the function
@   bl calculate_total_mark

@   @ go to the end loop
@   b end

@ @ .type calculate_total_mark, %function
@ @ args: r0, r1, r2
@ @ r0: ass1 mark; r1: ass2 mark; r2: final mark
@ @ result: r0 as total mark
@ calculate_total_mark:
@   @ first store the link register lr to a newly allocated address specified by sp
@   str lr, [sp, #-4]!
@   @ main operations
@   asr r0, r0, #2
@   add r0, r0, r1, asr #2
@   add r0, r0, r2, asr #1
@   @ finally load lr with the store value and reset the stack pointer sp
@   ldr lr, [sp], #4
@   bx lr
@ @ .size calculate_total_mark, .-calculate_total_mark

@ end:
@   nop
@   b end
@   @ ex1 ends here
  
  @ ex2. turning amrks into grades
@   @ ex2 starts here
@   @ set up the arguments
@   mov r0, #66
@   mov r1, #73
@   mov r2, #71

@   @ call the function
@   bl calculate_total_mark

@   bl grade_from_mark

@   @ go to the end loop
@   b end

@ @ .type calculate_total_mark, %function
@ @ args: r0, r1, r2
@ @ r0: ass1 mark; r1: ass2 mark; r2: final mark
@ @ result: r0 as total mark
@ calculate_total_mark:
@   @ first store the link register lr to a newly allocated address specified by sp
@   str lr, [sp, #-4]!
@   @ main operations
@   asr r0, r0, #2
@   add r0, r0, r1, asr #2
@   add r0, r0, r2, asr #1
@   @ finally load lr with the store value and reset the stack pointer sp
@   ldr lr, [sp], #4
@   bx lr
@ @ .size calculate_total_mark, .-calculate_total_mark

@ @ args: r0
@ @ r0: calculated mark
@ @ result: r0 as a hex value, e.g. 0xA for A (90-100), 0xB for B (80-89)...
@ grade_from_mark:
@   str lr, [sp, #-4]!
@   cmps r0, #90
@   bge mark_A
@   cmps r0, #80
@   bge mark_B
@   cmps r0, #70
@   bge mark_C
@   cmps r0, #60
@   bge mark_D
@   cmps r0, #50
@   bge mark_E
@   b mark_F
@ mark_A:
@   mov r0, #0xA
@   b end_grade
@ mark_B:
@   mov r0, #0xB
@   b end_grade
@ mark_C:
@   mov r0, #0xC
@   b end_grade
@ mark_D:
@   mov r0, #0xD
@   b end_grade
@ mark_E:
@   mov r0, #0xE
@   b end_grade
@ mark_F:
@   mov r0, #0xF
@   b end_grade
@ end_grade:
@   ldr lr, [sp], #4
@   bx lr
@ end:
@   nop
@   b end
@   @ ex2 ends here

  @ ex3. putting it together
@   @ ex3 starts here
@   @ set up the arguments
@   mov r0, #88
@   mov r1, #91
@   mov r2, #91

@   @ call the function
@   bl calculate_grade

@ @ args: r0, r1, r2
@ @ r0:
@ @ result: r0 as grade
@ calculate_grade:
@   bl calculate_total_mark
@   bl grade_from_mark

@   @ go to the end loop
@   b end

@ @ args: r0, r1, r2
@ @ r0: ass1 mark; r1: ass2 mark; r2: final mark
@ @ result: r0 as total mark
@ calculate_total_mark:
@   @ first store the link register lr to a newly allocated address specified by sp
@   str lr, [sp, #-4]!
@   @ main operations
@   asr r0, r0, #2
@   add r0, r0, r1, asr #2
@   add r0, r0, r2, asr #1
@   @ finally load lr with the store value and reset the stack pointer sp
@   ldr lr, [sp], #4
@   bx lr

@ @ args: r0
@ @ r0: calculated mark
@ @ result: r0 as a hex value, e.g. 0xA for A (90-100), 0xB for B (80-89)...
@ grade_from_mark:
@   str lr, [sp, #-4]!
@   cmps r0, #90
@   bge mark_A
@   cmps r0, #80
@   bge mark_B
@   cmps r0, #70
@   bge mark_C
@   cmps r0, #60
@   bge mark_D
@   cmps r0, #50
@   bge mark_E
@   b mark_F
@ mark_A:
@   mov r0, #0xA
@   b end_grade
@ mark_B:
@   mov r0, #0xB
@   b end_grade
@ mark_C:
@   mov r0, #0xC
@   b end_grade
@ mark_D:
@   mov r0, #0xD
@   b end_grade
@ mark_E:
@   mov r0, #0xE
@   b end_grade
@ mark_F:
@   mov r0, #0xF
@   b end_grade
@ end_grade:
@   ldr lr, [sp], #4
@   bx lr 
@ end: 
@   nop
@   b end
@   @ ex3 ends here
  nop
  
  @ ex4. recursive functions
@   @ ex4 starts here
@   @ suppose we already have a mark using the above functions
@   mov r0, #95
@   bl grade_from_mark_recursive
@   b end
@ @ args: r0 
@ @ r0: mark
@ @ return: r0 as grade of hex value
@ grade_from_mark_recursive:
@   str lr, [sp, #-4]!
@   cmps r0, #50
@   blt base_grade
@   sub r0, #10
@   bl grade_from_mark_recursive
@   sub r0, #1
@   b end_recursive
@ base_grade:
@   mov r0, #0xF
@ end_recursive:
@   ldr lr, [sp], #4
@   bx lr
@ end:
@   nop
@   b end
@   @ ex4 ends here

  @ ex5. time to cheat
@   @ ex5 starts here
@   @ set up the arguments
@   mov r0, #88
@   mov r1, #91
@   mov r2, #91

@   @ call the function
@   bl calculate_grade_sa

@   b end

@ @ args: r0, r1, r2
@ @ r0:
@ @ result: r0 as grade
@ calculate_grade_sa:
@   @ TODO: prep for call
@   bl calculate_total_mark

@   @ store teacher's mark on top of stack
@   str r0, [sp, #-4]!
@   @ delete the teacher's mark from r0
@   mov r0, 0

@   @ TODO: prep for call
@   bl self_assessment @ cheat in here
@   ldr r1, [sp], #4

@   @ calculate final grade from:
@   @ - student grade (r0)
@   @ - teacher's grade (r1)
@   @ result: r0 as final mark
@   bl calculate_final_mark

@   @ args: r0
@   @ r0: final mark
@   @ result: final grade
@   bl grade_from_mark_recursive

@   @ go to the end loop
@   b end

@ @ args: r0, r1, r2
@ @ r0: ass1 mark; r1: ass2 mark; r2: final mark
@ @ result: r0 as total mark
@ calculate_total_mark:
@   @ first store the link register lr to a newly allocated address specified by sp
@   str lr, [sp, #-4]!
@   @ main operations
@   asr r0, r0, #2
@   add r0, r0, r1, asr #2
@   add r0, r0, r2, asr #1
@   @ finally load lr with the store value and reset the stack pointer sp
@   ldr lr, [sp], #4
@   bx lr
  
@ self_assessment:
@   @ TODO: return self assessed grade in r0
@   str lr, [sp, #-4]!
@   ldr r0, [sp, #4]
@   add r0, #10
@   ldr lr, [sp], #4
@   bx lr

@ calculate_final_mark:
@   str lr, [sp, #-4]!
@   sub r1, r0, r1
@   cmps r1, #10
@   bgt penalty
@   ble average
@ penalty:
@   sub r0, r1
@   b end_mark
@ average:
@   sub r0, r0, r1, asr #1
@   b end_mark
@ end_mark:
@   ldr lr, [sp], #4
@   bx lr

@ grade_from_mark_recursive:
@   str lr, [sp, #-4]!
@   cmps r0, #50
@   blt base_grade
@   sub r0, #10
@   bl grade_from_mark_recursive
@   sub r0, #1
@   b end_recursive
@ base_grade:
@   mov r0, #0xF
@ end_recursive:
@   ldr lr, [sp], #4
@   bx lr

@ end:
@   nop
@   b end

@ @ ex5 ends here

  b main
.size main, .-main
