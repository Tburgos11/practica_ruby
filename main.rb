
puts 'Practicando Ruby'

# Requiere las librerías necesarias para el scraping y manejo de archivos CSV
require 'open-uri'   # Permite abrir URLs como si fueran archivos
require 'nokogiri'   # Permite parsear HTML fácilmente
require 'csv'        # Permite leer y escribir archivos CSV

# Clase principal para extraer confesiones y guardarlas en un archivo CSV
class Extractor
  attr_accessor :archivo, :url

  # Inicializa el extractor con el nombre del archivo CSV
  def initialize(archivo)
    @archivo = archivo
  end

  # Limpia el archivo CSV, dejándolo vacío
  # Se utiliza para reiniciar el archivo antes de guardar nuevos datos
  def limpiar(archivo)
    CSV.open(archivo, 'w') do |csv|
      # No se escribe nada, solo se limpia el archivo
    end
  end 

  # Guarda una fila de datos en el archivo CSV
  # Recibe un arreglo con los datos a guardar
  def guardar(archivo, datos)
    CSV.open(archivo, 'a') do |csv|
      csv << datos
    end
  end

  # Extrae los datos de confesiones de una página web específica
  # url: dirección de la página a scrapear
  def obtenerDatos(url)
    puts "Scrapeando #{url}..." # Mensaje informativo
    confiesaloHTML = URI.open(url)         # Abre la URL
    datos = confiesaloHTML.read            # Lee el contenido HTML
    parsed_content = Nokogiri::HTML(datos) # Parsea el HTML

    # Busca el contenedor principal de las confesiones
    datosContenedor = parsed_content.css('.infinite-container')

    # Itera sobre cada confesión encontrada en la página
    datosContenedor.css('.infinite-item').each do |confesiones|
      # Extrae el header con la información meta de la confesión
      header = confesiones.css('div div.row').css('.meta__container--without-image').css('.row')

      # Extrae la sección con más información (likes/dislikes)
      masInfo = confesiones.css('div.row').css('.read-more')

      # Obtiene el ID del autor (usado para identificar los votos)
      id_author = header.css('.meta__info').css('.meta__author').css('a').css('a:nth-child(3)').inner_text[1..-1]

      # Obtiene el nombre del autor
      author = header.css('.meta__info').css('.meta__author').at_css('a').inner_text[0..6]

      # Extrae la fecha y hora de la confesión
      date = header.css('.meta__info').css('.meta__date').inner_text.strip.split(' ')

      # Si la fecha está completa, la formatea; si no, la deja en nil
      unless date[5].nil?
        strFecha = date[1] + ' ' + date[2] + ' ' + date[3][0..3]
        strHour = date[4] + ' ' + date[5]
      else
        strFecha = nil
        strHour = nil
      end

      # Extrae el texto de la confesión
      content = confesiones.css('div.row').css('.post-content-text').inner_text.gsub("\n", '')

      # Extrae el número de likes y dislikes usando el ID del autor
      nrolikes = masInfo.css('span').css("#votosup-#{id_author}").inner_text
      nrodislikes = masInfo.css('span').css("#votosdown-#{id_author}").inner_text

      # Genera un número aleatorio de comentarios (simulado)
      nroComentarios = rand(1..100)

      # Guarda todos los datos extraídos en el archivo CSV
      guardar(archivo, [author.to_s, strFecha.to_s, strHour.to_s, nrolikes.to_i, nrodislikes.to_i, nroComentarios.to_i ,content.to_s])
    end
    print "confesiones.csv actualizado " # Mensaje de confirmación
  end
end

# Mensaje de bienvenida al usuario
puts "Bienvenido al sistema para extraer confesiones"

# Solicita al usuario el número de páginas a extraer
puts "Ingrese nro páginas: "
paginaFinal = gets().to_i

# Inicializa la página actual y el extractor
paginaActual = 1
extractor = Extractor.new("confesiones.csv")

# Limpia el archivo CSV y escribe la cabecera
extractor.limpiar(extractor.archivo)
extractor.guardar(extractor.archivo, %w[Autor Fecha Hora nrolikes nrodislikes nroComentarios texto])

nroLinea = 1 # Variable no utilizada actualmente

# Itera sobre las páginas indicadas por el usuario
while (paginaActual<=paginaFinal)
    link = "https://confiesalo.net/?page=#{paginaActual}" # Construye el link de la página
    linea = extractor.obtenerDatos(link)                  # Extrae y guarda los datos
    paginaActual+=1                                       # Avanza a la siguiente página
end

# Mensaje final
puts "Nota: No comparta las confesiones... XD"



