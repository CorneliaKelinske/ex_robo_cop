defmodule ExRoboCop do
  @moduledoc """
  Documentation for `ExRoboCop`.
  """

  def create_captcha do
    ExRoboCop.RustCaptcha.generate
  end

  def get_captcha_id(captcha_text) do
    ExRoboCop.SecretAnswer.check_in(captcha_text)
  end

  def start do
    {ExRoboCop.SecretAnswer, %{}}
  end
end
