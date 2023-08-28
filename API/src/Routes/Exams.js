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

router.post('/evaluateExam', async (req, res) => {
    try {
        const generatedTestJson = {
            exam_id: req.body.exam_id,
            student_id: req.body.student_id,
            generated_test_date: req.body.generated_test_date,
            answers: req.body.answers
        };

        let num_questions = await examUtils.getNumQuestions(req.body.exam_id);


        if(num_questions == generatedTestJson.answers.length){
            let final_score = 0.0;
            for (const element of generatedTestJson.answers) {
                
                let is_correct = await examUtils.checkAnswer(element.question_id, element.answer);
                let max_score = await examUtils.checkMaxScore(element.question_id);
                
                final_score += (is_correct == -1 ? 0 : is_correct ? max_score : 0)

                let sql = 'UPDATE GeneratedTestQuestions SET '  +
                `answer_text='${element.answer}', ` +
                `score= ${is_correct == -1 ? null : is_correct ? max_score : 0} ` +
                `WHERE exam_id='${req.body.exam_id}' ` +
                `AND student_id='${req.body.student_id}' `+
                `AND question_id='${element.question_id}' `+
                `AND generated_test_date='${req.body.generated_test_date}' `;
    
                await new Promise((resolve, reject) => {
                    conn.query(sql, error => {
                        if (error) {
                            console.log(error.sqlMessage)
                            reject(error);
                        } else {
                            resolve();
                        }
                    });
                });
            }

            examUtils.insertGrades(req.body.exam_id,req.body.student_id, req.body.generated_test_date, final_score)
            .then(result => {
                res.send('Se ha añadido la calificacion');
            })
            .catch(error => {
                console.log(error.sqlMessage);
                res.statusCode = 202;
                res.send(error.sqlMessage);
            });
        }else{
            res.statusCode = 500;
            res.send('envie todas las preguntas');
        }
    } catch (error) {
        res.statusCode = 500;
        res.send(error.message);
    }
});



module.exports = router;