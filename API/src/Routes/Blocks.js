const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');
const { getLessons } = require('../Helpers/lessosnsUtils');

router.get('/', async (req, res) => {
    try {
        const sql = 'SELECT * FROM Blocks';

        const results = await new Promise((resolve, reject) => {
            conn.query(sql, (error, results) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });

        if (results.length > 0) {
            const json = JSON.parse(JSON.stringify(results));

            // Usamos Promise.all para esperar a que todas las promesas se resuelvan
            await Promise.all(json.map(async (element) => {
                let lessons = await getLessons(element.id);
                console.log(lessons);
                element.lessons = lessons;
            }));

            console.log(json);
            res.json(json); // Enviamos la respuesta con todos los elementos actualizados
        } else {
            res.status(202).send('No se encontraron bloques');
        }
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).send('Hubo un error al obtener los bloques y lecciones.');
    }
});


module.exports = router;