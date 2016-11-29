class LinksController < ApplicationController
  before_action :set_link, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]

  # ( implicit GET ) links_path
  # GET /links
  def index
    @links = Link.all
  end

  # ( implicit GET ) new_link_path
  # GET /links/new
  def new
    @link = current_user.links.new
    # @link = Link.new
  end

  # ( implicit POST to links_path by form_for a new_record )
  # POST /links
  def create
    @link = current_user.links.new( link_params )
    # @link = Link.new( link_params )
    # @link.user = current_user

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # ( implicit GET ) link_path( @link )
  # GET /links/1
  def show
    # .new aliases .build
    @comment = @link.comments.new # for field_with_errors in <%= form_for [@link, @comment] ..
  end

  # ( implicit GET ) edit_link_path( @link )
  # GET /links/1/edit
  def edit; end

  # ( implicit PATCH/PUT to link_path( @link ) by form_for a persisted record )
  # PATCH/PUT /links/1
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE link_path( @link )
  # DELETE /links/1
  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  # CUSTOM ACTIONS #########################################

  # PUT like_link_path( @link )
  # PUT /links/:id/like
  def upvote
    @link.upvote_by current_user
    redirect_to request.referer || root_path, notice: 'Link was successfully upvoted.'
    # redirect_back fallback_location: root_path, notice: 'Link was successfully upvoted.'
    # redirect_to :back, notice: 'Link was successfully upvoted.'
    # redirect_to @link, notice: 'Link was successfully upvoted.'
  end

  # PUT dislike_link_path( @link )
  # PUT /links/:id/dislike
  def downvote
    @link.downvote_by current_user
    redirect_to request.referer || root_path, notice: 'Link was successfully downvoted.'
    # redirect_back fallback_location: root_path, notice: 'Link was successfully downvoted.'
    # redirect_to :back, notice: 'Link was successfully downvoted.'
    # redirect_to @link, notice: 'Link was successfully downvoted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url)
    end
end
