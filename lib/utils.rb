require 'nokogiri' # Appelle la gem Nokogiri, LE parseur HTML de référence pour Ruby
require 'open-uri' # Appelle la gem Open-URI, indispensable pour ouvrir une URL

def get_page(url_to_scrap)
  # Ouvre l'URL souhaitée "url_to_scrap" sous Nokogiri et la stocke dans l'objet "page" qui est retourné si l'URL a pu être trouvée
  # renvoie nil sinon
  page = nil
  if !url_to_scrap.nil? && url_to_scrap.instance_of?(String) && !url_to_scrap.strip.empty?
    puts "L'URL qui vous intéresse est : \"#{url_to_scrap}\"."
    begin
      page = Nokogiri::HTML(URI.open(url_to_scrap))
    rescue OpenURI::HTTPError => e
      if e.message == '404 Not Found'
        puts "Malheureusement, la page \"#{url_to_scrap}\" n'a pas été trouvée." # handle 404 error
      else
        raise e
      end
    rescue Errno::ENOENT => e
      puts "Malheureusement, le fichier \"#{url_to_scrap}\" n'a pas été trouvé." # handle "No such file or directory @ rb_sysopen" error
    rescue SocketError => e # handle "Failed to open TCP connection to ... (getaddrinfo: Name or service not known)" error
      puts "Malheureusement, l'URL \"#{url_to_scrap}\" est incorrecte." # Le domaine peut ne pas exister (DNS error)
    rescue Errno::ECONNREFUSED => e
      puts "Malheureusement, il n'y a aucun serveur en cours d'exécution sur l'adresse IP à laquelle vous voulez vous connecter."
    end
  end
  page
end
