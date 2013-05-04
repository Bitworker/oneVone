class UserController < ApplicationController

  def index
    @users   = User.order('elo DESC, wins DESC').all
    @user    = User.new
    @history = History.all
  end

  def new
    if params[:user][:ig_name].present? && @user = User.create(params[:user])
      History.create(:message => "<<span class='orange'>#{@user.ig_name}</span>> ist der Liga beigetreten...")
    end

    redirect_to root_url
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      History.create(:message => "<<span class='orange'>#{@user.ig_name}</span>> hat die Liga verlassen...")
      redirect_to root_url
    end
  end

  def match_result
    if (params[:history][:winner].present? && 
        params[:history][:looser].present? && 
        params[:winner_kills].present?     && 
        params[:winner_deaths].present?    && 
        params[:looser_kills].present?     && 
        params[:looser_deaths].present?)

      @winner = User.find_by_ig_name(params[:history][:winner])
      @looser = User.find_by_ig_name(params[:history][:looser])
       
      @winner_ratio = params[:winner_kills].to_f / params[:winner_deaths].to_f
      @looser_ratio = params[:looser_kills].to_f / params[:looser_deaths].to_f

      ea = 1 / ( 1 + ( 10**( (@winner.elo.to_f - @looser.elo.to_f) / 400 ) ) )
      eb = 1 - ea

      k_winner = 30 * ( (0.1..10.0).include?(@winner_ratio) ? @winner_ratio : 1 )
      k_looser = 30 / ( (0.1..10.0).include?(@looser_ratio) ? @looser_ratio : 1 )
      
      elo_winner = (k_winner * ( 1 - eb)).to_i
      elo_looser = (k_looser * ( 0 - ea)).to_i

      History.create(:winner => @winner.ig_name, :winner_points => elo_winner, :looser => @looser.ig_name, :looser_points => elo_looser )
      @winner.update_attributes(:wins => @winner.wins + 1, :elo => @winner.elo + elo_winner)
      @looser.update_attributes(:looses => @looser.looses + 1, :elo => @looser.elo + elo_looser )
    end

    redirect_to root_url
  end
end
