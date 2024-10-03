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
  var velocidad = 100
  var energia = 100
  const imagen 
  const position = new MutablePosition(x=0, y=0)

  method image() = imagen
  method position() = position

  method cansarse(movimiento) {
    energia = energia + (movimiento/2)
    velocidad = velocidad - (energia/10)  
  }


method moverteArriba(pos) {
    self.cansarse(pos)
    position.goUp(pos)
  }
  
method moverteAbajo(pos) {
    self.cansarse(pos)
    position.goDown(pos)
  }

method moverteDerecha(pos) {
    self.cansarse(pos)
    position.goRight(pos)
  }
method moverteIzquierda(pos) {
    self.cansarse(pos)
    position.goLeft(pos)
  }





  
