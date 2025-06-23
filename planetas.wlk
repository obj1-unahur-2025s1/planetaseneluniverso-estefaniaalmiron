class Persona {
  var monedas 
  var edad
  method recursos() = 20 + monedas
  method esDestacado() = edad.between(18, 65) || self.recursos() > 30

  method ganar(unaCantidad) = monedas + unaCantidad
  method gastar(unaCantidad) = 0.max(monedas - unaCantidad)
  method cumplirAños() = edad + 1
}


// construcciones

class Muralla {
  const property longitud
  method valor() = longitud * 10
}

class Museo {
  const property superficie 
  const property indiceImportancia
  method valor() = superficie * indiceImportancia  
}

class Planeta {
  const habitantes = #{}
  const construcciones = []

  method habitantes() = habitantes

  method agregar(unHabitante) = habitantes.add(unHabitante)
  method registrar(unaConstruccion) = construcciones.add(unaConstruccion)

  method delegacionDiplomatica() = self.destacados() // falta agregar el de mayor recursos

  method destacados() = habitantes.filter({h => h.esDestacado()}) 

  method elQueMasRecursosTiene() = habitantes.max({h => h.recursos()})
  method elQueMasRecursosTieneEsDestacado() = self.elQueMasRecursosTiene().esDestacado()

  method esValioso() = construcciones.sum({c => c.valor()}) > 100
}