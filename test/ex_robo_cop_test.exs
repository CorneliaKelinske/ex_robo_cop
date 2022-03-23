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

  describe "not_a_robot/1" do

    test "returns :ok if the answer given by the user matches the captcha_text" do
      start_supervised!(ExRoboCop.start())
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert :ok = ExRoboCop.not_a_robot?({"CAPTCHA_TEXT", form_id})
    end

    test "returns {:error, :wrong_captcha} if the answer given by the user does not match the captcha_text" do
      start_supervised!(ExRoboCop.start())
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert {:error, :wrong_captcha} = ExRoboCop.not_a_robot?({"WRONG ANSWER", form_id})
    end
  end
end
