class Jugador {
  const property image
  var property x = -100
  var property y = -100
  var property position = game.at(x, y)
  var property ultimaDireccion = "ninguna"
  var property energia = 100
  var property potencia = 0
  const rangoProximidad = 4

  method ganarPotencia(input) {
    potencia = 30.min(potencia + input)
  }
  method perderPotencia(input) {
    potencia = 0.max(potencia - input)
  }
  method ganarEnergia(input) {
    energia = 100.min(energia + input)
  }
  method perderEnergia(input) {
    energia = 0.max(energia - input)
  }
  method ajustarPorEnergia(cantidad) {
    if (energia >= 80) return cantidad
    else if (energia >= 60) return 0.8* cantidad
    else if (energia >= 40) return 0.6* cantidad
    else if (energia >= 20) return 0.4* cantidad
    else if (energia > 0) return 0.2* cantidad
    else return 0
  }
  method moverseArriba(cantCeldas) {
    if (self.position().y() + self.ajustarPorEnergia(cantCeldas) <= 98) { // no pasa de yBordeSup
      position.goUp(self.ajustarPorEnergia(cantCeldas)) 
      self.perderEnergia(2) 
      ultimaDireccion = "arriba" 
    }
  }
  method moverseAbajo(cantCeldas) {
    if (self.position().y() - self.ajustarPorEnergia(cantCeldas) >= 1) { // no pasa de yBordeInf
      position.goDown(self.ajustarPorEnergia(cantCeldas)) 
      self.perderEnergia(2) 
      ultimaDireccion = "abajo" 
    }
  }
  method moverseDerecha(cantCeldas) { 
    if (self.position().x() + self.ajustarPorEnergia(cantCeldas) <= 209) {  // no pasa de xBordeDer
      position.goRight(self.ajustarPorEnergia(cantCeldas)) 
      self.perderEnergia(2) 
      ultimaDireccion = "derecha" 
    }
  }
  method moverseIzquierda(cantCeldas) {
    if (self.position().x() - self.ajustarPorEnergia(cantCeldas) >= 10) { // no pasa de xBordeIzq
      position.goLeft(self.ajustarPorEnergia(cantCeldas)) 
      self.perderEnergia(2) 
      ultimaDireccion = "izquierda"
    } 
  }
  method seMueveDerecha() = ultimaDireccion == "derecha"
  method seMueveIzquierda() = ultimaDireccion == "izquierda"
  method seMueveArriba() = ultimaDireccion == "arriba"
  method seMueveAbajo() = ultimaDireccion == "abajo"

  method estaCercaDe(algo) = 
    (self.position().x() - algo.position().x()).abs() < rangoProximidad and 
    (self.position().y() - algo.position().y()).abs() < rangoProximidad 

  method llevarPelota(pelota) {
    if (self.estaCercaDe(pelota)) {
      if (self.seMueveDerecha()) {
        pelota.moverse(pelota.position().x() + (rangoProximidad + 1), pelota.position().y())
        self.perderEnergia(1) 
      } 
      else if (self.seMueveIzquierda()) {
        pelota.moverse(pelota.position().x() - (rangoProximidad + 1), pelota.position().y())
        self.perderEnergia(1) 
      }
      else if (self.seMueveArriba()) {
        pelota.moverse(pelota.position().x(), pelota.position().y() + (rangoProximidad + 1))
        self.perderEnergia(1) 
      } 
      else if (self.seMueveAbajo()) {
        pelota.moverse(pelota.position().x(), pelota.position().y() - (rangoProximidad + 1))
        self.perderEnergia(1)
      }
    }
  }
  method patearPelota(pelota){
    if (self.estaCercaDe(pelota)) {
      if (self.seMueveDerecha()) {
        pelota.moverse(pelota.position().x() + self.ajustarPorEnergia(potencia), pelota.position().y())
        self.perderEnergia(25)
      } 
      else if (self.seMueveIzquierda()) {
        pelota.moverse(pelota.position().x() - self.ajustarPorEnergia(potencia), pelota.position().y())
        self.perderEnergia(25)
      }
      else if (self.seMueveArriba()) {
        pelota.moverse(pelota.position().x(), pelota.position().y() + self.ajustarPorEnergia(potencia))
        self.perderEnergia(25)
      } 
      else if (self.seMueveAbajo()) {
        pelota.moverse(pelota.position().x(), pelota.position().y() - self.ajustarPorEnergia(potencia))
        self.perderEnergia(25)
      }
    }
  }
  method agarrarConsumible(consumibles) {
    consumibles.forEach({ consumible =>
      if (self.estaCercaDe(consumible)) {
        consumible.aplicarSobre(self)
        consumible.desaparecer() } 
    })
  }
  method agarrarTarjeta(tarjetas, otroJugador) {
    tarjetas.forEach({ tarjeta =>
      if (self.estaCercaDe(tarjeta)) {
        tarjeta.aplicarTarjeta(self, otroJugador)
        tarjeta.desaparecer() } 
    })
  }
  method decir(texto) = texto
}

class Item {
  const property image
  var property position = game.at(-100, -100)
  
  method moverse(xf, yf) {
    position = game.at(xf, yf)
  }
  method irseDePantalla() {
    self.moverse(-100, -100)
  }
  method moverseAlAzar() {
    position = game.at(12.randomUpTo(208).truncate(0), 2.randomUpTo(96).truncate(0))
  }
}
// Consumibles
class Consumible inherits Item {
  const property energia = 0
  const property potencia = 0
  method aplicarSobre (jugador) {}
  method desaparecer() {}
}
class Agua inherits Consumible (energia = 20, potencia = 5, image = "agua.png") {
	override method aplicarSobre(jugador) {
		jugador.ganarEnergia(energia) // permite 10 pasos más.
    jugador.ganarPotencia(potencia) // llena 1/6 de la potencia máxima.
    game.say(jugador, jugador.decir("Rica agua"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(1000, {
      self.moverseAlAzar() // reaparece luego de 1 seg.
      game.onTick (8000, "el agua se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class Gaseosa inherits Consumible (energia = 30, potencia = 5, image = "coke2.png") {
	override method aplicarSobre(jugador) {
		jugador.ganarEnergia(energia) // permite 15 pasos más.
    jugador.ganarPotencia(potencia) // llena 1/6 de la potencia máxima.
    game.say(jugador, jugador.decir("Rica gaseosa"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(2000, { 
      self.moverseAlAzar() // reaparece luego de 2 seg.
      game.onTick (8000, "la gaseosa se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class Banana inherits Consumible (energia = 40, potencia = 10, image = "bananas.png") {
	override method aplicarSobre(jugador) {
		jugador.ganarEnergia(energia) // permite 20 pasos más.
    jugador.ganarPotencia(potencia) // llena 1/3 de la potencia máxima.
    game.say(jugador, jugador.decir("Rica fruta"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(3000, { 
      self.moverseAlAzar() // reaparece luego de 3 seg.
      game.onTick (6000, "la banana se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class Comida inherits Consumible (energia = 80, potencia = 20, image = "comida.png") {
	override method aplicarSobre(jugador) {
		jugador.ganarEnergia(energia) // permite 30 pasos más.
    jugador.ganarPotencia(potencia) // llena 2/3 de la potencia máxima.
    game.say(jugador, jugador.decir("Rica comida"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(5000, { 
      self.moverseAlAzar() // reaparece luego de 5 seg.
      game.onTick (5000, "la comida se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class BananaPeelDer inherits Consumible (energia = 10, image = "bananaPeel.png") {
	override method aplicarSobre(jugador) {
		jugador.perderEnergia(energia) // permite 5 pasos menos.
    jugador.moverseArriba(5.randomUpTo(15).truncate(0))
    jugador.moverseDerecha(5.randomUpTo(15).truncate(0))
    game.say(jugador, jugador.decir("Noooooooo"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(100, { 
      self.moverseAlAzar() // reaparece casi instantáneamente.
      game.onTick (2000, "la bananaPeelDer se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class BananaPeelIzq inherits Consumible (energia = 10, image = "bananaPeel.png") {
	override method aplicarSobre(jugador) {
		jugador.perderEnergia(energia) // permite 5 pasos menos.
    jugador.moverseAbajo(5.randomUpTo(15).truncate(0))
    jugador.moverseIzquierda(5.randomUpTo(15).truncate(0))
    game.say(jugador, jugador.decir("Noooooooo"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(100, { 
      self.moverseAlAzar() // reaparece casi instantáneamente.
      game.onTick (4000, "la bananaPeelIzq se empieza a mover", {self.moverseAlAzar()}) })
  }
}
// Tarjetas
class Tarjeta inherits Item {
  const property energia
  const property potencia
  method aplicarTarjeta (jugador, jugadorAplicado) {}
  method desaparecer() {}
}
class TarjetaAmarilla inherits Tarjeta (energia = 50, potencia = 10, image = "yellowCard.png") {
	override method aplicarTarjeta(jugador, jugadorAplicado) {
		jugadorAplicado.perderEnergia(energia) // permite 25 pasos menos.
    jugadorAplicado.perderPotencia(potencia) // quita 1/3 de la potencia máxima.
    game.say(jugador, jugador.decir("Toma amarilla"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(5000, { 
      self.moverseAlAzar() // reaparece luego de 5 seg.
      game.onTick (4000, "la tarjAmarilla se empieza a mover", {self.moverseAlAzar()}) })
  }
}
class TarjetaRoja inherits Tarjeta (energia = 100, potencia = 20, image = "redCard.png") {
	override method aplicarTarjeta(jugador, jugadorAplicado) {
	  jugadorAplicado.perderEnergia(energia) // permite 50 pasos menos (inmobiliza).
    jugadorAplicado.perderPotencia(potencia)  // quita 2/3 de la potencia máxima.
    game.say(jugador, jugador.decir("Toma roja!"))
	}
  override method desaparecer() {
    self.irseDePantalla()
    game.schedule(10000, { 
      self.moverseAlAzar() // reaparece luego de 10 seg.
      game.onTick (2000, "la tarjRoja se empieza a mover", {self.moverseAlAzar()}) })
  }
}
// Pelota
class Pelota inherits Item (image = "pelota.png") {
  method entraEnArcoIzq(xIzq, yInf, ySup) = 
    self.position().x() < xIzq and 
    self.position().y() > yInf and
    self.position().y() < ySup

  method entraEnArcoDer(xDer, yInf, ySup) = 
    self.position().x() > xDer and 
    self.position().y() > yInf and
    self.position().y() < ySup
}