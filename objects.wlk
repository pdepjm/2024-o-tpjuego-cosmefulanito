class Jugador {
  const imagen 
  const position = game.center()
  var cansancio = 0

  method image() = imagen
  method position() = position
  method cansancio() = cansancio

  method consumir(consumible) {
    cansancio = 0.max(cansancio - consumible.energia())
  }

  method efectoAlReves(jugador) {
    keyboard.s().onPressDo({ jugador.moverseArriba(5) })
    keyboard.d().onPressDo({ jugador.moverseIzquierda(5) })
    keyboard.w().onPressDo({ jugador.moverseAbajo(5) })
    keyboard.a().onPressDo({ jugador.moverseDerecha(5) })
  }

  method recuperarEnergia(energia) {
    if(cansancio - energia < 0){cansancio = 0}else{cansancio -= energia}
  }

  method cansarse(pos) {
    cansancio += pos
  }

  method moverseArriba(pos) {
    if (pos-(cansancio/100) <= 0){position.goUp(0)} 
    else {
    self.cansarse(pos) 
    position.goUp(pos-(cansancio/100))
    }
  }

  method moverseAbajo(pos) {
    if (pos-(cansancio/100) <= 0){position.goDown(0)} 
    else {
    self.cansarse(pos) 
    position.goDown(pos-(cansancio/100))
    }
  }

  method moverseDerecha(pos) {
    if (pos-(cansancio/100) <= 0){position.goRight(0)} 
    else {
    self.cansarse(pos) 
    position.goRight(pos-(cansancio/100))
    }
  }

  method moverseIzquierda(pos) {
    if (pos-(cansancio/100) <= 0){position.goLeft(0)} 
    else {
    self.cansarse(pos) 
    position.goLeft(pos-(cansancio/100))
    }
  }

  method decir(texto) = texto
}

class Item {
  const imagen
  const x = 0.randomUpTo(game.width()).truncate(0)
  const y = 0.randomUpTo(game.height()).truncate(0)
  var position = game.at(x, y)

  method image() = imagen
  method position() = position
  method moverse(nuevo_x, nuevo_y) {
    position = game.at(nuevo_x, nuevo_y)
  }
  method moverseAlAzar() {
    const x_random = 0.randomUpTo(game.width()).truncate(0)
    const y_random = 0.randomUpTo(game.height()).truncate(0)
    position = game.at(x_random,y_random)
  }
}

class Consumible inherits Item {
  const energia
  method energia() = energia
}

class TarjetaRoja inherits Item {
  method aplicar(jugador) {
    jugador.cansarse(100) // cuál es la diferencia entre esto y hardcodearle el efecto desde main?
  }
}

class TarjetaAmarilla inherits Item {
  method aplicar(jugador) {
    jugador.cansarse(20)
  }
}
  
