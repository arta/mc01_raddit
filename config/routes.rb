# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users
  resources :links do
    member do
      put 'like',     to: 'links#upvote'   # PUT /links/:id/like
      put 'dislike',  to: 'links#downvote' # PUT /links/:id/dislike
      # Handle browser back button to failed comment post. Nice!:
      #   (i.e. backtracing after posting to /links/:link_id/comments had errors)
      get 'comments', to: 'links#show'     # GET /links/:id/comments
    end
    resources :comments, only: :create     # POST /links/:link_id/comments
  end
  resources :comments, only: :destroy      # DELETE /comments/:id

  root 'links#index'
end
