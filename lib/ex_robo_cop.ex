defmodule ExRoboCop do
  @moduledoc """
  Documentation for `ExRoboCop`.
  """

  def create_captcha do
    ExRoboCop.RustCaptcha.generate
  end

  def create_form_ID(captcha_text) do
    ExRoboCop.SecretAnswer.check_in(captcha_text)
  end

  def not_a_robot?({captcha_answer, form_id}) do
    ExRoboCop.SecretAnswer.check_out({captcha_answer, form_id})
  end

  def start do
    {ExRoboCop.SecretAnswer, %{}}
  end
end
