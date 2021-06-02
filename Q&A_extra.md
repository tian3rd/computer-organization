# From [Piazza](https://piazza.com/class/kl5njlf936c40y)

> Set a permant email related to the uni piazza account to gain access after graduation.

## Selected Q&A

### About CPU

Q: https://piazza.com/class/kl5njlf936c40y?cid=1358

#### [Q7-2020]Number of instructions

Hi all,

Having fewer instructions is better because it will take the CPU less time to search for each instruction, so execution will be faster. Is this one valid?

How does the CPU know which instruction to look for? By checking op-codes?
How long does it take the CPU to search for the instruction then?
The number of instructions needs to be close to a power of two (e.g., 256) matching the bus-width of the CPU, so only the smaller ISA will work. Is this one valid?

What is the bus-width of the CPU?
Where are all these instructions stored? Is it hard-coded somewhere in a special hardware?
Thanks!

A:
Remember the mini ALU which we built at the beginning of the lecture. It contains a little instruction decoder. Does the time it takes to decode those instructions depend on the number of instructions?
In the context of a CPU, the term external bus usually refers to the memory bus and the width of this bus is usually the size of your registers. There are exceptions to this rule, and so there are CPUs which have buses which are narrower than its registers, because for instance they want to keep the same overall architecture as its bigger siblings, but skimp on the memory interface to safe money.
The opcodes are indeed stored inside the CPU (in form of a decoder hardware). There are multiple ways to do this. Some CPUs are even hierarchical here and instructions can be broken down into simpler instructions which are then executed on another internal machine. The decoding is the first thing which happens to a freshly fetched instruction. Decoders grow indeed with the number of instructions, which a CPU can understand. In the olden days when CPUs where equipped with 4 bit or 8 bit registers, you were a bit pressed with the possible number of instructions, as if your numbers of instructions are larger than your bus or register width, then you need to read your memory twice for a single instruction. You think from the other end these days: you can fetch 32 or 64 bit in one memory operation, so what can you do with those many bits to come up with the most efficient instruction set, usually limiting each instruction to maximally one word. Those are so called RISC (reduced instruction set computing) architectures, which can theoretically execute one instruction per CPU cycle. Your ARM CPU has an extra trick up it's sleeve: it can also handle smaller instructions, so that it actually fetch 2 instructions in one memory operation.
-By Uwe (Instructor)

More:
Great read for Instruction Set Architecture: https://www.plantation-productions.com/Webster/www.artofasm.com/Linux/HTML/ISA.html

### About Discoboard Priorities

Q: https://piazza.com/class/kl5njlf936c40y?cid=1339

#### Priority settings using utils.S

Hi all,

Just a quick question when reviewing the lab materials:

if I want to set priorities for my pins, e.g. PB7 to be of 1, PE13 to be 2, and PD0 to be 0 (so PD0 has the highest priority, PB7 the second highest and PE13 the lowest, so that PD0 can be triggered inside the PB7 or PE13 interrupt handler), I want to use the functions NVIC_IPR_set_priority and SHPR_set_priority in utils.S, which one should I use in this case?

Do I just use

```assembly
mov r0, 6 @ this is for PD0, for PB7 it would be in position 23, for PE13 pos 40
mov r1, 0 @ this is for PD0, for PB7 it is 1, for PE13 it is 2
bl NVIC_IPR_set_priority
```

for all three of them? Or do I need to use SHPR_set_priority as well right after?

By the way, what are the differences between these two NVIC_IPR and SHPR (what does SHPR stand for?)

Thank you very much!

A:
ARMv7-M Architecture Reference Manual
Have a look at pg 687 (B3.4)
and
STM32L4x6 advanced ARM®-based 32-bit MCUs
pg 321 - 324 (section 11.3)
with instructors' explanation in
@1093
will get your heads around setting interrupt for your pins.
I think you may need to use NVIC_IPR_set_priority for setting priority for you pins. (this function used the method describe above in @1093)
I am not sure about SHPR, but I think it is related to SysTick?
By a friendly classmate

Followups:

Thanks, Guanming!

I come across this problem when I try to trigger an interrupt inside another interrupt. The weird thing is that when I set the priorities for both of them, the higher priority one insider does not trigger immediately. I tried to use sync (by putting 14 nop afterwards, but still, it will handle the lower one first, then jump out, then trigger the higher one:

```assembly
main:
@@@ here set up the priorities: EXTI0 priority = 15, EXTI9_5 priority = 1 (higher) @@@

loop: @ keep looping until it receives an interrupt for EXTI0 e.g
  nop
  b loop

@@@ here are handlers
EXTI0_IRQHandler:
  push {lr}
  @@@ here triggers EXTI9_5 (but it does NOT trigger immediately, even though it has a higher priority, instead it goes back to `loop`, and after a while, it triggers 9_5...)
  @@@ here adds a sync (14 nop)
  @@@ clear pending after
  pop {lr}
  bx lr

EXTI9_5_IRQHandler:
@@@ some operations here
```
