defmodule ExRoboCopTest do
  use ExUnit.Case
  doctest ExRoboCop

  setup do
    start_supervised!(ExRoboCop.start())
    :ok
  end

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
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert is_binary(form_id)
      assert %{^form_id => "CAPTCHA_TEXT"} = :sys.get_state(ExRoboCop.SecretAnswer)
    end
  end

  describe "not_a_robot/1" do
    test "returns :ok if the answer given by the user matches the captcha_text" do
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert :ok = ExRoboCop.not_a_robot?({"CAPTCHA_TEXT", form_id})
    end

    test "returns {:error, :wrong_captcha} if the answer given by the user does not match the captcha_text" do
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert {:error, :wrong_captcha} = ExRoboCop.not_a_robot?({"WRONG ANSWER", form_id})
    end

    test "returns :error if the ID does not exist" do
      assert :error = ExRoboCop.not_a_robot?({"WRONG ANSWER", "notarealid"})
    end
  end

  describe "get_answer_for_form_id/1" do
    test "returns uuid for existing form ID" do
      assert form_id = ExRoboCop.create_form_id("CAPTCHA_TEXT")
      assert {:ok, "CAPTCHA_TEXT"} = ExRoboCop.get_answer_for_form_id(form_id)
    end

    test "returns {:error, :form_id not found} if form ID does not exist" do
      assert {:error, :form_id_not_found} = ExRoboCop.get_answer_for_form_id("notarealid")
    end
  end
end
