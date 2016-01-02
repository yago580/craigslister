# Thrown when low price is higher than high price
class InvalidRangeError < StandardError
end

# Creates url from arguments and tells ItemSearcher to scrape
class Craigslister
  attr_reader :area, :item, :high, :low

  def initialize(args)
    @area    = args.fetch(:area, 'sfbay')
    @item    = args[:item]
    @high    = args.fetch(:high, nil)
    @low     = args.fetch(:low, nil)
    validate_price_range
  end

  def scrape
    searcher.scrape
  end

  def links
    searcher.links
  end

  def url
    "#{base_url}/search/sss?sort=rel&"\
    "#{price_query}query="\
    "#{item.downcase.split(' ') * '+'}"
  end

  private

  def base_url
    "https://#{area}.craigslist.org"
  end

  def price_query
    result = ''
    result += "min_price=#{low}&" if low
    result += "max_price=#{high}&" if high
    result
  end

  def searcher
    ItemSearcher.new(base_url: base_url, url: url)
  end

  def validate_price_range
    fail InvalidRangeError if low && high && low > high
  end
end