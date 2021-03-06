class TweetsController < ApplicationController
    get '/tweets' do

        if logged_in? 
            @tweets = Tweet.all
            erb :'/tweets/tweets'
        else 
            redirect "/login"
        end 
        
    end

    get '/tweets/new' do
        if logged_in?
            erb :'/tweets/new'
        else 
            redirect "/login"
        end 
    end

    get '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if logged_in?
            erb :'/tweets/show'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find(params[:id])
            # if current_user == @tweet.user
                erb :'/tweets/edit'
            # else
            #     redirect '/login'
            # end
        else
            redirect '/login'
        end
    end

    patch "/tweets/:id" do 
        if logged_in?
            if params[:content] != ""
                @tweet = Tweet.find(params[:id])
                @tweet.update(content: params[:content])
                redirect "/tweets/#{@tweet.id}"
            else 
                redirect "/tweets/#{params[:id]}/edit"
            end 
        else
            redirect '/login'
        end
    end 

    post '/tweets' do
        if params[:content] != ""
            @tweet = Tweet.create(content: params[:content])
            @user = User.find(session[:user_id])
            @tweet.user = @user
            @tweet.save
            redirect "/tweets/#{@tweet.id}"
        else 
            redirect "/tweets/new"
        end 
    end

    delete '/tweets/:id' do
        @tweet = Tweet.find(params[:id])
        if current_user == @tweet.user
            @tweet.destroy
            redirect '/tweets'
        else
            redirect "/tweets/#{@tweet.id}"
        end
    end

    
end
