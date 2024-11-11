class Jugador {
  var goles = 0
  const imagen 
  const position = game.center()
  var cansancio = 0

  method image() = imagen
  method position() = position
  method cansancio() = cansancio
  method goles() = goles
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
    cansancio = 0.max(cansancio - energia)cansancio = 0.max(cansancio - energia)
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

  method colision(item,jugador, numero) =
    (jugador.position().x() - item.position().x()).abs() < numero and 
        (jugador.position().y() - item.position().y()).abs() < numero
  
  method efectoColision(jugador,item) {
    if (jugador.colision(item,jugador,5)) {
      jugador.aplicar(item)
      game.say(jugador, jugador.decir(item.frase()))
      game.removeVisual(item)
    }
 
  }


 method hacerGol(pelota,jugador){
      if(pelota.estaEnAreaDeGol(pelota)){
        goles += 1
        game.say(jugador, "¡Gol para el Jugador 1! Total: " + goles)
        pelota.moverse(110, 50)
      }
    }

}

class Item {
  const imagen
  var frase 
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

  method frase() = frase
}

class Consumible inherits Item {
  const energia
  method energia() = energia
  method aplicar(jugador,consumible) {
    jugador.recuperarEnergia(energia)
  }
}

class Tarjetas inherits Item {
  var cantidad
  method aplicar(jugador) {
    jugador.cansarse(cantidad) // cuál es la diferencia entre esto y hardcodearle el efecto desde main?
  }
}

class CascaraBanana inherits Item {
  method aplicar(jugador) {
    jugador.moverseArriba(5)
    jugador.moverseDerecha(10)
  }
}

class Pelota inherits Item{
  const arco1X = game.width() / 2 - 5 // Coordenada x de la portería 1 (izquierda)
    const arco1Y = 0 // Coordenada y de la portería 1
    const arco1Ancho = 10 // Ancho de la portería 1
    const arco1Alto = 5 // Alto de la portería 1

    const arco2X = game.width() / 2 - 5 // Coordenada x de la portería 2 (derecha)
    const arco2Y = game.height() - 10 // Coordenada y de la portería 2
    const arco2Ancho = 10 // Ancho de la portería 2
    const arco2Alto = 5 // Alto de la portería 2

    // Marcadores de goles
    const proximidad = 4

    method golpearPelota(jugador, pelota){
      if (jugador.colision(pelota,jugador,4)){
        pelota.direccionarPelota(jugador,pelota)
      }
    }

    method direccionarPelota(jugador,pelota){
       if (jugador.position().x() < pelota.position().x()) {
            pelota.moverse(pelota.position().x() + 3, pelota.position().y())
        } else if (jugador.position().x() > pelota.position().x()) {
            pelota.moverse(pelota.position().x() - 3, pelota.position().y())
        }
        if (jugador.position().y() < pelota.position().y()) {
            pelota.moverse(pelota.position().x(), pelota.position().y() + 3)
        } else if (jugador.position().y() > pelota.position().y()) {
            pelota.moverse(pelota.position().x(), pelota.position().y() - 3)
        }
    }

    method estaEnAreaDeGol(pelota) = pelota.position().x() >= arco1X && pelota.position().x() <= (arco1X + arco1Ancho) &&
        pelota.position().y() >= arco1Y && pelota.position().y() <= (arco1Y + arco1Alto)
   

}
  
