import objects.*

object jueguito{

    const jugador1 = new Jugador (image = "argentino.png", position = new MutablePosition(x=xiJugador1, y=yiTodos))
    const jugador2 = new Jugador (image = "brasilero.png", position = new MutablePosition(x=xiJugador2, y=yiTodos))
    const pelota = new Pelota (position = game.at(xiPelota, yiTodos))
    var configurado = false

    // Consumibles y Tarjetas
	const agua1 = new Agua() const agua2 = new Agua() const agua3 = new Agua() const agua4 = new Agua()
    const gaseosa1 = new Gaseosa() const gaseosa2 = new Gaseosa()
    const comida = new Comida()
    const banana1 = new Banana() const banana2 = new Banana()
    const bananaPeel1 = new BananaPeelDer() const bananaPeel2 = new BananaPeelIzq() const bananaPeel3 = new BananaPeelIzq()
    const amarilla1 = new TarjetaAmarilla() const amarilla2 = new TarjetaAmarilla()
    const roja = new TarjetaRoja()

    const consumibles = [agua1, agua2, agua3, agua4, gaseosa1, gaseosa2, comida, banana1, banana2, bananaPeel1, bananaPeel2, bananaPeel3]
    const tarjetas = [amarilla1, amarilla2, roja]
    
    const xLineaArco1 = 10
    const xLineaArco2 = 208
    const yInfAmbosArcos = 42
    const ySupAmbosArcos = 56

    // Coordenadas iniciales
    const xiJugador1 = 97
    const xiJugador2 = 120
    const yiTodos = 50
    const xiPelota = 110

    // Otros
    var golesJugador1 = 0
    var golesJugador2 = 0

    method inicializar() {
    
        game.title("Fulbot")
        game.boardGround("pitchHorizontal.jpg")
        game.height(100) // tenemos un alto de 100 celdas (1000 pixeles).
        game.width(225) // tenemos un ancho de 225 celdas (2250 pixeles).
        game.cellSize(10) // tenemos celdas de 10x10 pixeles.

        // SONIDO DE FONDO
        const sonidoAmbiente = game.sound("sonidoAmbiente.mp3")
        sonidoAmbiente.shouldLoop(true)
        sonidoAmbiente.play()
        
        var sonidoAmbienteIsOn = true
        keyboard.m().onPressDo({
            if (sonidoAmbienteIsOn) {
                sonidoAmbiente.volume(0)
                sonidoAmbienteIsOn = false
            } else {
                sonidoAmbiente.volume(100)
                sonidoAmbienteIsOn = true
            }
        })
    }
    method iniciarbanderas(){

        // Coordenadas esquinas
        const xBordeIzq = 11
        const xBordeDer = 209
        const yBordeInf = 1
        const yBordeSup = 97
    
        // Corner flags
        const bandera1 = new Item (image = "cornerFlag.png", position = game.at(xBordeIzq, yBordeInf))
        const bandera2 = new Item (image = "cornerFlag.png", position = game.at(xBordeIzq, yBordeSup))
        const bandera3 = new Item (image = "cornerFlag.png", position = game.at(xBordeDer, yBordeInf))
        const bandera4 = new Item (image = "cornerFlag.png", position = game.at(xBordeDer, yBordeSup))

        game.addVisual(bandera1) game.addVisual(bandera2) game.addVisual(bandera3) game.addVisual(bandera4)
    }

    method jugar() {
        self.inicializar()
        self.iniciarbanderas()

        golesJugador1 = 0
        golesJugador2 = 0

        if (!configurado) {    
            keyboard.w().onPressDo({ jugador1.moverseArriba(5) })
            keyboard.a().onPressDo({ jugador1.moverseIzquierda(5) })
            keyboard.s().onPressDo({ jugador1.moverseAbajo(5) })
            keyboard.d().onPressDo({ jugador1.moverseDerecha(5) })
            keyboard.space().onPressDo({ jugador1.patearPelota(pelota) })

            keyboard.up().onPressDo({ jugador2.moverseArriba(5) })
            keyboard.left().onPressDo({ jugador2.moverseIzquierda(5) })
            keyboard.down().onPressDo({ jugador2.moverseAbajo(5) })
            keyboard.right().onPressDo({ jugador2.moverseDerecha(5) })
            keyboard.backspace().onPressDo({ jugador2.patearPelota(pelota) })
            configurado = true
        }
        // VISUALS
        const listaGrande =[jugador1,jugador2,pelota,agua1, agua2, agua3, agua4, gaseosa1, gaseosa2, comida, banana1, banana2, bananaPeel1, bananaPeel2, bananaPeel3,amarilla1, amarilla2, roja]
        self.crearVisual(listaGrande)

        game.say(jugador1, "Muchaaaaachoooooos") 
        game.say(jugador2, "Eu nao falo portugues...")
        
        // EVENTOS DE INICIO
        game.schedule (1000, { agua1.moverseAlAzar() agua2.moverseAlAzar() })
        game.schedule (2000, { agua3.moverseAlAzar() agua4.moverseAlAzar() })
        game.schedule (3000, { banana1.moverseAlAzar() bananaPeel1.moverseAlAzar() bananaPeel3.moverseAlAzar() })
        game.schedule (4000, { gaseosa1.moverseAlAzar() gaseosa2.moverseAlAzar()})
        game.schedule (6000, { banana2.moverseAlAzar() bananaPeel2.moverseAlAzar() })
        game.schedule (8000, { comida.moverseAlAzar() })
        game.schedule (10000, { amarilla1.moverseAlAzar() amarilla2.moverseAlAzar() })
        game.schedule (20000, { roja.moverseAlAzar() })

        // EVENTOS AUTOMATICOS
        game.onTick (1000, "jugador1 recupera energia", { jugador1.ganarEnergia(10) })
        game.onTick (1000, "jugador2 recupera energia", { jugador2.ganarEnergia(10) })
        game.onTick (100, "chequeo de colisiones", {
            [jugador1, jugador2].forEach({ jugador =>
                jugador.agarrarConsumible (consumibles)
                jugador.llevarPelota (pelota) 
            })
            jugador1.agarrarTarjeta (tarjetas, jugador2)
            jugador2.agarrarTarjeta (tarjetas, jugador1)
            // Arco1
            if (pelota.entraEnArcoIzq(xLineaArco1, yInfAmbosArcos, ySupAmbosArcos)) {
                pelota.irseDePantalla()
                golesJugador2 += 1
                game.say(jugador2, "¡Gol para el Jugador 2! Total: " + golesJugador2)
                //reproducir sonidito.
                game.schedule(3000, {
                    pelota.moverse(xiPelota, yiTodos)
                    self.setearPosicion(jugador1,xiJugador1,yiTodos)
                    self.setearPosicion(jugador2,xiJugador2,yiTodos)
                    //reiniciar posición jugadores.
                })
                self.checkFinal(golesJugador2)
            }
            // Arco2
            if (pelota.entraEnArcoDer(xLineaArco2, yInfAmbosArcos, ySupAmbosArcos)) {
                pelota.irseDePantalla()
                golesJugador1 += 1
                game.say(jugador1, "¡Gol para el Jugador 1! Total: " + golesJugador1)
                //reproducir sonidito.
                game.schedule(3000, {
                    pelota.moverse(xiPelota, yiTodos)
                    self.setearPosicion(jugador1,xiJugador1,yiTodos)
                    self.setearPosicion(jugador2,xiJugador2,yiTodos)
                    //reiniciar posición jugadores.
                })
                self.checkFinal(golesJugador1)
            }
        })
    }

    method crearVisual(lista) { 
        if (lista != [] ){  
            game.addVisual(lista.head())
            lista.remove(lista.head())
            self.crearVisual(lista)
        }
    }

    method removeVisual() {
        game.removeVisual(agua1)
        game.removeVisual(agua2)
        game.removeVisual(agua3)
        game.removeVisual(agua4)
        game.removeVisual(gaseosa1)
        game.removeVisual(gaseosa2)
        game.removeVisual(banana1)
        game.removeVisual(banana2)
        game.removeVisual(comida)
        game.removeVisual(bananaPeel1)
        game.removeVisual(bananaPeel2)
        game.removeVisual(bananaPeel3)
        game.removeVisual(amarilla1)
        game.removeVisual(amarilla2)
        game.removeVisual(roja)
        game.removeVisual(jugador1)
        game.removeVisual(jugador2)
        game.removeVisual(pelota)
    }

    method setearPosicion(jugador,xe,ye) {
        jugador.position(new MutablePosition(x=xe, y=ye))
    } 

    method checkFinal(goles) {
        if(goles == 5) {self.close()}
    }
    
    method close() {
        self.removeVisual()
        game.addVisual(fondo2)
        keyboard.y().onPressDo({game.removeVisual(fondo2) self.menu()})
        keyboard.n().onPressDo({game.stop()})
    }

    method menu() {
        game.addVisual(menuInicio)
        keyboard.enter().onPressDo({game.removeVisual(menuInicio) self.jugar()})
    }     

}