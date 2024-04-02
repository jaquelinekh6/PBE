require "gtk3"
require "thread"
require_relative "puzzle1"

class Window < Gtk::Window
  def initialize
    super
    set_title 'rfid_gtk.rb' 
    set_border_width 10
    set_size_request 500, 200

	#Conecta la señal "destroy" de la ventana para cerrar la aplicación
    signal_connect("destroy") do
      Gtk.main_quit
      @thread.kill if @thread #Detiene la ejecución del thread 
    end

	#Crea un contenedor vertical para organizar los widgets
    @hbox = Gtk::Box.new(:vertical, 6)
    add(@hbox)

	#Crea un Label con un mensaje inicial
    @label = Gtk::Label.new("Por favor, acerque su tarjeta al lector")
    @label.override_background_color(0, Gdk::RGBA.new(0, 0, 1, 1))
    @label.override_color(0, Gdk::RGBA.new(1, 1, 1, 1))
    @label.set_size_request 100, 200
    @hbox.pack_start(@label)

	#Crea un Button para borrar la información de la uid
    @button = Gtk::Button.new(label: 'Clear')
	#Conecta la señal "clicked" del botón para llamar al método on_clear_clicked
    @button.signal_connect('clicked') { on_clear_clicked } 
    @button.set_size_request 100, 50
    @hbox.pack_start(@button)
  end
  #Define el método on_clear_clicked
  def on_clear_clicked
	#Restablece el texto del Label
    @label.set_markup("Por favor, acerque su tarjeta al lector")
    @label.override_background_color(0, Gdk::RGBA.new(0, 0, 1, 1))
    @thread.kill if @thread #Detiene la ejecución del thread 
    rfid #Inicia la lectura del UID del lector RFID
  end

  #Define el método rfid que inicia un thread para leer el UID del lector RFID
  def rfid
    @rfid = Rfid.new
	#Crea un thread para leer el uid
    @thread = Thread.new do
	  #Lee el uid
      uid = @rfid.read_uid
	  #Actualiza el uid leído
      GLib::Idle.add do #para asegurar que se realice en el thread principal y evitar problemas de bloqueo
        @label.set_markup("uid: " + uid)
    	@label.override_background_color(0, Gdk::RGBA.new(1, 0, 0, 1))
        false #una vez actualizado el contenido no vuelve a ejecutarse
      end
    end
  end
end
#Crea una instancia de la clase ventana
win = Window.new
#Muestra todos los objetos de la ventana
win.show_all
#Inicia el método rfid
win.rfid
Gtk.main
