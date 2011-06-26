class JourneysController < ApplicationController
  
  before_filter :check_login
  before_filter :auth_user, :only => :request_ride
  before_filter :owned_by_user?, :only =>[:edit, :destroy, :update]
  
  # GET /journeys
  # GET /journeys.json
  def index
    @journeys = Journey.where(:user_id=>current_user.id).order("created_at desc").limit(10)
    #@journeys = Journey.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @journeys }
    end
  end

  # GET /journeys/1
  # GET /journeys/1.json
  def show
  
    if params[:request_to_ride]
      from_id = params[:id]
      to_id = params[:request_to_ride]
          
      @journeys = Journey.where(:id=>[from_id,to_id])
      @ride_request_check = RideRequest.where(:journey_id=>from_id)
  
      if @journeys.empty?
        flash[:notice] = "Ride request failed"
      elsif @journeys.length==2 and (@ride_request_check.length==0)
        @ride_request = RideRequest.new(:journey_id=>from_id, :for_journey_id=>to_id)
        if @ride_request.save
          flash[:notice] = "Ride request sent"
        else
          flash[:notice] = "Ride request failed"
        end
      end 
    end
    
    @journey = Journey.find(params[:id])

    #TODO add another field. delete this complex calculation
    #TODO if the journey belongs to the user, then render, else throw error
    
    @matches = @journey.possible_matches
    
    @sent_requests = []
    
    @matches.each do |m|
      if @journey.ride_requests.where(:for_journey_id => m.id).length == 1
        @sent_requests.push m.id
      end
    end
    
    # if json, you'll need @possible_matches and @journey in hash
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {journey: @journey, possible_matches: @possible_matches} }
    end
  end
  
  def request_ride
    from_id = params[:from_id]
    to_id = params[:to_id]
        
    @journeys = Journey.where(:id=>[from_id,to_id])
    @request_ride_check = RideRequest.where(:journey_id=>from_id)

    if @journeys.empty?
      # then don't do anything bob
      render json: {:error=>"empty"}
    elsif @journeys.length==2 and (@ride_request_check.length==0)
      @ride_request = RideRequest.new(:journey_id=>from_id, :to_id=>to_id)
      if @ride_request.save
        render json: {:msg=>"added"}
      else
        render json: {:msg=>"empty"}
      end
    end    
  end

  def new
    @journey = Journey.new
    @journey.travel_time = DateTime.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @journey }
    end
  end

  # GET /journeys/1/edit
  def edit
  end

  # POST /journeys
  # POST /journeys.json
  def create
    @journey = Journey.new(params[:journey])
    @journey.user_id = current_user.id

    respond_to do |format|
      if @journey.save
        format.html { redirect_to root_path, notice: 'Journey was successfully created.' }
        format.json { render json: @journey, status: :created, location: @journey }
      else
        format.html { render action: "new" }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /journeys/1
  # PUT /journeys/1.json
  def update

    respond_to do |format|
      if @journey.update_attributes(params[:journey])
        format.html { redirect_to @journey, notice: 'Journey was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { 
          render json: {errors: @journey.errors, status: :unprocessable_entity}
        }
      end
    end
  end

  # DELETE /journeys/1
  # DELETE /journeys/1.json
  def destroy
    @journey.destroy

    respond_to do |format|
      format.html { redirect_to journeys_url }
      format.json { head :ok }
    end
  end
  
  private
  
  def owned_by_user?
    @journey = Journey.find(params[:id])
    if @journey.user_id != current_user.id
      redirect_to root_url
    end
  end
  
  def check_login
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end 
