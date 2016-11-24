class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /links(.json)
  def index
    @links = Link.all
  end

  # GET /links/1(.json)
  def show
    # .new aliases .build
    @comment = @link.comments.new # get field_with_errors in <%= form_for [@link, @comment] ..
  end

  # GET /links/new
  def new
    @link = current_user.links.new
    # @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links(.json)
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

  # PATCH/PUT /links/1(.json)
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

  # DELETE /links/1(.json)
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @link.upvote_by current_user
    redirect_to request.referer || root_path, notice: 'Link was successfully upvoted.'
    # redirect_back fallback_location: root_path, notice: 'Link was successfully upvoted.'
    # redirect_to :back, notice: 'Link was successfully upvoted.'
    # redirect_to @link, notice: 'Link was successfully upvoted.'
  end

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
