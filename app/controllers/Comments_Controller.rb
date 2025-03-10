class CommentsController < ApplicationController
  before_action :set_blog_post, only: [ :index, :new, :create ]
  before_action :set_comment, only: [ :show, :edit, :update, :destroy ]

  def index
    @comments = @blog_post.comments
  end

  def new
    @comment = @blog_post.comments.new
  end

  def create
    @comment = @blog_post.comments.new(comment_params)
    if @comment.save
      redirect_to @blog_post, notice: "Comment added!"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to comment_path(@comment), notice: "Comment updated!"
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to blog_post_path(@comment.blog_post), notice: "Comment deleted!"
  end

  private

  def set_blog_post
    @blog_post = BlogPost.find(params[:blog_post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :author)
  end
end
