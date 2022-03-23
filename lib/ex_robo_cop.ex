defmodule ExRoboCop do
  @moduledoc """
  Documentation for `ExRoboCop`.
  """

  @type captcha_text :: String.t()
  @type captcha_image :: binary
  @type uuid :: String.t()

  @spec create_captcha :: {captcha_text, captcha_image}
  def create_captcha do
    ExRoboCop.RustCaptcha.generate()
  end

  @spec create_form_id(captcha_text) :: uuid
  def create_form_id(captcha_text) do
    ExRoboCop.SecretAnswer.check_in(captcha_text)
  end

  @spec not_a_robot?({captcha_text, uuid}) :: :error | {:error, :wrong_captcha} | :ok
  def not_a_robot?({captcha_answer, form_id}) do
    ExRoboCop.SecretAnswer.check_out({captcha_answer, form_id})
  end

  @spec start :: {ExRoboCop.SecretAnswer, %{}}
  def start do
    {ExRoboCop.SecretAnswer, %{}}
  end
end
