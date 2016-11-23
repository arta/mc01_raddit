Rails.application.routes.draw do
  resources :comments, only: :destroy # DELETE /comments/:id
  devise_for :users
  resources :links do
    member do
      put 'like',     to: 'links#upvote' # PUT /links/:id/like
      put 'dislike',  to: 'links#downvote'
      # nice, handle browser back button to error comment post:
      get 'comments', to: 'links#show' # GET /links/:id/comments
    end
    resources :comments, only: :create # POST /links/:link_id/comments
  end
  root 'links#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
