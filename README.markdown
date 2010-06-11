# Tdo

A simple ruby app that can edit and read a todo list.

## How To

Install with:

    (sudo) gem install tdo

Then add a new task with:
  
    tdo "I'm a new task!"

...Or add keep your tasks in groups with:

    tdo @work "Do that job thing"

View your tasks with:

    tdo -r
    tdo -r @work

Mark tasks as done when finished:

    tdo -d "I'm a new task"
    tdo -d @work "Do that job thing"

Then clear and forget:

    tdo -c


## Copyright

Copyright (c) 2010 Joshua Hawxwell. See LICENSE for details.
