defmodule ExRoboCop do
  @moduledoc """
  Documentation for `ExRoboCop`.
  """

  @type captcha_text :: String.t()
  @type captcha_image :: binary
  @type uuid :: String.t()

  @doc "Create a captcha text and a captcha image"
  @spec create_captcha :: {captcha_text, captcha_image}
  def create_captcha do
    ExRoboCop.RustCaptcha.generate()
  end

  @doc "Store captcha text under a unique ID for later retrieval"
  @spec create_form_id(captcha_text) :: uuid
  def create_form_id(captcha_text) do
    ExRoboCop.SecretAnswer.check_in(captcha_text)
  end

  @doc "Compare user answer with correct answer under uuid"
  @spec not_a_robot?({captcha_text, uuid}) :: :error | {:error, :wrong_captcha} | :ok
  def not_a_robot?({captcha_answer, form_id}) do
    ExRoboCop.SecretAnswer.check_out({captcha_answer, form_id})
  end

  @doc "Put in application children to start in supervision tree"
  @spec start :: {ExRoboCop.SecretAnswer, %{}}
  def start do
    {ExRoboCop.SecretAnswer, %{}}
  end
end
