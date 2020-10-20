class NaveEspacial {
	var property velocidad = 0
	var property direccion = 0	
	var property combustible = 0
	
	method acelerar(cuanto) { 
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) { velocidad -= cuanto }
	
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol() { direccion = direccion + 1 }
	method alejarseUnPocoDelSol() { direccion = direccion - 1 }
	
	method cargarCombustible(cuanto) { combustible += cuanto }
	method descargarCombustible(cuanto) { combustible -= cuanto }

	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() {
		return combustible >= 4000 and velocidad <= 12000 
	}
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	

	method escapar() {
		
	}
	
	// método abstracto
	method avisar()
	
	method estaDeRelajo() {
		return self.estaTranquila() and self.tienePocaActividad()
	}
	
	// método abstracto
	method tienePocaActividad()
}


class NaveBaliza inherits NaveEspacial {
	var property baliza = null
	var property cambioBalizaAlgunaVez = false
	
	method cambiarColorDeBaliza(colorNuevo){
		self.baliza(colorNuevo)
		self.cambioBalizaAlgunaVez(true)
	}
	
	override method prepararViaje() {
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila(){
		return super() and self.baliza() != "rojo"
	}
	
	override method escapar(){
		self.irHaciaElSol()
	}
	
	override method avisar(){
		self.baliza("rojo")
	}
	
	override method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	override method tienePocaActividad(){
		return not self.cambioBalizaAlgunaVez()
	}
	
	override method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad()
	}
}

class NaveDePasajeros inherits NaveEspacial {
	var property pasajeros = 0
	var property racionesDeComida = 0
	var property racionesDeBebida = 0
	var racionesServidas = 0
	
	method cargarComida(cuantasRaciones) {
//		racionesDeComida = racionesDeComida + cuantasRaciones 
		racionesDeComida += cuantasRaciones 
	}
	method descargarComida(cuantasRaciones) {
		racionesDeComida = (racionesDeComida - cuantasRaciones).max(0)
		racionesServidas += cuantasRaciones
	}
	method cargarBebida(cuantasRaciones) {
		racionesDeBebida += cuantasRaciones 
	}
	method descargarBebida(cuantasRaciones) {
		racionesDeBebida = 
			(racionesDeBebida - cuantasRaciones).max(0)
	}
	override method prepararViaje() {
		super()
		self.cargarComida(pasajeros * 4)
		self.cargarBebida(pasajeros * 6)
		self.acercarseUnPocoAlSol()
	}

	override method escapar() {
		self.acelerar(self.velocidad()*2)
	} 
	
	override method avisar() {
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
	}

	override method tienePocaActividad() {
		return racionesServidas < 50
	}
	
	override method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	override method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad() 
	}
}

class NaveDeCombate inherits NaveEspacial {
	const property mensajesEmitidos = []
	var property esVisible = false
	var property misilesDesplegados = false
	
//	Mensajes
	method emitirMensaje(mensaje) {
		self.mensajesEmitidos().add(mensaje)
	}
	method emitioMensaje(mensaje) {
		return self.mensajesEmitidos().contains(mensaje)
	}
	method primerMensajeEmitido() {
		return self.mensajesEmitidos().first()
	}
	
	method ultimoMensajeEmitido(){
		return self.mensajesEmitidos().last()
	}
	
	method esEscueta(){
		return self.mensajesEmitidos().any({mensaje => mensaje.size() > 30})
	}
	
	override method prepararViaje() {
		super()
		self.acelerar(15000)
		self.ponerseVisible()
		self.replegarMisiles()
		self.emitirMensaje("Saliendo en misión")
		
	}
	method misilesDesplegados() {
		return self.misilesDesplegados() 
	}
	method estaVisible() {
		return self.esVisible()
	}
	
	method ponerseVisible(){
		self.esVisible(true)
	}
	
	method ponerseInvisible() {
		self.esVisible(false)
	}
	
	override method estaTranquila() {
		return super() and not self.misilesDesplegados()
	}

	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	} 
	
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}

	override method tienePocaActividad() {
		return true
	}
	
	method replegarMisiles(){
		self.misilesDesplegados(false) 
	}
	
	method desplegarMisiles(){
		self.misilesDesplegados(true)
	}
	
	override method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	override method estaDeRelajo(){
		return self.esEscueta()
	}
	
}

class NaveHospital inherits NaveDePasajeros {
	
	var property quirofanosPreparados = false
	
	override method estaTranquila() {
		return super() and not self.quirofanosPreparados()
	}
	
	override method recibirAmenaza() {
		super()
		self.quirofanosPreparados(true)
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	
	override method estaTranquila() {
		return super() and self.estaVisible()
	}
	
	override method escapar() {
		super()
		super().desplegarMisiles()
		self.ponerseInvisible()
	}
}

class NaveDeCombateSigilosaPlus inherits NaveDeCombateSigilosa {
	override method estaVisible() {
		return false
	}
}

