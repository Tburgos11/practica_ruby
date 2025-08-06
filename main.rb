puts 'Taller - Scraping'

#Ejercicio 1
require 'nokogiri'
require 'open-uri'
require 'csv'

url = 'https://talently.tech/trabajos?page=1'


pagina = URI.open(url)
html = Nokogiri::HTML(pagina.read)
doc = html.css('.gap-3 .block')
doc.each do |card|
  titulo = card.css('.text-neutral-700').text.strip
  datos = []
  descripcion = card.css('.line-clamp-3').text.strip
  link = "https://talently.tech"+card.attribute("href").to_s
  card.css('.text-sm').each do |dato|
    if !(dato.text.strip.empty?)
      datos.push(dato.text.strip)
    end
  end
  
  if datos.length >= 2
    empresa = datos[0]
    if datos[1].include?('USD')
      separacion = datos[1].split('USD')
      modalidad = separacion[0].strip
      salario = "USD#{separacion[1]}"
    else
      modalidad = datos[1]
      salario = "No especificado"
    end
    puts "#{titulo} - #{empresa} - #{modalidad} - #{salario}"
  else
    puts "#{titulo} - Datos incompletos"
  end
end


#Ejercicio 2
class Job
  attr_accessor :titulo, :empresa, :modalidad, :salario, :link, :descripcion

  def initialize(datos)
    depureJob(datos)
  end

  def depureJob(datos)
    @titulo = datos[:titulo] || 'sin título'
    @empresa = datos[:empresa] || 'sin empresa'
    @modalidad = datos[:modalidad] || 'sin modalidad'
    @salario = datos[:salario] || 'sin salario'
    @link = datos[:link] || 'sin link'
    @descripcion = datos[:descripcion] || 'sin descripción'
  end
  def saveJob(csv)
    csv << [@titulo, @empresa, @modalidad, @salario, @link, @descripcion]
  end
end

class Scraper
  def initialize(base_url)
    @base_url = base_url
  end

  def getJobs(pages = 10)
    jobs = []
    (1..pages).each do |p|
      url = "#{@base_url}?page=#{p}"
      pagina = URI.open(url)
      html = Nokogiri::HTML(pagina.read)
      doc = html.css('.gap-3 .block')
      doc.each do |card|
        datos = {}
        datos[:titulo] = card.css('.text-neutral-700').text.strip
        datos[:descripcion] = card.css('.line-clamp-3').text.strip
        datos[:link] = "https://talently.tech" + card.attribute("href").to_s
        datos[:empresa] = 'sin empresa'
        datos[:modalidad] = 'sin modalidad'
        datos[:salario] = 'sin salario'
        datos_array = []
        card.css('.text-sm').each do |dato|
          datos_array.push(dato.text.strip) unless dato.text.strip.empty?
        end
        datos[:empresa] = datos_array[0] if datos_array[0]
        if datos_array[1]&.include?('USD')
          separacion = datos_array[1].split('USD')
          datos[:modalidad] = separacion[0].strip.empty? ? 'sin modalidad' : separacion[0].strip
          datos[:salario] = "USD#{separacion[1]}"
        elsif datos_array[1]
          datos[:modalidad] = datos_array[1]
        end
        job = Job.new(datos)
        jobs << job
      end
    end
    jobs
  end
end

scraper = Scraper.new('https://talently.tech/trabajos')
jobs = scraper.getJobs(10)
puts "Se encontraron #{jobs.length} trabajos"
CSV.open('jobs.csv', 'w') do |csv|
  csv << ['Título', 'Empresa', 'Modalidad', 'Salario', 'Link', 'Descripción']
  jobs.each do |job|
    job.saveJob(csv)
  end
end

puts "Datos guardados en jobs.csv"
puts "Fin de Taller"

 