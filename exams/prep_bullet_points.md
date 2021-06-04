# Watch out for these

> Just a draft for a clearer understanding

## From last review lecture

1. Recursion (lab code; [page 182](../COPE_2021_FullReview.pdf))
2. Try doing Lab 11-12
3. What's the difference between an assembler and a compiler?
4. What's the difference between _Carry_ and _Overflow_ flags?
5. Beware of the address space
6. Know how to read and implement general code instructions
7. Get familiar with basic instruction sets (with help of the [cheatsheet](../arm-assembly-cheat-sheet.pdf))
8. Tip: use [godbolt](https://godbolt.org) to translate `C` codes to the assembly
9. What's the difference between a function and a macro?
10. What's the point of using a frame pointer `fp`?
11. Know parameter passing (call by copy or reference; page 187)
    1. Know the difference between a mutable variable and an immutable variable.
12. What's the point of a static link? (next surrounding scope)
13. How does a scheduler work?
14. How to protect shared values? (`ldrex` and `strex`)
15. What's a semaphore? How to use it as a lock?
16. Concurrency and asynchronism
17. Processes and threads (page 427)
    1. SMP
18. First come first served and RR (page 435)
19. OSI
20. What's the advantage/reason to use a serial/parallel protocol? (look it up on piazza)
21. Parallel pipelines
22. Hyper-threading and multi-core and ALU
23. Pipeline hazards
24. Don't forget to test the exam website. (hints for exams: https://piazza.com/class/kl5njlf936c40y?cid=1345)
25. What's the relation between `NVIC` and `EXTI`?
26. The discoboard includes a Nested Vectored Interrupt Controller (NVIC), a special bit of hardware which is responsible for watching the various bits of hardware (and software) which can trigger interrupts in your discoboard.
27. The extended interrupts and events controller (EXTI) manages the external and internal asynchronous events/interrupts and generates the event request to the CPU/Interrupt Controller (the NVIC) and a wake-up request to the Power Controller.
28. This means that raising a GPIO-triggered interrupt is really a two-stage process (at least from the hardware’s perspective):
    1. the EXTI notices the hardware event (e.g. an edge trigger on a GPIO line, or a timer event from one of the discoboard’s many timers) and raises an interrupt line into the NVIC;
    2. the NVIC deals with that interrupt, potentially saving the current register context to the stack and switching to the handler function (depending on whether the interrupt is currently enabled, whether any higher priority interrupts are already running, etc.)
    3. (not sure) Usually ARM will save scratch registers and set the `lr` to a special value in order for `bx lr` to work as usual?
29. What's the difference between a _static link_ and a _dynamic link_?
30. Static link: context, e.g. the surrounding function or the hosting object. The caller knows this context and provides it.
    1. Some languages will not have a context by default, like `C` or `Assembly`. (gnu C expands the C standard and provides it thought)
31. Dynamic link: prior frame.
32. Refer to p208
33. What is a packet switched network and a circuit switched network?
34. Use `NAND`/`NOR` to express all kinds of basic gates.
35. Flip-flop
36.
