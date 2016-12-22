$:.unshift(File.expand_path(File.join(__FILE__, "../lib")))

require "climbing"

# R['5.12']
R = Climbing::RouteRating

def session
  @session ||= Climbing::Session.new.tap(&:load_data)
end

def areas
  session.selection
end

def routes
  areas[node_type: :route]
end

def packages(title=nil)
  if title
    if areas = session.packages[title]
      areas.each do |area_title, area_id|
        puts "#{area_id} — #{area_title}"
      end
    else
      rexp = Regexp.new(title.downcase)
      session.packages.each do |ta_title, areas|
        areas.each do |area_title, area_id|
          if area_title.downcase =~ rexp
            puts "#{ta_title} → #{area_title} → #{area_id}"
          end
        end
      end
    end
  else
    session.packages.each do |ta_title, areas|
      puts ta_title
      areas.each do |area_title, area_id|
        puts "  #{area_id} — #{area_title}"
      end
    end
  end

  nil
end

def download(id)
  session.download_package(id)
end