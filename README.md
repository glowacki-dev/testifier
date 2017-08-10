# README

This is a basic project (one model, one controller) to demonstrate an idea of writing tests easier and faster than using conventional approach.

More information and some backstory can be found in a Medium story.

# Generating documentation

After cloning this project locally, and installing all required gems with `bundle install` you can run tests and generate documentation with `RAILS_ENV=test rake docs:generate`.

You can then view those docs under `http://localhost:3000/docs` once you start a server with `rails server`.
