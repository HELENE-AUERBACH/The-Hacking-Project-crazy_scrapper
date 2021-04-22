require_relative './utils' # Appelle les gems Nokogiri et Open-URI, et aussi ma méthode get_page(url_to_scrap) 

def get_deputy_informations(deputy_url)
  # Retourne le prénom, le nom et l’e-mail d'un député à partir de l'URL de la page particulière de ce député,
  # si ces informations ont pu être trouvées, sous la forme d'un hash dont les clés sont "first_name", "last_name" et "email",
  # et renvoie nil si ces informations n'ont pas pu être trouvées
  deputy_informations_hash = nil
  page = get_page(deputy_url) # Ouvre et parse la page HTML dont on donne l'URL et la stocke dans l'objet page
  if !page.nil? && page.instance_of?(Nokogiri::HTML::Document)
    title = page.xpath('/html/head/title').text
    puts "Je vais scrapper la page intitulée \"#{title}\" (\"#{deputy_url}\")."
    deputy_email = page.xpath("/html/body/div[1]/div[2]/div/div/div/section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a").text
    deputy_full_name = page.xpath("/html/body/div[1]/div[2]/div/div/div/section[1]/div/article/div[2]/h1").text
    # Suppression de "M. " ou "Mme " et séparation du prénom et du nom dans un tableau
    deputy_first_and_last_names_array = deputy_full_name.sub("M. ", "").sub("Mme ", "").split
    # Création du hash de ce député avec son prénom, son nom et son e-mail
    deputy_informations_hash = {"first_name" => deputy_first_and_last_names_array[0], "last_name" => deputy_first_and_last_names_array[1], "email" => deputy_email }
  end
  deputy_informations_hash
end

def get_deputies_informations(deputies_list_url)
  # Retourne les informations essentielles (prénom, nom et e-mail) des députés de France à partir de l'URL de la page qui liste alphabétiquement
  # tous les députés de France, si ces informations ont pu être trouvées, sous la forme d'un array de hashes de trois clés
  # et renvoie nil si ces informations n'ont pas pu être trouvées
  all_deputies_informations_hashes_array = []
  page = get_page(deputies_list_url) # Ouvre et parse la page HTML dont on donne l'URL et la stocke dans l'objet page
  if !page.nil? && page.instance_of?(Nokogiri::HTML::Document)
    title = page.xpath('/html/head/title').text
    puts "Je vais scrapper la page intitulée \"#{title}\" (\"#{deputies_list_url}\")."
    all_deputies_urls_links = page.xpath("/html/body/div[1]/div[2]/div/div/section/div/article/div[3]/div/div[3]/div//ul/li/a")
    if !all_deputies_urls_links.nil? && all_deputies_urls_links.instance_of?(Nokogiri::XML::NodeSet)
      puts "Il y a #{all_deputies_urls_links.length} URLs de pages pour les députés de France."
      all_deputies_urls_links.each do |deputy_url_link|
        deputy_full_name = deputy_url_link.text
        deputy_url = "https://www2.assemblee-nationale.fr" + deputy_url_link['href']
        puts "La page du député dont le nom complet est \"#{deputy_full_name}\" a pour URL \"#{deputy_url}\"."
        if !deputy_url.nil?
          deputy_informations_hash = get_deputy_informations(deputy_url)
          all_deputies_informations_hashes_array << deputy_informations_hash
        end
      end
    end
  end
  all_deputies_informations_hashes_array
end

deputies_list_url = "https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"
all_deputies_informations_hashes_array = get_deputies_informations(deputies_list_url)
puts "Voici le fameux array de hashes des informations essentielles (prénom, nom et e-mail) des députés de France:"
puts "#{all_deputies_informations_hashes_array}"
