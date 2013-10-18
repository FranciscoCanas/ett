require 'jira_bug.rb'



class JiraBugsController < ApplicationController
  # GET /jira_bugs
  def index
    @jira_bugs = JiraBug.all
  end

  def show
    # The bug:
    @jira_bug = JiraBug.find(params[:id])
    
    # Grab the issue info from JIRA
    @info = JiraBug.get(params[:id])
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def sync
    # Authenticate from userinfo
    JiraBug.authenticate(@user,@password)

    # Grab the issue info from JIRA
    @info = JiraBug.get(params[:id])
    

    # If we get a jira_info back:
    unless @info.nil?
      # Is it already in database?
      if JiraBug.exists?(:key => params[:id]) then
        # Update the local copy
        @jira_bug = JiraBug.find(params[:id])
        JiraBug.update_from_jira_info(@info, @jira_bug)
      else
        # Create a new local copy
        @jira_bug = JiraBug.create_from_jira_info(@info)
      end
    else
      # If we got nil back, print some error or something
      respond_to do |format|
      format.js {
          render :status => $response.code
      }
    end
    end

  end
end
