# ExRoboCop

ExRoboCop is a simple captcha library that can be used as an alternative to reCaptcha to verify that a person is 
indeed a person and not a robot.

The library uses Rust to create a captcha image and corresponding text. 
A GenServer creates a unique ID for each form in which a captcha image is used and stores the ID along with the captcha text
so that a user's input into the infamous "Not a Robot" field can be verified based on the form ID.

The use of this library requires the installation of Rust.

Thank you to [Alan Vardy](https://github.com/alanvardy) for writing the Rust code.

## Installation

Add the package to your `mix.exs` file:

```elixir
def deps do
  [
    {:ex_robo_cop, "~> 0.1.0"}
  ]
end
```

Add the application to your supervision tree in the `application.ex` file, this is the GenServer that keeps track of the correct captcha answer and the form ID:

``` elixir
children = [
    ExRoboCop.start()
    ... other children
    ]
```

And install Rust on your computer.

## Usage

Assuming that you want to use `ex_robo_cop` to add a captcha to the content form on your website,
and that you are working with a `contact_controller.ex`, a `contact_view.ex` and a `new.html.heex` file, you can follow the steps below:

First of all, you need to create the captcha text, the captcha image and the id of the new contact form in the
`ContactController.new/2` function:

```elixir
{captcha_text, captcha_image} = ExRoboCop.create_captcha()

form_id = ExRoboCop.create_form_ID(captcha_text)
```

The `form_id` and the `captcha_image` will then have to be passed into the assigns of the `render\3` function.

In the `ContactController` of my personal projects, the `new/2` function will typically look like this:

```elixir
 def new(conn, _params) do
    with {captcha_text, captcha_image} <- ExRoboCop.create_captcha() do
      form_id = ExRoboCop.create_form_ID(captcha_text)

      render(conn, "new.html",
        page_title: "Contact",
        changeset: Contact.changeset(%{}),
        form_id: form_id,
        captcha_image: captcha_image
      )
    end
  end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_robo_cop>.
