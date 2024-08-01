# High level on how Rust-lang works
- Data types
```bash
// This store is having a sale where if the price is an even number, you get 10
// Rustbucks off, but if it's an odd number, it's 3 Rustbucks off.
// Don't worry about the function bodies themselves, we are only interested in
// the signatures for now.
```

```bash
// Incorrect code
fn is_even(num: i64) -> bool {
    num % 2 == 0
}

// TODO: Fix the function signature.
fn sale_price(price: i64) -> {
    if is_even(price) {
        price - 10
    } else {
        price - 3
    }
}

fn main() {
    let original_price = 51;
    println!("Your sale price is {}", sale_price(original_price));
}```

# So how Do we correct this?

To fix the function signature for sale_price, you need to specify the return type. In this case, since the function returns a value of type i64, you should add -> i64 to the function signature.

- Correct code 
```bash

// This store is having a sale where if the price is an even number, you get 10
// Rustbucks off, but if it's an odd number, it's 3 Rustbucks off.
// Don't worry about the function bodies themselves, we are only interested in
// the signatures for now.

fn is_even(num: i64) -> i64 bool {
    num % 2 == 0
}

// TODO: Fix the function signature.
fn sale_price(price: i64) -> i64{
    if is_even(price) {
        price - 10
    } else {
        price - 3
    }
}

fn main() {
    let original_price = 51;
    println!("Your sale price is {}", sale_price(original_price));
}```


# Deep Dive Explanation

- Function Signature: The sale_price function signature now explicitly states that it takes an i64 as input and returns an i64 as output.
- Type Checking: With this corrected signature, Rust's type checker can verify that the function is being used correctly, i.e., it's being passed an i64 value and returning an i64 value.
- The "Glitch": The previous glitch was that the return type was not specified, which meant that Rust didn't know what type of value to expect from the function. This caused a compilation error.
- Corrected Code:By adding the return type -> i64, we're telling Rust that the function returns a signed 64-bit integer, which allows the code to compile correctly.
- Analogy: Think of it like sending a package. If you don't label the package with the correct address, the postal service won't know where to deliver it. Similarly, if you don't specify the return type of a function, Rust won't know what type of value to expect, and it will raise an error.

# On Expressions

- TL;DR: Rust is an "expression" based language. 

Programatically, this means that in Rust, when you end a segment of code with a semicolon (;), it becomes a "statement" that does not return any value (i.e., it returns ()). This is known as an "expression statement." However, if you remove the semicolon, the expression becomes a "tail expression," which means it will be returned by the function.

- Example of what this error looks like
```incorrect code
error[E0308]: mismatched types
--> exercises/02_functions/functions5.rs:2:24
|
2 | fn square(num: i32) -> i32 {
|    ------              ^^^ expected `i32`, found `()`
|    |
|    implicitly returns `()` as its body has no tail or `return` expression
3 |     num * num;
|              - help: remove this semicolon to return this value
```

- The cause? That semicolon. One semi-colon.

```Corrected code
fn square(num: i32) -> i32 {
    num * num
}

fn main() {
    let answer = square(3);
    println!("The square of 3 is {answer}");
}
```

- By removing the semicolon, you make sure that num * num is treated as an expression that returns an i32, matching what your function signature promises.

# Analogy: Writing a Letter
- Any time you're writing code, imagine you're writing a letter to a friend. You want to make sure your friend receives the message you've written.
- You write down your thoughts and feelings on a piece of paper. This is like writing an expression in Rust, such as num * num. If you end your message with a period (.), it's like putting a semicolon (;) at the end of your expression in Rust.
In this case, you're indicating that this is just a statement or thought, not necessarily something you want to send back to your friend. When you end with a period, it's like saying "I've finished thinking about this," but you're not actually sending anything back to your friend.
Similarly, in Rust, ending an expression with a semicolon makes it into an "expression statement" that returns no value (()).If you remove the period at the end of your message and just leave it as is, it's like saying "Here's my message; please take it."
In Rust terms, removing the semicolon turns your expression into a "tail expression," which means it will be returned by the function. Your friend expects to receive some kind of message from you.
Similarly, when you define a function in Rust with a return type (like -> i32), Rust expects that function to return something matching that type. By removing the semicolon from num * num;, you're ensuring that what you've written (the result of num * num) is actually sent back (returned) by the function.
So here's how it looks:
```bash
fn square(num: i32) -> i32 {
    num * num
}
```
This way, when someone calls square(3), they'll get back 9, which matches what they expect based on how you defined the function.


# On If statements as a Restaurant Menu
- Imagine you're at a restaurant with a menu that promises certain dishes. The menu acts like the function signature, and the dishes are like the return values.
```bash
rust
fn foo_if_fizz(fizzish: &str) -> &str {
    if fizzish == "fizz" {
        "foo"
    } else if fizzish == "fuzz" {
        "bar"
    } else {
        1 // Putting this 1 here is like going to Chick-Fli-A and ordering their Babybaby Ribs.
    }
}
```
- Function Signature: The menu promises to serve only food (&str). In programming, strings (represented as &str in rust) are words. The value 1 is an integer (i32). They're both types of data, but they are fundamentally differen types.
Dishes:
If you order "fizz," you get "foo."
If you order "fuzz," you get "bar."
For any other order, instead of serving food (like "baz"), the restaurant tries to serve an integer (1). This doesn't match what was promised on the menu.
- In other words
The glitch here is that when someone orders something other than "fizz" or "fuzz," instead of getting food (a string), they get an integer (1). This doesn't match what was promised on the menu (&str). It's like ordering food but getting a number instead.
To fix this glitch, we need to ensure that every order results in serving food as promised:
```bash
fn foo_if_fizz(fizzish: &str) -> &str {
    if fizzish == "fizz" {
        "foo"
    } else if fizzish == "fuzz" {
        "bar"
    } else {
        "baz" // Now we're serving food for all orders.
    }
}
```
In our analogy:
Fixed Menu:
If you order "fizz," you still get "foo."
If you order "fuzz," you still get "bar."
For any other order, now you'll get "baz," which is also food.
-By ensuring that every condition returns food (a string), we've fixed our restaurant menu so it matches what was promised. This way, no matter what dish someone orders, they'll always receive food as expected. The original code had a mismatch between what was promised (&str) and what was returned (i32) in one of its branches. By changing that branch to return "baz" (a string), we ensured consistency with our function signature (-> &str).
- This ensures that our code compiles correctly and behaves as expected according to its defined behavior.
