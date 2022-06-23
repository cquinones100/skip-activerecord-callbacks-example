FROM ruby:3.1.2

RUN gem install bundler

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /home/rails

COPY ./Gemfile /home/rails/Gemfile
COPY ./Gemfile.lock /home/rails/Gemfile.lock

COPY ./Gemfile.lock /home/rails/Gemfile.lock

COPY . /home/rails

RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD [ "rails", "s", "-b", "0.0.0.0"]