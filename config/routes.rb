Rails.application.routes.draw do
  get 'payments/new', as: :new_payment
  get 'payments/success'
  get 'payments/failure'
  get 'payments/pending'
  post 'payments/notification'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
