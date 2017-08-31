# README

This is a basic project ([one model](/app/models/post.rb), [one controller](/app/controllers/posts_controller.rb)) to demonstrate an idea of writing tests easier and faster than using conventional approach.

More information and some backstory can be found in [this Medium story](https://blog.daftcode.pl/how-we-made-writing-tests-fun-and-easy-2d7e1fac6d16).

# tl;dr

We use [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation) to write documentation and create acceptance tests at the same time. To make those tests easier to write let's use a wrapper class (or a DSL if you like) which we'll call [ApiRequest](/lib/api_requests). It's responsible for preparing our test constraints, requests stubs and email messages expectations. To easily use this in our tests we can use a [shared example](/spec/support/shared_examples_for_api_requests.rb).

You can see an [example spec for our controller](/spec/acceptance/api/posts/create_spec.rb) to see it in action. Those tests check response status and body, but also make sure that all web requests and emails were properly stubbed, so we don't forget about anything. Having done all that you can write some additional expectations as well.

# Generating documentation

After cloning this project locally, and installing all required gems with `bundle install` you can run tests and generate documentation with `RAILS_ENV=test rake docs:generate`.

You can then view those docs under `http://localhost:3000/docs` once you start a server with `rails server`.
