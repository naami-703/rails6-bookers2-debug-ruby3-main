Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users
  
  root 'homes#top'
  get 'home/about' => 'homes#about'
  # 検索
  get "search" => "searchs#search"
  # カテゴリータグ
  get 'tagsearches/search', to: 'tagsearches#search'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

resources :messages, only: [:create]
resources :rooms, only: [:create,:show]

# ゲストログイン設定
devise_scope :user do
  post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
end

end