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

add_gems
remove_gems

after_bundle do
  prepare_database_config
  create_procfiles

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
