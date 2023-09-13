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

router.get('/getExam/:name', (req, res) => {
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

router.get('/generatedTests/:student_id/:exam_id', async (req, res) => {
    const { student_id, exam_id } = req.params;
    const sql = `SELECT * FROM GeneratedTests WHERE exam_id = '${exam_id}' AND student_id = '${student_id}'`;

    try {
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

            let json = JSON.parse(JSON.stringify(results));
            
            for (let i = 0; i < json.length; i++) {
                const element = json[i];
                const questions = await examUtils.getGeneratedTestsQuestions(element.exam_id, element.student_id, element.test_date);
                element.questions = questions;

            }

            res.send(json);
        } else {
            res.status(202).send('No se encontraron notas');
        }
    } catch (error) {
        console.error('Error:', error.message);
        res.status(500).send('Hubo un error al obtener los resultados.');
    }
});


router.get('/grades/:student_id', (req, res) => {
    const { student_id } = req.params;
    const sql = `SELECT * FROM Grades WHERE student_id = '${student_id}'`;

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
          res.send('No se encontraron notas');
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
                    console.log(error.sql);
                    console.log(error.sqlMessage);
                    reject(error);
                } else {
                    resolve();
                }
            });
        });

        const insertions = questions.map((question, index) => {
            return new Promise(async (resolve, reject) => {
                const sql = 'INSERT INTO GeneratedTestQuestions SET ?';
                const generatedTestQuestionsJsonForInsert = {  //El que se usa para insertar en la bbdd
                    student_id: req.body.student_id,
                    exam_id: req.body.exam_id,
                    generated_test_date: dateTime,
                    question_id: question,
                    question_position: index + 1
                };
                const generatedTestQuestionJson = {
                    question_id: question,
                    question_position: index + 1
                }


                examUtils.getQuestionOptions(question).then(options =>{
                    generatedTestQuestionJson.options = options;
                });

                examUtils.getQuestionType(question).then(type =>{
                    generatedTestQuestionJson.type = type;
                });

                conn.query(sql, generatedTestQuestionsJsonForInsert, error => {
                    if (error) {
                        reject(error);
                    } else {
                        resolve(generatedTestQuestionJson);
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
                //Poner un if que se asegure que si is_correct es igual a -1, haga la logica de la tabla de examenes por corregir
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