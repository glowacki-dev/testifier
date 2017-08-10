Rails.application.routes.draw do
  resources :posts

  mount Raddocs::App => '/docs'
end
