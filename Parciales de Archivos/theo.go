package main

import (
	"fmt"
)

type Ingresante struct {
	Apellido       string
	Nombre         string
	Ciudad         string
	NacimientoDia  int
	NacimientoMes  int
	NacimientoAnio int
	Titulo         bool
	Carrera        string // APU, LI, LS
}

type node struct {
	val  Ingresante
	next *node
}

type List struct {
	first, last *node
}

func New() List {
	return List{}
}

func (self *List) IsEmpty() bool {
	return self.first == nil
}

func (self *List) PushBack(elem Ingresante) {
	nodo := &node{val: elem}
	if self.first == nil {
		self.first = nodo
		self.last = nodo
	} else {
		self.last.next = nodo
		self.last = nodo
	}
}

func (self *List) RemoveInvalidos() {
	var prev *node
	actual := self.first

	for actual != nil {
		if !actual.val.Titulo {
			if prev == nil {
				self.first = actual.next
			} else {
				prev.next = actual.next
			}
			if actual == self.last {
				self.last = prev
			}
			actual = actual.next
			continue
		}
		prev = actual
		actual = actual.next
	}
}

func (self *List) MostrarBariloche() {
	actual := self.first
	for actual != nil {
		if actual.val.Ciudad == "Bariloche" {
			fmt.Printf("Nombre: %s %s\n", actual.val.Nombre, actual.val.Apellido)
		}
		actual = actual.next
	}
}

func (self *List) AnioMayorCantidad() int {
	cantidades := make(map[int]int)
	actual := self.first
	for actual != nil {
		anio := actual.val.NacimientoAnio
		cantidades[anio]++
		actual = actual.next
	}

	maxAnio := 0
	maxCant := 0
	for anio, cant := range cantidades {
		if cant > maxCant {
			maxCant = cant
			maxAnio = anio
		}
	}
	return maxAnio
}

func (self *List) CarreraConMasInscriptos() string {
	contador := map[string]int{"APU": 0, "LI": 0, "LS": 0}
	actual := self.first
	for actual != nil {
		contador[actual.val.Carrera]++
		actual = actual.next
	}

	maxCarrera := ""
	max := 0
	for carrera, cant := range contador {
		if cant > max {
			max = cant
			maxCarrera = carrera
		}
	}
	return maxCarrera
}

// Main de prueba
func main() {
	lista := New()

	// Agregamos algunos ingresantes
	lista.PushBack(Ingresante{"Gonzalez", "Ana", "Bariloche", 12, 5, 2002, true, "LI"})
	lista.PushBack(Ingresante{"Perez", "Juan", "Neuquen", 3, 11, 2001, false, "APU"})
	lista.PushBack(Ingresante{"Martinez", "Laura", "Bariloche", 8, 7, 2002, true, "LS"})
	lista.PushBack(Ingresante{"Rodriguez", "Carlos", "Bariloche", 15, 4, 2003, true, "LI"})
	lista.PushBack(Ingresante{"Sanchez", "Lucia", "Mendoza", 23, 6, 2002, false, "LI"})
	lista.PushBack(Ingresante{"Fernandez", "Pedro", "Córdoba", 1, 1, 2002, true, "APU"})

	// a) Mostrar ingresantes de Bariloche
	fmt.Println("Ingresantes de Bariloche:")
	lista.MostrarBariloche()

	// b) Año con más nacimientos
	masNacidos := lista.AnioMayorCantidad()
	fmt.Printf("\nAño con más nacimientos: %d\n", masNacidos)

	// c) Carrera con más inscriptos
	carrera := lista.CarreraConMasInscriptos()
	fmt.Printf("\nCarrera con más inscriptos: %s\n", carrera)

	// d) Eliminar los que no presentaron título
	lista.RemoveInvalidos()
	fmt.Println("\nLista luego de eliminar ingresantes sin título:")
	actual := lista.first
	for actual != nil {
		fmt.Printf("- %s %s (%s)\n", actual.val.Nombre, actual.val.Apellido, actual.val.Carrera)
		actual = actual.next
	}
}