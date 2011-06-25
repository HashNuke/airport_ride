class JourneysController < ApplicationController
  # GET /journeys
  # GET /journeys.json
  def index
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @journey }
    end
  end

  # GET /journeys/new
  # GET /journeys/new.json
  def new
    @journey = Journey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @journey }
    end
  end

  # GET /journeys/1/edit
  def edit
    @journey = Journey.find(params[:id])
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
end
