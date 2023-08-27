const conn = require('../Config/DatabaseConfig');

function getNumQuestions(exam_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT num_questions FROM Exams WHERE name = '${exam_id}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results && results.length > 0) {
                    let resultArray = JSON.parse(JSON.stringify(results));
                    let num_questions = resultArray[0].num_questions;
                    resolve(num_questions);
                } else {
                    resolve(0);
                }
            }
        });
    });
}

function getQuestions(exam_id,num_questions) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT question FROM Questions
        WHERE exam_id = '${exam_id}'
        ORDER BY RAND()
        LIMIT ${num_questions}`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let json = JSON.parse(JSON.stringify(results));
                    let resultArray = [];
                    json.forEach(element => {
                        resultArray.push(element.question);
                    });
                    console.log(resultArray);
                    resolve(resultArray);
                } else {
                    resolve([]);
                }
            }
        });
    });
}

//Ver si elimimo esto
function getQuestionsGeneratedTest(exam_id, student_id, date) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT * FROM GeneratedTestQuestions
            WHERE exam_id = '${exam_id}'
            AND student_id = '${student_id}'
            AND generated_test_date = '${date}'`;

        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let questions = JSON.parse(JSON.stringify(results));
                    resolve(questions);
                } else {
                    resolve([]);
                }
            }
        });
    });
}

function checkAnswer(exam_id, answer) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT checkAnswer('${exam_id}', '${answer}') AS is_correct`;
        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let is_correct = JSON.parse(JSON.stringify(results))[0].is_correct;
                    resolve(is_correct);
                } else {
                    resolve(-1);
                }
            }
        });
    });
}

function checkMaxScore(question_id) {
    return new Promise((resolve, reject) => {
        const sql = `SELECT max_score FROM Questions WHERE question = '${question_id}'`;
        
        conn.query(sql, (error, results) => {
            if (error) {
                reject(error);
            } else {
                if (results.length > 0) {
                    let  max_score = JSON.parse(JSON.stringify(results))[0].max_score;
                    console.log(parseFloat(max_score).toFixed(1));
                    resolve(parseFloat(max_score).toFixed(1));
                } else {
                    resolve(null);
                }
            }
        });
    });
}


  
module.exports = {
    getNumQuestions,
    getQuestions,
    getQuestionsGeneratedTest,
    checkAnswer,
    checkMaxScore
    // Otras funciones separadas por comas...
};