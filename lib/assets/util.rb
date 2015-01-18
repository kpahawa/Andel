require 'rubygems'
require 'k_means'
require 'geokit'
require 'json'
require 'excon'

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
                a = Geokit::LatLng.new(toCompare[0],toCompare[1])
                b = Geokit::LatLng.new(item[0], item[1])
                if a.distance_to(b) < 4828
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
        print x.inspect
        puts
        puts
        if x.size <= 4
            conn = Excon.new('https://api.uber.com/v1/products')
            response = conn.get(:query => { "server_token" => "-FjOHWhdqU63gsewWXkU-fC-PzYRAGx8TInrwCDZ", "latitude" => x[0][0], "longitude" => x[0][1] })
            response = JSON.parse(response.body)
            print response
            puts
            puts
            products = response['products']
            assigned = false
            products.each do |uber|
                if uber['capacity']==4
                    if uber['display_name']="uberX" and not assignedUbers.include? uber['product_id']
                        newHash = {uber['product_id'] => x}
                        assignedUbers.push(uber['product_id'])
                        products.delete(uber)
                        ret.push(newHash)
                        assigned = true
                        break
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==6
                            if uber['display_name']="uberXL" and not assignedUbers.include? uber['product_id']
                                newHash = {uber['product_id'] => x}
                                assignedUbers.push(uber['product_id'])
                                products.delete(uber)
                                ret.push(newHash)
                                assigned = true
                                break
                            end
                        end
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==4
                            if uber['display_name']="uberSUV" and not assignedUbers.include? uber['product_id']
                                newHash = {uber['product_id'] => x}
                                assignedUbers.push(uber['product_id'])
                                products.delete(uber)
                                ret.push(newHash)
                                assigned = true
                                break
                            end
                        end
                    end

                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==4
                            if uber['display_name']="uberBlack" and not assignedUbers.include? uber['product_id']
                                newHash = {uber['product_id'] => x}
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
                        assignedUbers.push(uber['product_id'])
                        products.delete(uber)
                        ret.push(newHash)
                        assigned = true
                        break
                    end
                elsif not assigned
                    products.each do |uber|
                        if uber['capacity']==6
                            if uber['display_name']="uberSUV" and not assignedUbers.include? uber['product_id']
                                newHash = {uber['product_id'] => x}
                                assignedUbers.push(uber['product_id'])
                                products.delete(uber)
                                ret.push(newHash)
                                assigned = true
                                break
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

    puts ret
end