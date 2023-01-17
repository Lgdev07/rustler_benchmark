#[rustler::nif]
fn add(a: i64, b: i64) -> i64 {
    a + b
}

#[rustler::nif]
fn factors(n: u64) -> Vec<u64> {
    let mut factors = vec!();
    let mut rest = n;
    let mut current_factor = 2;
    while rest>1 {
        if rest % current_factor == 0{
            factors.push(current_factor);
            rest = rest / current_factor;
        } else {
            current_factor += 1;
        }
    }
    factors
}

rustler::init!("Elixir.RustlerBenchmark.Rust.Math", [add, factors]);
