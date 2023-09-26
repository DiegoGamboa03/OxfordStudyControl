const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');
const lessonUtils = require ('../Helpers/lessosnsUtils');
const examUtils = require ('../Helpers/examsUtils');
const { getSignedUrl } = require('../Helpers/googleCloudUtils.js');

router.get('/:name', (req, res) => {
    const { name } = req.params;
    const sql = `SELECT L.*, R.url AS resource_url
    FROM Lessons L
    LEFT JOIN Resources R ON L.name = R.lesson
    WHERE L.name = '${name}';`;

    conn.query(sql, async (error, results) => {
        
        if (results.length > 0) {
            let url = await getSignedUrl(results[0].file_name);
            console.log(url);
            results[0].url = url;
            res.json(results[0]);
        }
        else if (error){
            res.send(error.message);
            return;
        }
        else{
          res.statusCode = 202;
          res.send('No se encontraron usuarios');
          return;
        }
    });
});

router.get('/getLessons/:level_id', async (req, res) => {
    const { level_id } = req.params;
    try {
        let blocks = await lessonUtils.getBlocks(level_id);

        if (blocks.length > 0) {
            const lessonsPromises = blocks.map(async block_id => {
                const sql = `SELECT name FROM Lessons WHERE BLOCK = ${block_id}`; //cambio aqui
                let exam = await examUtils.getExam(block_id);
                const lessons = await new Promise((resolve, reject) => {
                    conn.query(sql, (error, results) => {
                        if (error) {
                            reject(error);
                        } else {
                            resolve(results);
                        }
                    });
                });
                if(exam != null)
                    lessons.push(exam);
                return lessons;
            });

            const lessonsArray = await Promise.all(lessonsPromises);
           // console.log(lessonsArray);
            const allLessons = lessonsArray.flat(); // Combina las lecciones de todos los bloques
           // console.log(allLessons);
            if (allLessons.length > 0) {
                res.json(allLessons);
            } else {
                res.status(202).send('No se encontraron lecciones');
            }
        } else {
            res.status(202).send('No se encontraron bloques');
        }
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).send('Hubo un error al obtener las lecciones.');
    }
});

router.get('/getAllLessons', async (req, res) => {
    let allLessons = {
        "Basico": {},
        "Intermedio": {},
        "Avanzado": {}
    };

    levels = ["Basico","Intermedio","Avanzado"];

    levels.forEach(async level => {
        try {
            let blocks = await lessonUtils.getBlocks(level);

            if (blocks.length > 0) {
                const lessonsPromises = blocks.map(async block_id => {
                    const sql = `SELECT * FROM Lessons WHERE BLOCK = ${block_id}`;
                    let exam = await examUtils.getExam(block_id);
                    const lessons = await new Promise((resolve, reject) => {
                        conn.query(sql, (error, results) => {
                            if (error) {
                                reject(error);
                            } else {
                                resolve(results);
                            }
                        });
                    });
                    if(exam != null)
                        lessons.push(exam);
                    return lessons;
                });
    
                const lessonsArray = await Promise.all(lessonsPromises);
                const lessons = lessonsArray.flat(); // Combina las lecciones de todos los bloques
                if (lessons.length > 0) {
                    allLessons[level] = lessons;
                } else {
                    res.status(202).send('No se encontraron lecciones');
                }
            } else {
                res.status(202).send('No se encontraron bloques');
            }
        res.json(allLessons);
        } catch (error) {
            
        }
    });
    
});

router.get('/getResources/:lesson_id', (req, res) => {
    const { lesson_id } = req.params;
    const sql = `Select * FROM Resources WHERE lesson = '${lesson_id}';`;

    conn.query(sql, (error, results) => {
        
        if (results.length > 0) {
            res.json(results);
        }
        else if (error){
            res.send(error.message);
            return;
        }
        else{
          res.statusCode = 202;
          res.send('No se encontraron examenes');
          return;
        }
        });
});
module.exports = router;