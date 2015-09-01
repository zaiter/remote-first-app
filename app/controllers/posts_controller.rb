class PostsController < ApplicationController
  before_action :authenticate_user! 
  before_action :find_group
  before_action :member_required, only: [:new, :create, :vote]

  def new
    @post = @group.posts.new
  end
  
  def edit
    @post = current_user.posts.find(params[:id])
  end

  def show
    @post = @group.posts.find(params[:id])
  end
  
  def create
    @post = @group.posts.build(post_params)
    @post.author = current_user
    if @post.save 
      redirect_to group_path(@group), notice: "新增文章成功！"
    else
      render :new
    end
  end
  
  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to group_path(@group), notice: "文章修改成功！"
    else
      render :edit
    end
  end
  
  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to group_path(@group), alert: "文章已刪除"
  end

  def vote
    @post = @group.posts.find(params[:id])
    if !current_user.votes.include?(@post)
      current_user.votes << @post
      flash[:notice] = "這篇文章不錯"
    else
      current_user.votes.delete(@post)
      flash[:warning] = "取消按讚"  
    end
    redirect_to group_path(@group)
  end
  
  private
  def post_params
    params.require(:post).permit(:content,:private_status)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def member_required
    return if current_user.participated_groups.include?(@group)
    flash[:warning] = "你不是這個討論版的成員，不能發文喔！"
    redirect_to group_path(@group)
  end
end
