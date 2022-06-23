# README

This is a companion repository to demonstrate the concept described in [this blog post](https://cquinones.com/testing-thoughts-skipping-ar-callbacks/).


## Setup

* This repo requires docker
* Run `docker-compose build` to build the database and rails app

## Testing
* Run `docker-compose run api rspec spec/models/widget_create_service_spec.rb` to run the spec detailed in the blog post
