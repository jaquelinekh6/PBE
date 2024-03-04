require 'mfrc522' #libreria necesaria para interectuar con el lector RFID-RC522

class Rfid
        def read_uid
        puts "Por favor, acerque su tarjeta al lector" #pedimos al usuario que acerque su tarjeta para identificarse

        #intentamos leer la UID de la tarjeta
        begin

                r = MFRC522.new #creamos una nueva instancia de MFRC522

                r.picc_request(MFRC522::PICC_REQA) #enviamos una solicitud a la RFID para establecer comunicación

                uid_dec, _ = r.picc_select #intentamos leer la UID y almacenamos a la variable "uid_dec"

                rescue CommunicationError #capturamos la excepcion en caso de error de lectura o timeout

                        retry #volvemos a intentarlo

                end

        #convertimos el UID obtenido en hexadecimal y lo concatenamos en una cadena
        uid = Array.new
                uid_dec.length.times do |i|
                        uid[i]=uid_dec[i].to_s(16)
                end

                return uid.join().upcase #retornamos el UID en mayusculas

        end
end

if __FILE__ == $0 #para inicializar el programa

        rf = Rfid.new #creamos una nueva instancia de Rfid
        uid = rf.read_uid #método para leer el UID de la tarjeta
        puts "UID: " + uid #imprimos el UID por pantalla

end
