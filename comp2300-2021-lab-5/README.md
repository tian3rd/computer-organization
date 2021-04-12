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

4.
