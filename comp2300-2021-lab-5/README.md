# comp2300-2021-lab-5

<https://cs.anu.edu.au/courses/comp2300/labs/05-functions/>

## Q&A

1. What's the meaning of `bl foo` and `bx lr` in the following snippet?

   ```assembly
   main:
     bl foo

   .type foo, %function
   @ args:
   @ r0:
   @ result:
   foo:
     @ does sth
     bx lr
   .size foo, .-foo
   ```

   - if we add line 19 and 33 in `main.S`, why can't we step into this function in debug mode?

2. What's the meaning of `.type` and `.size` in the above snippet?

3. Search why 'suffix on cmparison instruction is deprecated' (propmted by `cmps r0, 80`?

4. Sections in the program are _directives_ (starting with a `.`) to the assembler that different parts of the program should go in different parts of the discoboard's membory space. Some parts of this address space are for instructions which the discoboard will execute, but other parts contain _data_ that your program can use. ![Address Space](https://cdn-std.droplr.net/files/acc_498334/QclpZ0)

   - What is a `.text` section and what does it do?
   - What about `.data`?
   - A. Anything after a `.text` (until the next secton) will appear as program code for your discoboard to excute; anything after `.data` section will be put in RAM as membory that your program can use to read/write data your program needs to do useful things.
   - When creating a new `main.S` file, any instructions are put in the `.text` section until the assembler sees a new section directive.

5. to be continued...
