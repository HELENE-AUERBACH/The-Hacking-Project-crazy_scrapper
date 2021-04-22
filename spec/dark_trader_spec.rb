require_relative '../lib/dark_trader'

url_to_scrap = "https://coinmarketcap.com/all/views/all/"
page = get_page(url_to_scrap) # Ouvre et parse la page HTML dont on donne l'URL et la stocke dans l'objet page
all_cryptocurrencies_hashes_array = get_cryptocurrencies_hashes_array(page, "All Cryptocurrencies | CoinMarketCap")
puts "Nombre total de cryptocurrencies scrappées : #{all_cryptocurrencies_hashes_array.length}" 
describe "the get_cryptocurrencies_hashes_array method" do
  it "should return an array of hashes for all cryptocurrencies on the \"page\" argument - which has got the \"title\" argument for title (what such a surprise!!!) -, and this \"all_cryptocurrencies_hashes_array\" is not nil" do
    expect(all_cryptocurrencies_hashes_array).not_to be_nil
  end
  it "should return an \"all_cryptocurrencies_hashes_array\" which contains more than 100 cryptocurrencies and less than 1001" do
    expect(all_cryptocurrencies_hashes_array.length).to be_between(101, 1000)
  end
  it "should return an \"all_cryptocurrencies_hashes_array\" which contains an 'USDC' and a 'BTC' cryptocurrencies" do
    total_of_found_cryptocurrencies = all_cryptocurrencies_hashes_array.count { |hash| (hash.has_key?("USDC") || hash.has_key?("BTC")) }
    expect(total_of_found_cryptocurrencies).to eq(2)
  end
end
