// test 
  /* test "las actividades esforzadas es solo el viaje de 2000 metros" {
    assert.equals([playa2], roque.actividadEsforzada())
  }

  test "error: roque no puede hacer gim porque ya hizo sus 2 actividades maximas" {
    assert.throwsExceptionWithMessage("El socio alcanzo maximo de actividades", { roque.registrarActividad(gim1)})
  }

  */

// >
// <
// && ||

class Actividad {
  const property idiomas = #{}
  method esInteresante() = idiomas.size() > 1
  method sirveParaBroncearse() = true
  method dias()
  method implicaEsfuerzo() = true
}
class ClaseDeGimnasia inherits Actividad {
  method initialize() {
    idiomas.clear()
    idiomas.add("español")
  }
  method validador() { // no se ejecuta nunca. Pero se puede usar en caso de que se pida lanzar un error
    if(idiomas == {"español"}) { self.error("El unico idioma disponible es español")}
  }

  override method dias() = 1
  override method sirveParaBroncearse() = false
}

////////////////////////////////// ej mutual

class Socio {
  const property actividades = []
  const MaxActividades
  var edad
  const idiomas = #{}

  method initialize() {actividades.clear()} // al crear un socio, viene vacio

  method registrarActividad(unaActividad) {
    if(MaxActividades==actividades.size()) {
      self.error("El socio alcanzo maximo de actividades")
    }
    actividades.add(unaActividad)
  }
  method esAdoradorDelSol() = actividades.all({a=>a.sirveParaBroncearse()})
  method actividadEsforzadas() = actividades.filter({a=>a.implicaEsfuerzo()})
  
  method leAtrae(unaActividad) 
}

class SocioTranquilo inherits Socio {
  override method leAtrae(unaActividad) = unaActividad.dias() >= 4

}

class SocioCoherente inherits Socio {
  override method leAtrae(unaActividad) {
    return if(self.esAdoradorDelSol()) {
      unaActividad.sirveParaBroncearse()
    }
    else {unaActividad.implicaEsfuerzo()}
  }
  
}

class SocioRelajado inherits Socio {
  override method leAtrae(unaActividad) {
    return not idiomas.intersection(unaActividad.idiomas()).isEmpty()
  }
  
}

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//# PRACTICA PARCIAL 

class Personaje {
    const fuerza
    const inteligencia
    var property rol
    method potencialOfensivo() {
        return
        fuerza * 10 + rol.extra()
    }
    method esGroso() = self.esInteligente() || self.esGrosoEnSuRol()
    method esInteligente()
    method esGrosoEnSuRol() = rol.esGroso(self)
}

class Orco inherits Personaje {
    override method potencialOfensivo() {
        return
        if(rol==brujo) super() * 1.1 else super()
    }
    override method esInteligente() = false
}

class Humano inherits Personaje {
    override method esInteligente() = inteligencia > 50
}

object guerrero {
    method extra() = 100
    method esGroso(unPersonaje) = unPersonaje.fuerza() > 50
}

class Cazador {
    const property mascota
    method extra() = mascota.extra()
    method esGroso(unPersonaje) = mascota.esLongeva()
}

object brujo {
    method extra() = 0
    method esGroso(unPersonaje) = true
}

class Mascota {
    const property fuerza
    var edad
    method cumplirAños() {edad += 1} 
    const property tieneGarras
    method extra() = if(tieneGarras) fuerza * 2 else fuerza
    method esLongeva() = edad > 10
}

class Localidad {
    var ejercito 
    method ejercito() = ejercito
    method poderDefensivo() = ejercito.poderOfensivo()
    method serOcupada(unEjercito)
}
class Aldea inherits Localidad {

    const cantidadMaximaHabitantes

    override method serOcupada(unEjercito) {
        if(unEjercito.personajes().size() > cantidadMaximaHabitantes) {
            ejercito = unEjercito.ejercitoMasFuerte()
        }
        else {ejercito = unEjercito}
    }
}

class Ciudad inherits Localidad{
    override method poderDefensivo() = super() + 300
    override method serOcupada(unEjercito) {
        ejercito = unEjercito
    }
}

class Ejercito {
    const property personajes = []
    method invadir(unaLocalidad) {
        if(self.puedeTomarLocalidad(unaLocalidad)) {
            unaLocalidad.serOcupada(self)
        }
    }
    method poderOfensivo() = personajes.sum({p=>p.potencialOfensivo()})
    method puedeTomarLocalidad(unaLocalidad) {
        return
        self.poderOfensivo() > unaLocalidad.poderDefensivo()
    }
    method ejercitoMasFuerte() = self.ordenadosLosMasPoderosos().take(10)
    method ordenadosLosMasPoderosos() {
        return
        personajes.sortBy({p1,p2=> p1.potencialOfensivo() > p2.potencialOfensivo()})
    }

}

///////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//# PIRATAS


class BarcoPirata {
  const property tripulantes = []
  var mision
  const capacidad

  method agregarPirata(unPirata) {
    if(mision.cumpleRequisitos(unPirata) && capacidad > tripulantes.size()) {tripulantes.add(unPirata)}
  }
  method cantTripulantes() = tripulantes.size()
  method tieneSuficienteTripulacion() = capacidad * 0.9 <= tripulantes.size()
  method hayTripulanteQueTiene(unItem) = tripulantes.any{t=>t.tiene(unItem)}
  method puedeSerSaqueadoPor(unPirata) = unPirata.estaPasadoDeGrog()
  method esVulnerable(otroBarco) {
    return
    otroBarco.cantidadTripulantes() / 2 >= self.cantTripulantes()
  } 
  method estanTodosPasadosDeGrog() = tripulantes.all({t=>t.estaPasadoDeGrog()})
  method tripulacionNoCalifica(unaMision) = tripulantes.filter({t=>!unaMision.esUtil(t)})
  method cambiarMision(nuevaMision) {
    mision = nuevaMision
    tripulantes.removeAll(self.tripulacionNoCalifica(nuevaMision))
  }
  method anclarEnCiudad(unaCiudad)  {
    self.todosSeTomanGrog(5) 
    self.todosGastan(1)
    self.removerAlMasBorracho()
    unaCiudad.sumarUnHabitante()
  }
  method todosSeTomanGrog(cantidad) {tripulantes.forEach({t=>t.tomarGrog(cantidad)})}
  method todosGastan(cantidad) {tripulantes.forEach({t=>t.gastar(cantidad)})}
  method elMasBoracho() = tripulantes.max({t=>t.nivelDeEbriedad()})
  method removerAlMasBorracho() {tripulantes.remove(self.elMasBoracho())}
  method esTemible() = mision.puedeCompletarMision(self)
  // punto 8 desafío
  method cantidadQueInvito(unPirata) = tripulantes.count({t=>t.invitadoPor()==unPirata})
  method invitadores() = tripulantes.map({t=>t.invitadoPor()}).asSet()
  method elQueMasInvito() = self.invitadores().max({i=>self.cantidadQueInvito(i)})
}

class Ciudadp {
  var habitantes
  method puedeSerSaqueadoPor(unPirata) = unPirata.nivelDeEbriedadMayorA(50)
  method esVulnerable(otroBarco) {
    return otroBarco.cantTripulantes() >= habitantes * 0.4 || 
    otroBarco.estanTodosPasadosDeGrog()
  }
  method sumarUnHabitante() {habitantes += 1}
}


class Pirata {
  var nivelEbriedad
  var monedas
  var property invitadoPor

  method tieneMenosDe(cantidad) = monedas <= cantidad
  const property items = []
  method agregarItem(unItem) {items.add(unItem)}
  method tiene(unItem) = items.contains(unItem)
  method tieneAlMenosItems(cantidad) = items.size() >= cantidad
  method estaPasadoDeGrog() = nivelEbriedad >= 90
  method seAnimaA(unObjetivo) = unObjetivo.puedeSerSaqueadoPor(self)
  method nivelDeEbriedadMayorA(unValor) = nivelEbriedad > unValor
  method esUtil(unaMision) = unaMision.esUtil(self)
  method nivelDeEbriedad() = nivelEbriedad
  method tomarGrog(unaCantidad) {nivelEbriedad += unaCantidad} 
  method gastar(unaCantidad) {monedas = (monedas - unaCantidad).max(0)}
}

class Espia inherits Pirata {
  
}

class Mision {
  method puedeCompletarMision(unBarco) = unBarco.tieneSuficienteTripulacion()
  
}

class BusquedaDelTesoro inherits Mision {
  const itemsRequeridos = #{"brujula","mapa","grog"}
  method requisitoAdicional(unBarco) = unBarco.hayTripulanteQueTiene("llave")
  override method puedeCompletarMision(unBarco) {
    return super(unBarco) && self.requisitoAdicional(unBarco)
  }
  method esUtil(unPirata) = 
    not unPirata.items().asSet().intersection(itemsRequeridos).isEmpty() 
    && unPirata.tieneMenosDe(5)
  method esUtilBis(unPirata) {
    return itemsRequeridos.any({i=>unPirata.tiene(i)}) && unPirata.tieneMenosDe(5)
  }
}

class Leyenda inherits Mision {
  const itemObligatorio
  method esUtil(unPirata) = unPirata.tieneAlMenosItems(10) && unPirata.tiene(itemObligatorio)
}

class Saqueo inherits Mision {
  const objetivo
  method esUtil(unPirata) {
    return unPirata.tieneMenosDe(monedasDeterminadas.valor()) 
    && unPirata.seAnimaA(objetivo)
  } 
}

object monedasDeterminadas {
  var property valor = 0
}