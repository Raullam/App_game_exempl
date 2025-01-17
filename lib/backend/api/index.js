const express = require('express')
const mysql = require('mysql2')
const bodyParser = require('body-parser')
const cors = require('cors')
require('dotenv').config()

const app = express()
const PORT = process.env.PORT || 3000

// Configuración de middleware
app.use(cors())
app.use(bodyParser.json())

// Servir archivos estáticos desde la carpeta de imágenes
app.use('/imagenes', express.static('ruta_a_la_carpeta_de_imagenes'))

// Configuración de la base de datos
const db = mysql.createConnection({
  host: 'localhost',
  user: 'test',
  password: 'test',
  database: 'app_flutter25',
})

// Conexión a la base de datos
db.connect((err) => {
  if (err) {
    console.error('Error al conectar amb la base de dades:', err.message)
  } else {
    console.log('Conectat a la base de dades')
  }
})
// Obtener todas las plantas
app.get('/plantas', (req, res) => {
  const query = 'SELECT * FROM plantas'
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results) // Incluye la columna 'imatge' si está en la base de datos
  })
})

// Obtener todas las plantas de un usuario específico
app.get('/usuaris/:id/plantas', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM plantas WHERE usuari_id = ?'
  db.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results) // Incluye la columna 'imatge' si está en la base de datos
  })
})

// Obtener una planta por ID
app.get('/plantas/:id', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM plantas WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Planta no trobada' })
    }
    res.json(result[0]) // Incluye la columna 'imatge' si está en la base de datos
  })
})

// Crear una nueva planta
app.post('/plantas', (req, res) => {
  const {
    usuari_id,
    nom,
    tipus,
    nivell,
    atac,
    defensa,
    velocitat,
    habilitat_especial,
    energia,
    estat,
    raritat,
    imatge, // Añadimos la imagen en el cuerpo de la solicitud
  } = req.body

  const query = `
            INSERT INTO plantas 
            (usuari_id, nom, tipus, nivell, atac, defensa, velocitat, habilitat_especial, energia, estat, raritat, imatge) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`

  db.query(
    query,
    [
      usuari_id,
      nom,
      tipus,
      nivell || 0,
      atac || 0,
      defensa || 0,
      velocitat || 0,
      habilitat_especial,
      energia || 100,
      estat || 'actiu',
      raritat || 'comú',
      imatge, // Guardamos la imagen en la base de datos
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.status(201).json({
        id: result.insertId,
        usuari_id,
        nom,
        tipus,
        nivell: nivell || 1,
        atac: atac || 10,
        defensa: defensa || 10,
        velocitat: velocitat || 5,
        habilitat_especial,
        energia: energia || 100,
        estat: estat || 'actiu',
        raritat: raritat || 'comú',
        imatge,
      })
    },
  )
})

// Actualizar una planta
app.put('/plantas/:id', (req, res) => {
  const { id } = req.params
  const {
    nom,
    tipus,
    nivell,
    atac,
    defensa,
    velocitat,
    habilitat_especial,
    energia,
    estat,
    raritat,
    imatge,
  } = req.body

  const query = `
            UPDATE plantas 
            SET 
              nom = ?, 
              tipus = ?, 
              nivell = ?, 
              atac = ?, 
              defensa = ?, 
              velocitat = ?, 
              habilitat_especial = ?, 
              energia = ?, 
              estat = ?, 
              raritat = ?, 
              imatge = ?, 
              ultima_actualitzacio = CURRENT_TIMESTAMP  // Actualizamos la fecha de la última actualización
            WHERE id = ?`

  db.query(
    query,
    [
      nom,
      tipus,
      nivell,
      atac,
      defensa,
      velocitat,
      habilitat_especial,
      energia,
      estat,
      raritat,
      imatge,
      id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.json({ message: 'Planta actualitzada correctament' })
    },
  )
})

// Eliminar una planta
app.delete('/plantas/:id', (req, res) => {
  const { id } = req.params
  const query = 'DELETE FROM plantas WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json({ message: 'Planta eliminada correctament' })
  })
})

// Rutas de la API
// Obtener todos los usuarios
app.get('/usuaris', (req, res) => {
  const query = 'SELECT * FROM usuaris'
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json(results)
  })
})

// Obtener un usuario por ID
app.get('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const query = 'SELECT * FROM usuaris WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' })
    }
    res.json(result[0])
  })
})

// Crear un nuevo usuario
app.post('/usuaris', (req, res) => {
  const {
    nom,
    correu,
    contrasenya,
    edat,
    nacionalitat,
    codiPostal,
    imatgePerfil,
  } = req.body
  const query =
    'INSERT INTO usuaris (nom, correu, contrasenya, edat, nacionalitat, codiPostal, imatgePerfil) VALUES (?, ?, ?, ?, ?, ?, ?)'
  db.query(
    query,
    [nom, correu, contrasenya, edat, nacionalitat, codiPostal, imatgePerfil],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.status(201).json({
        id: result.insertId,
        nom,
        correu,
        contrasenya,
        edat,
        nacionalitat,
        codiPostal,
        imatgePerfil,
      })
    },
  )
})

// Actualizar un usuario
app.put('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const {
    nom,
    correu,
    contrasenya,
    edat,
    nacionalitat,
    codiPostal,
    imatgePerfil,
  } = req.body
  const query =
    'UPDATE usuaris SET nom = ?, correu = ?, contrasenya = ?, edat = ?, nacionalitat = ?, codiPostal = ?, imatgePerfil = ? WHERE id = ?'
  db.query(
    query,
    [
      nom,
      correu,
      contrasenya,
      edat,
      nacionalitat,
      codiPostal,
      imatgePerfil,
      id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err.message })
      }
      res.json({ message: 'Usuari actualizat correctament' })
    },
  )
})

// Eliminar un usuario
app.delete('/usuaris/:id', (req, res) => {
  const { id } = req.params
  const query = 'DELETE FROM usuaris WHERE id = ?'
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    res.json({ message: 'Usuari eliminat correctament' })
  })
})

// Buscar un usuario por correo
app.get('/usuaris/correu/:correu', (req, res) => {
  const { correu } = req.params // Obtenemos el correo de los parámetros de la URL
  const query = 'SELECT * FROM usuaris WHERE correu = ?'

  db.query(query, [correu], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message })
    }
    if (result.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' })
    }
    res.json(result[0]) // Devolvemos el usuario encontrado
  })
})

// Inicia el servidor
app.listen(3000, '0.0.0.0', () => {
  console.log('Servidor escoltant a totes les interfícies')
})
