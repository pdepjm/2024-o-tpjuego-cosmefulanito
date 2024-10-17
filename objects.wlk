object pepita {
  var energy = 100
  const position = new MutablePosition(x=0, y=0)

  method image() = "golondrina.png"
  method position() = position

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
    position.goRight(minutes)
    position.goUp(minutes)
  }

}


class Jugador {
  var cansancio = 0
  const imagen 
  const position = new MutablePosition(x=0, y=0)

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
method howAreYou() = "Rica banana"
var edad = 25
}


object banana {
  const energia = 30
  method energia() = energia 

  var property position = game.center()
  method image() = "brasil2.png"
  method movete() {
    const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0)
    position = game.at(x,y)
  }
}




  
