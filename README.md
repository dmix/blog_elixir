# Blog

A high-performance blog built with Phoenix, PostCSS, and Babel https://dmix.ca

### Features:

- [x] Real-time commenting (using websockets)
- [x] Write new blog posts using markdown with WYSIWYG editor
- [x] Secure admin section (publish posts, approve/delete comments, analytics, etc)
- [x] Category based organization system
- [x] Static pages for about, contact, etc sections
- [x] 100% Test coverage using ExUnit and phantomjs browser testing
- [ ] Syntax highlighting for code blocks
- [ ] Real-time active user list and view counts on each blog post
- [ ] Voting/<3 system for liking blog posts, comments, and more
- [ ] Email newsletter signup form
- [ ] Contact form
- [ ] Built-in server side analytics

### Built with:

Technology      | About                                  | Website
--------------- | -------------------------------------- | ----------------------------------------
Phoenix         | Elixir web framework                   | http://elixir-lang.org/
Tachyons        | CSS Framework                          | http://tachyons.io/
PostCSS         | CSS3 syntax, @imports, calc, etc       | http://postcss.org/
Babel + ES6+ES7 | Latest javascript features             | https://babeljs.io/
Argon2          | Password hashing library               | https://github.com/P-H-C/phc-winner-argon2
Comeonin        | Authentication framework               | https://github.com/riverrun/comeonin
Wallaby         | Concurrent browser testing (phantomjs) | https://github.com/keathley/wallaby
Distillery      | Elixir release management              | https://github.com/bitwalker/distillery

### Setup:

How to start app:

  * Install mix/npm dependencies with `make install`
  * Create and migrate database with `mix ecto.setup`
  * Seed database with fake content with `mix ecto.seed`
  * Start Phoenix endpoint with `mix s`
  * Run automated testing with `mix dev`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
