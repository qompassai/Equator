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
    # age = 21 # <- this will error if uncommented
    var can_vote = False # <- this variable can be changed, as shown later on

    if age >= 18:
        can_vote = True # <- this is allowed because `can_vote` is mutable