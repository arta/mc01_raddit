# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users
  resources :links do
    member do
      put 'like',     to: 'links#upvote'   # => like_link_path( @link )     => PUT /links/:id/like
      put 'dislike',  to: 'links#downvote' # => dislike_link_path( @link )  => PUT /links/:id/dislike
      # Handle browser back button (get) to failed link comment post. Nice!
      #   ( = backtracing after posting to /links/:link_id/comments had errors )
      #   ( = the path helper is actually never used in the app )
      get 'comments', to: 'links#show'     # => comments_link_path( @link ) => GET /links/:id/comments
    end
    resources :comments, only: :create     # POST /links/:link_id/comments
  end
  resources :comments, only: :destroy      # => DELETE link_path( @link )   => DELETE /comments/:id

  root 'links#index'
end
