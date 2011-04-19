require 'net/http'
require 'json'

class GithubFinder
  def initialize(repo)
    url = URI.parse("http://github.com/api/v2/json/repos/show/#{repo}/watchers?full=1")
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.get("/api/v2/json/repos/show/#{repo}/watchers?full=1")
    end

    @watchers = JSON.parse(res.body)["watchers"]
  end

  def watchers
    @watchers
  end

  def find_by_location(location)
    "login, name, company, location"

    @watchers.collect do |watcher|
      if (watcher['location'] && watcher['location'].match(/#{location}/i))
        [ watcher['login'], watcher['name'], watcher['company'], watcher['location'] ]
      end
    end

    nil
  end

  def locations
    @watchers.collect do |watcher|
      watcher['location']
    end.uniq!
  end

  def to_s
    "GithubFinder watchers:#{watchers.length}"
  end

end
