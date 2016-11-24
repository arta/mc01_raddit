class CommentsController < ApplicationController

  # POST /links/:link_id/comments
  def create
    @link = Link.find( params[:link_id] )
    @comment = @link.comments.new comment_params
    @comment.user = current_user

    if @comment.save
      redirect_to @link, notice: 'Comment was successfully created.'
    else
      render "links/show"
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find( params[:id] )
    # @link = @comment.link
    @comment.destroy

    redirect_to request.referer, notice: 'Comment was successfully destroyed.'
    # redirect_to @link, notice: 'Comment was successfully destroyed.'
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:link_id, :body, :user_id)
    end
end
