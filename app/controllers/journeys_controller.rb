class JourneysController < ApplicationController
  
  before_filter :auth_user, :only => :request_ride
  
  # GET /journeys
  # GET /journeys.json
  def index
    # @journeys = Journey.where(:user_id=>current_user.id).order("created_at desc").limit(10)
    # TODO: uncomment above line after debug and delete below line
    @journeys = Journey.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @journeys }
    end
  end

  # GET /journeys/1
  # GET /journeys/1.json
  def show
    @journey = Journey.find(params[:id])
    
    #TODO add another field. delete this complex calculation
    #TODO if the journey belongs to the user, then render, else throw error
    
    t_time = convert_time(@journey.travel_time)

    from_time = t_time.change :hour=>-1, :min=>-30
    to_time = t_time.change :hour=>1, :min=>30

    to_time_string = to_time.strftime "%Y%m%d%H%M"
    from_time_string = from_time.strftime "%Y%m%d%H%M"
    
    from_time_int = from_time_string.to_i
    to_time_int = to_time_string.to_i

    @possible_matches = Journey.where :travel_time => from_time_int..to_time_int
    
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
    else if @journeys.length==2 and @ride_request_check.length==0
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
    @journey.travel_time = convert_time(@journey.travel_time)
        
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @journey }
    end
  end

  # GET /journeys/1/edit
  def edit
    @journey = Journey.find(params[:id])
    @journey.travel_time = convert_time(@journey.travel_time)
  end

  # POST /journeys
  # POST /journeys.json
  def create
    @journey = Journey.new(params[:journey])

    respond_to do |format|
      if @journey.save
        format.html { redirect_to @journey, notice: 'Journey was successfully created.' }
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
    @journey = Journey.find(params[:id])

    respond_to do |format|
      if @journey.update_attributes(params[:journey])
        format.html { redirect_to @journey, notice: 'Journey was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @journey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /journeys/1
  # DELETE /journeys/1.json
  def destroy
    @journey = Journey.find(params[:id])
    @journey.destroy

    respond_to do |format|
      format.html { redirect_to journeys_url }
      format.json { head :ok }
    end
  end
  
  def convert_time (t)
    travel_time = t.to_s
    t_year = travel_time[0..3].to_i
    t_month = travel_time[4..5].to_i
    t_day = travel_time[6..7].to_i
    t_hour = travel_time[8..9].to_i
    t_min = travel_time[10..11].to_i
    
    return Time.new(t_year, t_month, t_day, t_hour, t_min)
  end
  
end
