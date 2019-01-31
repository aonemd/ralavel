ralavel
---

A modern Ruby on Rails template for better frontend development

### Structure

The structure of a generated ralavel project is mainly based on Evil Martians'
[Evil Front](https://evilmartians.com/chronicles/evil-front-part-1) with the
help of Vue.js. The whole frontend lies under `frontend/` folder. The main
Javascript entry point is under `frontend/packs/application.js`. Whereas the
main Vue app is `frontend/App.vue` which is being called by the entry point.
The Vue components are all under `frontend/components`. This separation makes
it easier for frontend developers to focus on their part while the backend
developers are working on their backend APIs.

### How to use it

- You need to have Rails 6 (comes with Webpack by default) installed on your
  system or start a new Rails app with the `--webpack` option
- Create a new Rails project `rails new mycoolapp --skip-turbolinks -m
  https://raw.githubusercontent.com/aonemd/ralavel/master/template.rb`
- Accept overwriting files whenever asked by typing `y` and then pressing Enter
- Run `bundle exec formane start -f Procfile.dev`, you'll have a server running
  on port `5000`
- That's it! You can develop your app now!!

### Contribution

I used regex extensively in this template. Thus, the code is not spaghetti,
it's in fact a mix of different kinds of pasta. So if you see something you
want to improve, please open an issue or send a pull request.

### License

See [LICENSE](https://github.com/aonemd/ralavel/blob/master/LICENSE).
