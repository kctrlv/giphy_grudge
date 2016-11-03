class SessionsController < ApplicationController
  def create
    res = Faraday.get("https://slack.com/api/oauth.access?client_id=#{ENV['slack_id']}&client_secret=#{ENV['slack_secret']}&code=#{params['code']}")
    raw_res = JSON.parse(res.body, symbolize_names:true)
    if raw_res[:team][:id] == ENV['turing_team_id']
      user = User.find_or_create_by(uid: raw_res[:user][:id])
      user.name = raw_res[:user][:name]
      user.uid = raw_res[:user][:id]
      user.token = raw_res[:access_token]
      user.save
      session[:user_id] = user.id
      redirect_to lobby_path
    else
      flash[:danger] = "Sorry, this app is restricted to users of a particular Team"
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
