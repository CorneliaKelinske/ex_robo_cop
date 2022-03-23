defmodule ExRoboCopTest do
  use ExUnit.Case
  doctest ExRoboCop

  describe "create_captcha/0" do
    test "creates a captcha text and captcha image" do
      assert {captcha_text, captcha_image} = ExRoboCop.create_captcha()
      assert is_binary(captcha_text)
      assert is_binary(captcha_image)
      assert String.length(captcha_text) in 4..6
      assert String.length(captcha_image) > 100
    end
  end

  describe "create_form_id/1" do
    test "creates a form ID" do
      start_supervised!(ExRoboCop.start())

      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert is_binary(form_id)
      assert %{^form_id => "CAPTCHA_TEXT"} = :sys.get_state(ExRoboCop.SecretAnswer)
    end
  end
end
