const { Router } = require('express');
const router = new Router();
const conn = require('../Config/DatabaseConfig');
const examUtils = require ('../Helpers/examsUtils');

router.get('/', (req, res) => {
    const sql = 'SELECT * FROM Exams';

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

router.get('/getExam/:id', (req, res) => {
    const { name } = req.params;
    const sql = `SELECT * FROM Exams WHERE name = '${name}'`;

    conn.query(sql, (error, results) => {
        
        if (results.length > 0) {
            res.json(results[0]);
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

router.get('/generate', async (req, res) => {
    try {
        const numQuestions = await examUtils.getNumQuestions(req.body.exam_id);
        const questions = await examUtils.getQuestions(req.body.exam_id, numQuestions);
        
        const today = new Date();
        const date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        const time = today.getHours() + ':' + today.getMinutes() + ':' + today.getSeconds();
        const dateTime = date + ' ' + time;

        const generatedTestJson = {
            student_id: req.body.student_id,
            exam_id: req.body.exam_id,
            test_date: dateTime
        };

        await new Promise((resolve, reject) => {
            const sql = 'INSERT INTO GeneratedTests SET ?';
            conn.query(sql, generatedTestJson, error => {
                if (error) {
                    reject(error);
                } else {
                    resolve();
                }
            });
        });

        const insertions = questions.map((question, index) => {
            return new Promise((resolve, reject) => {
                const sql = 'INSERT INTO GeneratedTestQuestions SET ?';
                const generatedTestQuestionsJson = {
                    student_id: req.body.student_id,
                    exam_id: req.body.exam_id,
                    generated_test_date: dateTime,
                    question_id: question,
                    question_position: index + 1
                };
                
                conn.query(sql, generatedTestQuestionsJson, error => {
                    if (error) {
                        reject(error);
                    } else {
                        resolve(generatedTestQuestionsJson);
                    }
                });
            });
        });

        const generatedQuestionsArray = await Promise.all(insertions);
        generatedTestJson.questions = generatedQuestionsArray;

        res.send(generatedTestJson);
    } catch (error) {
        res.statusCode = 202;
        res.send(error.sqlMessage || error.message);
    }
});


module.exports = router;