#[rustler::nif]

fn generate() -> Option<(String, String)> {
    match captcha::gen(captcha::Difficulty::Easy).as_tuple() {
        Some((string, data)) => Some((string, base64::encode(&data))),
        None => None,
    }
}

rustler::init!("Elixir.RustCaptcha", [generate]);
