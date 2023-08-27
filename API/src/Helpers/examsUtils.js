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


  
module.exports = {
    getNumQuestions,
    getQuestions
    // Otras funciones separadas por comas...
};