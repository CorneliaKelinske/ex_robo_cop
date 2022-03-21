defmodule ExRoboCop.RustCaptcha do
  @moduledoc """
  Uses Rust to generate a captcha in the form of a tuple consisting of
  a string and a base 64 encoded binary
  """
  use Rustler, otp_app: :ex_robo_cop, crate: "rustcaptcha"

  # When your NIF is loaded, it will override this function.
  def generate, do: :erlang.nif_error(:nif_not_loaded)
end
