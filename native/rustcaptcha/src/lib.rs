use base64::{Engine as _, engine::general_purpose};

#[rustler::nif]
fn generate() -> Option<(String, String)> {
    match captcha::gen(captcha::Difficulty::Easy).as_tuple() {
        
        Some((string, data)) => {
            let data = general_purpose::STANDARD.encode(data);
            Some((string, data))
        }
        
        None => None,
    }
}

rustler::init!("Elixir.ExRoboCop.RustCaptcha", [generate]);
