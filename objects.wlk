class Jugador {
  var cansancio = 0
  const imagen 
  const position = new MutablePosition(x=50, y=50)

  method cansancio() = cansancio
  method image() = imagen
  method position() = position

  method recuperarEnergia(energia) {
    if(cansancio - energia < 0){cansancio = 0}else{cansancio -= energia}
  }

  method cansarse(pos) {
    cansancio += pos
  }

  method moverteArriba(pos) {
    if (pos-(cansancio/100) <= 0){position.goUp(0)} 
    else {
    self.cansarse(pos) 
    position.goUp(pos-(cansancio/100))
    }
  }

  method moverteAbajo(pos) {
    if (pos-(cansancio/100) <= 0){position.goDown(0)} 
    else {
    self.cansarse(pos) 
    position.goDown(pos-(cansancio/100))
    }
  }

  method moverteDerecha(pos) {
    if (pos-(cansancio/100) <= 0){position.goRight(0)} 
    else {
    self.cansarse(pos) 
    position.goRight(pos-(cansancio/100))
    }
  }

  method moverteIzquierda(pos) {
    if (pos-(cansancio/100) <= 0){position.goLeft(0)} 
    else {
    self.cansarse(pos) 
    position.goLeft(pos-(cansancio/100))
    }
  }

  method hablar() = "Rico refresco!"
}

class Consumible {
  const energia
  const imagen

  method energia() = energia
  method image() = imagen

  var property position = game.center()
  method movete() {
    const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0)
    position = game.at(x,y)
  }
}




  
