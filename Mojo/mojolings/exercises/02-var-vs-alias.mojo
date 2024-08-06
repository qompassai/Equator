# I'M NOT DONE

#
# Core Concept:
#
#   Mojo has two keywords for declaring variables:
#     - `var` creates mutable variables
#     - `alias` creates immutable constants
#
#   As you'll see in future exercises, these declartions are
#   required depending on the function you are using.
#
#   For this exercise, fix the errors for by making the
#   necessary variables mutable.
#
#   https://docs.modular.com/mojo/manual/basics.html#variables
#

fn main():
    alias age = 20
    alias can_vote = False

    if age >= 18:
        can_vote = True