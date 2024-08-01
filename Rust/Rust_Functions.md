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
<details>
<summary>Click to expan</summary>
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
<details>
<summary>Click to Expand</summary>
- Function Signature: The sale_price function signature now explicitly states that it takes an i64 as input and returns an i64 as output.
- Type Checking: With this corrected signature, Rust's type checker can verify that the function is being used correctly, i.e., it's being passed an i64 value and returning an i64 value.
- The "Glitch": The previous glitch was that the return type was not specified, which meant that Rust didn't know what type of value to expect from the function. This caused a compilation error.
- Corrected Code:By adding the return type -> i64, we're telling Rust that the function returns a signed 64-bit integer, which allows the code to compile correctly.
- Analogy: Think of it like sending a package. If you don't label the package with the correct address, the postal service won't know where to deliver it. Similarly, if you don't specify the return type of a function, Rust won't know what type of value to expect, and it will raise an error.</summary>
