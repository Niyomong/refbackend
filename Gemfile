source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.7'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors'
gem "devise"
gem "devise_token_auth"
gem 'kaminari' #ページネーション
gem 'dotenv-rails' #.env
gem 'pry-rails' #デバッグ

# 画像保存
gem 'carrierwave', '~> 2.0' #画像アップロード
gem 'rmagick' # 画像の加工とか
gem 'fog-aws'
gem 'aws-sdk-s3' # s3

group :production do
  gem 'mysql2'
  gem 'unicorn', '5.4.1'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
