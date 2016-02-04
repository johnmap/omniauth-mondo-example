# omniauth-mondo-example

An example Sinatra app using [omniauth-mondo](https://github.com/tombell/omniauth-mondo).

## Getting Started

Create an OAuth Client on the [Mondo Developer Console](https://developers.getmondo.co.uk).

Copy the `env.example` to `.env` and change the `MONDO_KEY` and `MONDO_SECRET` to the values from the client you created earlier.

    cp env.example .env

Install the dependencies using `bundler`.

    bundle

Run `rackup` to start the server and visit the site.

    rackup
    open http://localhost:9292

Click "Sign in" to sign in using your Mondo account.

## License

See `LICENSE` file for details. &copy; 2016 Tom Bell.
