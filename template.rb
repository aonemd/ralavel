def add_gems
  gem 'foreman'

  gsub_file "Gemfile", /^group :development do$/, <<-EOF
group :development do
  gem 'rubocop'
  EOF

  gsub_file "Gemfile", /^group :test do$/, <<-EOF
group :test do
  gem 'webmock'
  gem 'factory_bot'
  gem 'faker'
  gem 'mocha'
  EOF
end

def remove_gems
  in_root do
    gsub_file "Gemfile", /# Build JSON.*$\n^gem 'jbuilder'.*$/, ''
  end
end

def prepare_database_config
  inside 'config' do
    run 'cp database.yml database.yml.example'
  end

  run 'echo database.yml >> .gitignore'
end

def create_procfiles
  create_file 'Procfile' do <<-EOF
server: bin/rails server
  EOF
  end

  create_file 'Procfile.dev' do <<-EOF
server: bin/rails server
assets: bin/webpack-dev-server
  EOF
  end
end

def setup_frontend_folder
  # disable frontend default generators
  inside 'config' do
    generator_config = <<-EOF
    config.generators do |g|
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
    end
  end
    EOF
    gsub_file 'application.rb', /^  end$/, generator_config.chomp

    # set source path
    gsub_file 'webpacker.yml', /^  source_path: .*$/, '  source_path: frontend'
  end

  inside 'app/views/layouts' do
    gsub_file 'application.html.erb', /^.*stylesheet_link_tag.*$/, ''
    gsub_file 'application.html.erb', /^.*javascript_pack_tag.*$\n  <\/head>/, '  </head>'

    application_javascript_tag = <<-EOF
    <%= javascript_pack_tag 'application' %>
  </body>
    EOF
    gsub_file 'application.html.erb', /^  <\/body>$/, application_javascript_tag.chomp
  end

  inside 'app/controllers' do
    application_controller_config = <<-EOF
  prepend_view_path Rails.root.join("frontend")
end
    EOF

    gsub_file 'application_controller.rb', /^end$/, application_controller_config.chomp
  end

  # prepare frontend asset folder
  run 'rm -rf app/assets'
  run 'mv app/javascript frontend'
end

def setup_vue_js
  # install Vue.js
  run 'bundle exec rails webpacker:install:vue'
  run 'rm frontend/packs/hello_vue.js frontend/app.vue'
  run 'bundle exec rails generate controller pages index'

  inside 'frontend' do
    create_file 'packs/application.js' do <<-EOF
import Vue from 'vue/dist/vue.esm'
import App from '../App.vue';

new Vue({
  el: '#app',
  render: h => h(App)
});
    EOF
    end

    create_file 'App.vue' do <<-EOF
<template>
  <div>
    <p>Hello, world</p>
  </div>
</template>
    EOF
    end

    run 'mkdir components'
  end

  inside 'config' do
    gsub_file 'routes.rb', /^  get .*$/, "  root to: 'pages#index'"
  end

  inside 'app/views/pages' do
    gsub_file 'index.html.erb', /^.*$\n^.*$/, "<div id='app'></div>"
  end
end

add_gems
remove_gems

after_bundle do
  prepare_database_config
  create_procfiles
  setup_frontend_folder
  setup_vue_js

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
