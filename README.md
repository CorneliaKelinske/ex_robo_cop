# ExRoboCop

ExRoboCop is a lightweight captcha library that can be used as an alternative to reCaptcha to verify that a person is 
indeed a person and not a robot.

The library uses Rust to create a captcha image and corresponding text. 
A GenServer creates a unique ID for each form in which a captcha image is used and stores the ID along with the captcha text
so that a user's input into the infamous "Not a Robot" field can be verified based on the form ID.

The use of this library requires the installation of Rust.

Thank you to [Alan Vardy](https://github.com/alanvardy) for writing the Rust code.

Documentation can be found at [https://hexdocs.pm/ex_robo_cop](https://hexdocs.pm/ex_robo_cop).
This library is in use at [connie.codes](https://connie.codes/).

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

`create_captcha\0`   
creates a captcha text and a captcha image

`create_form_id\1`   
 creates a unique ID for a contact form and stores it in combination with the current captcha text

`not_a_robot?\1`   
checks whether the combination of the user's answer to the "Not a Robot" question and the form ID match the form ID and captcha text stored in the GenServer


## Example

Assuming that you want to use `ex_robo_cop` to add a captcha to the content form on your website,
and that you are working with a `contact_controller.ex`, a `contact_view.ex` and a `new.html.heex` file, you can follow the steps below:

First of all, you need to create the captcha text, the captcha image and the id of the new contact form in the
`ContactController.new/2` function:

```elixir
{captcha_text, captcha_image} = ExRoboCop.create_captcha()

form_id = ExRoboCop.create_form_id(captcha_text)
```

The call to `ExRoboCop.create_form_id\1` stores the `form_id` and the `captcha_text` as a key-value pair in the GenServer.
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

The next step is rendering the captcha image in the contact form in your `.heex` template. 
Since the image data is passed into the `render/3` assigns as binary, it needs to be converted in order to be displayed.

In Phoenix 1.6, you can add the following function to your corresponding `view.ex` file:

```elixir
  def display_captcha(captcha_image) do
    content_tag(:img, "", src: "data:image/png;base64," <> captcha_image)
  end
```

and then call this function in your `heex` template:

```html
<%= display_captcha(@captcha_image) %>
```

In Phoenix 1.5, you can convert the binary directly in the `.eex` template:

```html
<img src="data:image/png;base64,<%= Base.encode64(@captcha_image)%>"> 
```

The form also needs to include an input field for users to input the letters they see in the captcha image as well
as a hidden input field through which the `form_id` can be passed back to the controller when the form is submitted:

```html
<div class="field">
  <%= label f, :not_a_robot, class: "label"%>
  <div class="control">
    <%= text_input f, :not_a_robot, class: "input", type: "text", placeholder: "Please enter the letters shown below" %>
  </div>
</div>

<%= text_input f, :form_id, type: "text", hidden: true, value: @form_id %>
```

When the form is submitted, the `form_id` and the user's answer are sent back to the controller as part of the form content.
I suggest pattern matching on them in the head of the controller's `create/2` function for example like this:

```elixir
 def create(conn, %{"content" => %{"not_a_robot" => captcha_answer, "form_id" => form_id} = message_params}) do 
```

Now, you can pass the user's answer and the form_id as a tuple into `ExRoboCop.not_a_robot?\1` in order to verify that
the answer matches the captcha text stored for the respective `form_id` in the GenServer.

```elixir
  :ok = not_a_robot?({captcha_answer, form_id})  
```


## Production

Since `ex_robo_cop` requires Rust, you will need to add the command to install Rust to your `Dockerfile`:

```
# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git rustc\
    && apt-get clean && rm -f /var/lib/apt/lists/*_*
```






