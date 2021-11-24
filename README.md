# Game of Life

19th November update:
I've got specs + implementation for the Generation model and methods to calculate next generation.

Note: I'm using a sqlite db. I did not deem necessary to switch to postgres for this exercise.

20th November update:
next generation calculaton is now implemented. It uses service IteratorService like this (after running db creation/migrations):

> s=IteratorService.new(file_path: 'data/test_generation_00.txt')
>
> s.run

Ouptut at the moment is a string containing expected result.

So, basically now backend part is working. Frontend still to be developed.