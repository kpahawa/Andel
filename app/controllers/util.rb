require 'rubygems'
require 'k_means'
require 'geokit'
require 'json'
require 'excon'
require 'google_distance_matrix'
#require 'pry'
#require 'pry-nav'
def all_the_things(param)
    data = param
    temp = Marshal.load(Marshal.dump(data))
    xpos = temp[0][0] > 0
    ypos = temp[0][1] > 0
    min_scale = 1
    max_scale = 100
    minx = 9999999999999
    maxx = 0
    miny = 9999999999999
    maxy = 0
    temp.each do |x|    
        if x[0].abs < minx
            minx = x[0].abs
        end
        if x[0].abs > maxx
            maxx = x[0].abs
        end
        if x[1].abs < miny
            miny = x[1].abs
        end
        if x[1].abs > maxy
            maxy = x[1].abs
        end
    end

    temp.each do |x|
        percentx = (x[0].abs - minx) / (maxx - minx)
        x[0] = percentx * (max_scale - min_scale) + min_scale
        x[0] *=1000
        percenty = (x[1].abs - miny) / (maxy - miny)
        x[1] = percenty * (max_scale - min_scale) + min_scale
        x[1] *=1000
    end

    #puts data

    average = data.size.to_f/Math.sqrt(data.size/2).ceil

    #possibly add something here to enforce diversity, such that average items per group is closest to total items / total clusters

    i = 0
    closest = 0
    solution = nil
    while i < 10
        kmeans = KMeans.new(temp, :centroids => Math.sqrt(data.size/2).ceil, :distance_measure => :euclidean_distance)
        ourTemp = JSON.parse(kmeans.inspect)
        sum = 0
        ourTemp.each do |item|
            sum+=item.size
            if average - sum.to_f/ourTemp.size < average - closest
                closest = average - sum.to_f/ourTemp.size
                solution = ourTemp
            end
        end
        i+=1
    end
    #puts kmeans.inspect  # Use kmeans.view to get hold of the un-inspected array

    groupings = []
    solution = solution.delete_if { |elem| elem.flatten.empty? }
    #removed empty clusters
    solution.each do |x|
        toGroup = []
        x.each do |y|
            toGroup.push(data[y])
        end

        while toGroup.size > 0
            toRet = []
            toCompare = toGroup[0]
            toRet.push(toCompare)
            toGroup.delete(toCompare)
            toGroup.each do |item|
                a = Marshal.load(Marshal.dump(toCompare))
                b = Marshal.load(Marshal.dump(item))
                #difference = distance a, b
                matrix = GoogleDistanceMatrix::Matrix.new
                source = GoogleDistanceMatrix::Place.new lng: toCompare[1], lat: toCompare[0]
                destination = GoogleDistanceMatrix::Place.new lng: item[1], lat: item[0]
                matrix.origins << source
                matrix.destinations << destination

                matrix.configure do |config|
                  #config.avoid = ['tolls']
                # To build signed URLs to use with a Google Business account
                  #config.google_business_api_client_id = "929264483068-vh26i93rv1tbjgqm5c858voj53pevbbv.apps.googleusercontent.com"
                  config.google_business_api_private_key = "AIzaSyD7-NZHzbI_U-D4lfiq7W8-CkJlPKSvNKU"
                end
                #use driving distance as heuristic instead of euclidean distance. this should work properly, must test it in app
                difference = 0
                timeToDrive = 0
                matrix.data[0].each do |test|
                  difference = test.distance_in_meters
                  timeToDrive = test.duration_in_seconds.to_f / 60
                end

                if difference < 4023 and timeToDrive < 10
                    toRet.push(item)
                    toGroup.delete(item)
                end
            end
            groupings.push(toRet)
        end   
    end

    ret = []
    assignedUbers = []
    groupings.each do |x|
        if x.size <= 4
            conn = Excon.new('https://api.uber.com/v1/products')
            response = conn.get(:query => { "server_token" => "-FjOHWhdqU63gsewWXkU-fC-PzYRAGx8TInrwCDZ", "latitude" => x[0][0], "longitude" => x[0][1] })
            response = JSON.parse(response.body)

            products = response['products']
            assigned = false
            products.each do |uber|
                if uber['capacity']==4
                    if uber['display_name']="uberX" and not assignedUbers.include? uber['product_id']
                        newHash = {uber['product_id'] => x}
                        contained = false
                        ret.each do |shit|

                          if shit.values.include? x
                            contained = true
                          end
                        end
                        if !contained
                          assignedUbers.push(uber['product_id'])
                          products.delete(uber)
                          ret.push(newHash)
                          assigned = true
                          break
                        end
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==6
                          if uber['display_name']="uberXL" and not assignedUbers.include? uber['product_id']
                            newHash = {uber['product_id'] => x}
                            contained = false
                            ret.each do |shit|
                              if shit.values.include? x
                                contained = true
                              end
                            end
                            if !contained
                              assignedUbers.push(uber['product_id'])
                              products.delete(uber)
                              ret.push(newHash)
                              assigned = true
                              break
                            end
                          end
                        end
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==4
                          if uber['display_name']="uberSUV" and not assignedUbers.include? uber['product_id']
                            newHash = {uber['product_id'] => x}
                            contained = false
                            ret.each do |shit|
                              if shit.values.include? x
                                contained = true
                              end
                            end
                            if !contained
                              assignedUbers.push(uber['product_id'])
                              products.delete(uber)
                              ret.push(newHash)
                              assigned = true
                              break
                            end
                          end
                        end
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==4
                          if uber['display_name']="uberBlack" and not assignedUbers.include? uber['product_id']
                            newHash = {uber['product_id'] => x}
                            contained = false
                            ret.each do |shit|
                              if shit.values.include? x
                                contained = true
                              end
                            end
                            if !contained
                              assignedUbers.push(uber['product_id'])
                              products.delete(uber)
                              ret.push(newHash)
                              assigned = true
                              break
                            end
                          end
                        end
                    end
                end
            end
        elsif x.size > 4 and x.size <=6
            assigned = false
            conn = Excon.new('https://api.uber.com/v1/products')
            response = conn.get(:query => { "server_token" => "-FjOHWhdqU63gsewWXkU-fC-PzYRAGx8TInrwCDZ", "latitude" => x[0][0], "longitude" => x[0][1] })
            response = JSON.parse(response.body)
            products = response['products']
            assigned = false
            products.each do |uber|
                if uber['capacity']==6
                  if uber['display_name']="uberXL" and not assignedUbers.include? uber['product_id']
                    newHash = {uber['product_id'] => x}
                    contained = false
                    ret.each do |shit|
                      if shit.values.include? x
                        contained = true
                      end
                    end
                    if !contained
                      assignedUbers.push(uber['product_id'])
                      products.delete(uber)
                      ret.push(newHash)
                      assigned = true
                      break
                    end
                  end
                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==6
                          if uber['display_name']="uberSUV" and not assignedUbers.include? uber['product_id']
                            newHash = {uber['product_id'] => x}
                            contained = false
                            ret.each do |shit|
                              if shit.values.include? x
                                contained = true
                              end
                            end
                            if !contained
                              assignedUbers.push(uber['product_id'])
                              products.delete(uber)
                              ret.push(newHash)
                              assigned = true
                              break
                            end
                          end
                        end
                    end
                elsif not assigned
                    temp = x
                    groupings.remove(x)
                    temp.each_slice(4).to_a
                    groupings.push(temp)
                end
            end
        else
            temp = x
            groupings.remove(x)
            temp.each_slice(4).to_a
            groupings.push(temp)
        end

    end

    return ret
end

def distance a, b
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
  dlat_rad = (b[0]-a[0]) * rad_per_deg

  lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  return rm * c # Delta in meters
end

def sort_the_sources(sources, destination)
  result = []
  sources.each do |item|
    vals = item.values
    x = vals[0]
    temp = []
    while x.size > 0
      maxIndex = 0
      maxVal = 0
      index = 0
      x.each do |y|
        src = Marshal.load(Marshal.dump(y))
        dst = Marshal.load(Marshal.dump(destination))
        difference = distance src, dst
        if difference > maxVal
          maxVal = difference
          maxIndex = index
        end
        index+=1
      end
      temp.push(x[maxIndex])
      x.delete_at(maxIndex)
    end
    newHash = {item.keys => temp}
    result.push(newHash)  
  end
  return result
end  


#puts all_the_things([[37.82954724, -122.43192352], [37.8209866, -122.4598095], [37.8119052, -122.43173582], [37.73665126, -122.40772316]])