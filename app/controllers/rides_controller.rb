require 'pry'
require 'pry-nav'
require 'util'
class RidesController < ApplicationController
  before_action :set_ride, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json

  def index
    @rides = Ride.all

    @all_rides = Array.new
    @rides.each do |ride|
      @rider_objects = Array.new
      arr = Array.new
      @rider_objects = convert_to_obj_arr(arr,@rider_objects, ride.travelers)
      @all_rides.push(@rider_objects)
    end
    respond_with(@rides,@all_rides)
  end

  def show
    arr =  @ride.travelers.split(%r{,\s*})
    @rider_objects = Array.new
    @rider_objects = convert_to_obj_arr(arr,@rider_objects,@ride.travelers)

    # binding.pry
    coords = []
    @rider_objects.each do |rider|
      coord = [rider.latitude, rider.longitude]
      coords.push(coord)
    end

    ret = all_the_things(coords)
    @minPath = ret
    coord_list = Array.new
    @minPath.each do |cluster|
      cluster.values.each do |coord|
        coord_list.push(coord)
      end
    end
    @coord_list = coord_list
    respond_with(@ride,@rider_objects, @minPath,@coord_list )
  end

  def new
    @ride = Ride.new
    respond_with(@ride)
  end

  def edit
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.travelers = @ride.travelers + ",#{current_user.username}"
    arr = @ride.travelers.split(%r{,\s*})
    @rider_objects = convert_to_obj_arr_redo(arr)
    @ride.save
    respond_with(@ride)
  end



  def update
    @ride.update(ride_params)
    respond_with(@ride)
  end

  def destroy
    @ride.destroy
    respond_with(@ride)
  end

  private
    def set_ride
      @ride = Ride.find(params[:id])
    end

    def ride_params
      params.require(:ride).permit(:address, :travelers)
    end

    def convert_to_obj_arr(arr,rider_obj, travelers)

      listOfTravelers = travelers.split(%r{,\s*})
      for rider in listOfTravelers
        some_obj = User.find_by username: rider
        puts some_obj
        if some_obj != nil
          rider_obj.push(some_obj)
        end
      end
      return rider_obj
    end

    def convert_to_obj_arr_redo(arr)
      rider_obj = []
      for rider in arr
        some_obj = User.find_by username: rider
        puts some_obj
        if some_obj != nil
          rider_obj.push(some_obj)
        end
      end
      return rider_obj
    end
end
