def add_gems
  gem 'foreman'

  gem_group :development do
    gem 'rubocop'
  end

  gem_group :test do
    gem 'webmock'
    gem 'factory_bot'
    gem 'faker'
    gem 'mocha'
  end
end

def remove_gems
  in_root do
    gsub_file "Gemfile", /# Build JSON.*$\n^gem 'jbuilder'.*$/, ''
  end
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
  create_procfiles

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
