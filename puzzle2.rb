require "gtk3"
require "thread"
require_relative "puzzle1"

class Window < Gtk::Window
  def initialize
    super
    set_title 'rfid_gtk.rb'
    set_border_width 10
    set_size_request 500, 200

    @hbox = Gtk::Box.new(:vertical, 6)
    add(@hbox)

    @label = Gtk::Label.new("Por favor, acerque su tarjeta al lector")
    @label.override_background_color(0, Gdk::RGBA.new(0, 0, 1, 1))
    @label.override_color(0, Gdk::RGBA.new(1, 1, 1, 1))
    @label.set_size_request 100, 200
    @hbox.pack_start(@label)

    @button = Gtk::Button.new(label: 'Clear')
    @button.signal_connect('clicked') { on_clear_clicked }
    @button.set_size_request 100, 50
    @hbox.pack_start(@button)

    signal_connect("destroy") do
      Gtk.main_quit
      @thread.kill if @thread
    end
  end

  def on_clear_clicked
    @label.set_markup("Por favor, acerque su tarjeta al lector")
    @label.override_background_color(0, Gdk::RGBA.new(0, 0, 1, 1))
    @thread.kill if @thread
    rfid
  end


  def rfid
    @rfid = Rfid.new
    @thread = Thread.new do
      uid = @rfid.read_uid
      GLib::Idle.add do
        @label.set_markup("uid: " + uid)
    	@label.override_background_color(0, Gdk::RGBA.new(1, 0, 0, 1))
        false
      end
    end
  end
end

win = Window.new
win.show_all
win.rfid
Gtk.main
