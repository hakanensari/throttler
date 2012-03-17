Throttler
=========

[![travis] [1]] [2]

Throttler rate-limits code execution across threads, evented blocks, or
processes on a server.

![Mapplethorpe][3]

Installation
------------

Throttler works only on platforms that support file locking.

```ruby
# Gemfile
gem 'throttler'
```

Usage
-----

The following background job ensures workers will not scrape a site faster than
once every second per IP address.

```ruby
class Scrape
  def self.perform(site, ip_address, *ids)
    Throttler.limit 1.0, site, ip_address do
      spider = Spider.new site, ip_address
      spider.scrape *ids
    end
  end
end
```

[1]: https://secure.travis-ci.org/hakanensari/throttler.png
[2]: http://travis-ci.org/hakanensari/throttler
[3]: http://f.cl.ly/items/2S343U141D0N3b3h1K09/Mapplethorpe.png
