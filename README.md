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

Add the application to your supervision tree in the `application.ex` file:

``` elixir
children = [ExRoboCop.start()
    ]
```

And install Rust on your computer.


## Usage

An example for how to use `ex_robo_cop` in a contact form on a website:

Add the `ex_robo_cop` code to the `contact_controller.ex` file:





Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_robo_cop>.


