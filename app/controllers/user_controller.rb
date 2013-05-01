class UserController < ApplicationController
  before_filter :get_winner_and_looser, :only => [:match_result, :gieb_points]
  def index
    @users   = User.all
    @user    = User.new
    @history = History.all
  end

  def new
    if @user = User.create(params[:user])
      History.create(:message => "<<span class='orange'>#{@user.ig_name}</span>> ist der Liga beigetreten...")
      redirect_to root_url
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      History.create(:message => "<<span class='orange'>#{@user.ig_name}</span>> hat die Liga verlassen...")
      redirect_to root_url
    end
  end

  def match_result
    History.create(:winner => @winner.ig_name, :winner_points => gieb_points(true), :looser => @looser.ig_name, :looser_points => gieb_points(false))
    @winner.update_attributes(:wins => @winner.wins + 1, :elo => @winner.elo + gieb_points(true))
    @looser.update_attributes(:looses => @looser.looses + 1, :elo => @looser.elo + gieb_points(false))
    
    redirect_to root_url
  end

  protected

  def gieb_points(is_winner)
    ea = 1 / ( 1 + ( 10**( (@winner.elo.to_f - @looser.elo.to_f) / 400 ) ) )
    eb = 1 - ea
    if is_winner
      k = 15
      result = k * ( 1 - ea)
    else
      k = 15
      result = k * ( 0 - ea)
    end

    result.to_i
  end

  def get_winner_and_looser
    @winner = User.find_by_ig_name(params[:history][:winner])
    @looser = User.find_by_ig_name(params[:history][:looser])
  end
end
