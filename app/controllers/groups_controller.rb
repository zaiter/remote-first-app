class GroupsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:search]
      @groups = Group.where('title LIKE ?', "%#{params[:search]}%")
    else
      @groups = Group.page(params[:page]).per(5)
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def new
    @group = Group.new
  end
  
  def edit
    @group = current_user.groups.find(params[:id])
  end

  def create
    @group = current_user.groups.create(group_params)
    if @group.save 
      current_user.join!(@group)
      redirect_to groups_path, notice: "新增討論版成功"
      # flash[:notice] = "event was successfully created"
    else
      render :action => :new
    end
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path, notice: "修改討論版成功"
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: "討論版已刪除"
    # flash[:alert] = "event was successfully deleted"
  end
  
  def join
    @group = Group.find(params[:id]) 

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本討論版成功！"
    else
      flash[:warning] = "你已經是本討論版成員了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本討論版！"
    else
      flash[:warning] = "你不是本討論版成員，怎麼退出 XD"
    end
    redirect_to group_path(@group)
  end
  private

  def group_params 
      params.require(:group).permit(:title, :description)
  end

end
