require_relative './utils' # Appelle les gems Nokogiri et Open-URI, et aussi ma méthode get_page(url_to_scrap) 

def get_cryptocurrencies_hashes_array(page, title)
  result = []
  if !page.nil? && page.instance_of?(Nokogiri::HTML::Document) && page.xpath('/html/head/title').text == title
    tr_array = page.xpath('/html/body/div[1]/div[1]/div[2]/div/div[1]/div/div[2]/div[3]/div/table/tbody/tr')
    if !tr_array.nil? && tr_array.instance_of?(Nokogiri::XML::NodeSet)
      puts "Il y a #{tr_array.length} cryptocurrencies."
      tr_array.each do |cryptocurrency_line|
        symbol = cryptocurrency_line.xpath('./td[3]/div').text
        price = cryptocurrency_line.xpath('./td[5]/div/a').text
        puts "Cryptocurrency de symbole \"#{symbol}\" et de prix \"#{price}\"."
        if !symbol.nil? && !price.nil?
          result << {symbol => price}
        end
      end
    end
  end
  result
end

url_to_scrap = "https://coinmarketcap.com/all/views/all/"
page = get_page(url_to_scrap) # Ouvre et parse la page HTML dont on donne l'URL et la stocke dans l'objet page
if !page.nil?
  title = page.xpath('/html/head/title').text
  puts "Je vais scrapper la page intitulée \"#{title}\" (\"#{url_to_scrap}\") qui est une instance de la classe \"#{page.class}\"."
  all_cryptocurrencies_hashes_array = get_cryptocurrencies_hashes_array(page, title)
  puts "Etant donné que tout le monde a bien besoin en toute circonstance d'un array de hashes de cryptomonnaies, je vous offre celui-ci : ;-p"
  puts "#{all_cryptocurrencies_hashes_array}"
  puts "Bye et n'hésitez pas à revenir m'en demander une nouvelle version si vous vous ennuyez.. sait-on jamais si Netflix tombe en panne... ;-p"
end
