require 'open-uri'
require 'nokogiri'
require 'digest/md5'

# download page with cache
def getpage(url)
  filename = "cache/#{Digest::MD5.hexdigest(url)[0..6]}-#{url.gsub(/[^A-Za-z0-9-]/,'')}.htm"
  if File.exist? filename
    content = IO.read filename
  else
    #begin
      page = open(url)
      content = page.read
      File.open(filename, 'w') {|f| f.write(content) }
    #rescue
    #end
  end
  content
end

# очистить файл
File.open('out.txt', 'w') { |f| f.write '' }

apps = []
doc = Nokogiri::HTML(IO.read 'data/play-market-pdd.htm')

doc.css('.card.apps.small').each do |app|
  href = app.css('.title').attr('href').text
  page = getpage href

  doc2 = Nokogiri::HTML page
  title = doc2.css('.id-app-title').text
  updated = doc2.css('[itemprop="datePublished"]').text
  downloads_from, downloads_to  = doc2.css('[itemprop="numDownloads"]').text.gsub(/[^0-9–]/,'').split('–')
  size = doc2.css('[itemprop="fileSize"]').text
  version = doc2.css('[itemprop="softwareVersion"]').text
  os = doc2.css('[itemprop="operatingSystems"]').text
  age = doc2.css('[itemprop="contentRating"]').text
  address = doc2.css('.physical-address').text.gsub(/\n/, ' ')
  rating = doc2.css('.rating-box .score-container .score').text
  votes = doc2.css('.rating-box .score-container .reviews-stats .reviews-num').text
  votes_1 = doc2.css('.rating-box .rating-histogram .rating-bar-container.one .bar-number').text
  votes_2 = doc2.css('.rating-box .rating-histogram .rating-bar-container.two .bar-number').text
  votes_3 = doc2.css('.rating-box .rating-histogram .rating-bar-container.three .bar-number').text
  votes_4 = doc2.css('.rating-box .rating-histogram .rating-bar-container.four .bar-number').text
  votes_5 = doc2.css('.rating-box .rating-histogram .rating-bar-container.five .bar-number').text

  apps << [title, href, updated, downloads_from, downloads_to, size, version, os, age, address, rating, votes, votes_1,  votes_2, votes_3, votes_4, votes_5].join("\t")
  p title
end

File.open('out.txt', 'w') { |f| f.write apps.join("\n") }





